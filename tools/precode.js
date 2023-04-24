var path = require('path');
var fs = require("fs");
var jspath = path.join(__dirname, "../apps/blink.js");
var jsdata = fs.readFileSync(jspath).toString();
var code = compile$scanner2(jsdata);
var { createString, relink, SCOPED, QUOTED, STAMP, STRAP, EXPRESS, VALUE } = compile$common;
code.fix();
var { used, envs, vars } = code;
var requiredObj = Object.create(null);
var asmhead = [];
var asmdata = [];
var asmcode = [
    "call init_kernel32"
];
var asmbody = [];
var asmfoot = [];
var asmproc = [];
var strsmap = Object.create(null), strspam = Object.create(null);
var asmstrW = function (str, db = 'dw') {
    var k = strings.decode(str);
    if (strsmap[str]) return strsmap[str];
    k = k.replace(/[\.\+\-;,\?\<\>\*\&\^\`\~\!#@%\$\:'"\\\[\]\{\}\(\)\|\/\s\u0080-\uffff]/g, "_").slice(0, 6);
    var kd = k, d = 0;
    while (kd in strspam || kd in envs) {
        kd = k + ++d;
    }
    k = kd;
    strsmap[str] = k;
    strspam[k] = str;
    asmdata.push(`${k} ${db} ${str},0,0`)
    return k;
};
var asmstrU = function (str) {
    return asmstrW(str, 'db');
};
if (envs.require) {
    var requiredMap = Object.create(null);
    used.require.forEach(r => {
        var n = r.next;
        if (!n || n.type !== SCOPED || n.entry !== '(') return;
        var f = n.first;
        if (f.type !== QUOTED) return;
        var fn = f.next;
        if (fn && (fn.type !== STAMP || !/^[,;]$/.test(fn.text))) return;
        var p = r.prev;
        if (p.type !== STAMP || p.text !== '=') return;
        var pp = p.prev;
        if (!pp || pp.type !== EXPRESS) return;
        requiredMap[pp.text] = f.text;
        pp.islib = true;
        r.text = "kernel32.LoadLibaray";
        var ppp = pp.prev;
        if (ppp.type === STRAP && /^(let|const|var)$/.test(ppp.text)) {
            pp = ppp;
        }
        var nn = n.next;
        if (nn.type === STAMP && /^[,;]$/.test(nn.text)) n = nn;
        var ppi = code.indexOf(pp);
        var end = code.indexOf(n, ppi);
        code.splice(ppi, end + 1 - ppi);
    });
    for (var k in requiredMap) {
        if (!requiredObj[k]) requiredObj[k] = Object.create(null);
        var obj = requiredObj[k];
        used[k].forEach(u => {
            if (u.islib) return;
            if (!obj[u.text]) obj[u.text] = true;
        });
    }
    Object.keys(requiredObj).map(k => {
        var o = requiredObj[k];
        var k_ = k + "_";
        var ks = Object.keys(o).map(k => k.slice(k_.length));
        asmdata.push(`${k}@ dw ${requiredMap[k]},0`);
        asmdata.push(`${k}$ dword ?`);
        ks.forEach(k => {
            asmdata.push(`${k}@ byte ${strings.encode(k)},0`);
        });
        var s = ks.map(k => `${k} dword ?`).join('\r\n    ');
        var struct = `${k_} struct\r\n    ${s}\r\n${k_} ends`;
        asmbody.push(struct);
        asmdata.push(`${k} ${k_}<${ks.map(k => '0').join(',')}>`)
        asmcode.push(`push offset ${k}@`, `call kernel32.LoadLibrary`, `mov ${k}$,eax`);
        asmfoot.push(`push ${k}$`, `call kernel32.FreeLibrary`);
        ks.forEach(s => {
            delete vars[s];
            asmcode.push(`push offset ${s}@`, `push ${k}$`, `call kernel32.GetProcAddress`, `mov ${k}.${s},eax`);
        });
        delete vars[k];
    })
}
if (envs.asm) {
    used.asm.forEach(c => {
        c.next.isasm = true;
    });
}
var varnames = ["_"];
var getdelta = function (n) {
    return + createString(n).replace(/^\[|\]$/g, '').split(",")[0].trim();
};
var transpile = function (code, varnames) {
    var data = [];
    var proc = [];
    var body = [];
    var foot = [];
    var labelused = Object.create(null);
    var jmp = function (label, jmp = 'jmp') {
        var notfound = label >= unstruted.length;
        label = 'label' + label;
        var label_ = label + ":"
        notfound = notfound && !labelused[label_];
        labelused[label_] = true;
        body.push(`${jmp} ${label}`);
        if (notfound) {
            foot.unshift(label_);
        }
    };
    var unstruted = compile$unstruct(code, a => {
        var vn = varnames[0] + varnames.length;
        varnames.push(vn);
        return vn;
    }, varnames[0]);
    unstruted.forEach((c, i) => {
        body.push(`label${i}:`);
        var helpcomment = () => {
            helpcomment = () => { };
            body.push(`;${createString(c).trim()}`);
        };

        relink(c);
        for (var f = c.first; f; f = n.next) {
            while (f && f.type === STAMP && /[,;]/.test(f.text)) f = f.next;
            if (!f) return;
            var n = f.next;
            if (!n) {
                body.push(createString(c));
                return;
            }
            if (f.type === STRAP && f.text === 'function') {
                var funcname = n.type === EXPRESS && n.text;
                if (!funcname) return;
                delete code.vars[funcname];
                n = n.next;
                var names = [varnames[0] + "_"];
                proc.push(`${funcname} proc ${createString(n)}`);
                n = n.next;
                var [procs, codes, foots] = transpile(n, names);
                proc.push(`    local ${names.concat(n.vars ? Object.keys(n.vars) : [])}`);
                proc.push(...[...procs, ...codes, ...foots].map(c => '    ' + c));
                proc.push(`${funcname} endp`);
            }
            if (f.type === STRAP && f.text === "if") {
                var nf = n.first;
                var jm = 'jnz'
                if (nf.type === STAMP && nf.text === '!') {
                    jm = 'jz';
                    nf = nf.next;
                }
                f = n.next;
                n = f.next;
                var v = nf.type === VALUE ? getValue(nf) : nf.text;
                if (v === 0) {
                    if (jm === 'jz') jm = 'jmp';
                    else continue;
                }
                else if (v === 1) {
                    if (jm === 'jnz') jm = 'jmp';
                    else continue;
                }
                else {
                    if (v !== 'eax') {
                        body.push(`mov eax,${v}`);
                    }
                    body.push(`mov ebx,0`, `cmp eax,ebx`);
                }
                if (f.type === STRAP && f.text === `return`) {
                    jmp(i + getdelta(n), jm);
                }
                continue;
            }
            if (f.type === STRAP && f.text === 'return') {
                jmp(i + getdelta(n));
                continue;
            }
            var assign = null, op = null, name;
            if (n.type === STAMP) {
                if (n.text === '=') {
                    assign = f.text;
                    f = n.next;
                    n = f.next;
                }
                else if (/[^=!]=$/.test(n.text)) {
                    assign = f.text;
                    op = opmap[n.text.slice(0, -1)];
                    if (!op) throw "运算符不支持:" + n.text;
                    f = n.next;
                    n = f.next;
                    name = f.text;
                }
            }
            if (!n || n.type === STAMP && /^[,;]$/.test(n.text)) {
                body.push(`mov eax,${f.type === VALUE ? getValue(f) : f.text}`);
            }
            else if (n.isasm) {
                var t = f.text.slice(4);
                var text = strings.decode(n.text);
                switch (t) {
                    case "code":
                        body.push(text);
                        break;
                    case "data":
                        asmdata.push(text);
                        break;
                    case "foot":
                        foot.push(text);
                        break;
                    case "main":
                    case "head":
                    default:
                        asmhead.push(text);

                }
            }
            else if (n.type === STAMP && !/^[,;]$/.test(n.text)) {
                helpcomment();
                op = opmap[n.text];
                body.push(`mov eax,${f.type === VALUE ? getValue(f) : f.text}`);
                if (!op) throw "运算符不支持:" + n.text;
                f = n.next;
                n = f.next;
                name = f.text;
            }
            else if (n.type === SCOPED && n.entry === "(") {
                helpcomment();
                var tempcode = [];
                n.forEach(function a(cc) {
                    if (cc.type === STAMP && cc.text === ',') return;
                    if (cc.type === VALUE) {
                        tempcode.push(`push ${getValue(cc)}`);
                        return;
                    }
                    if (cc.type !== QUOTED) {
                        tempcode.push(`push ${cc.text}`);
                        return;
                    }
                    tempcode.push(`push offset ${asmstrU(cc.text)}`);
                });
                while (tempcode.length) body.push(tempcode.pop());
                body.push(`call ${f.text}`)
            }
            if (op) {
                body.push(`xor ecx,ecx`, `mov ebx,${name}`, op);
            }
            if (assign) {
                body.push(`mov ${assign},eax`);
            }
            if (!n) break;
        }
    });
    body = body.filter(f => !/:$/.test(f) || f in labelused);
    return [proc, body, foot];
};
var getValue = function (cc) {
    if (!isFinite(cc.text)) {
        var n;
        switch (cc.text) {
            case "null":
                n = 0;
                break;
            case "false":
                n = 0;
                break;
            case "true":
                n = 1;
                break;
            default:
                n = cc.text;
        }
        return n;
    }
    return cc.text;
}
var opmap = {
    "*": "mul ebx",
    "+": "add eax,ebx",
    "/": "div ebx",
    "-": "sub eax,ebx",
};
asmfoot.push('call kernel32.ExitProcess');
var [procs, codes, foot] = transpile(code, varnames);
asmcode = asmcode.concat(codes, foot);
asmproc.push(...procs);
var asmtext = `
${asmhead.join('\r\n')}

${asmbody.join("\r\n")}

.data
${asmdata.join("\r\n")}

${varnames.concat(Object.keys(vars)).map(n => `${n} dword ?`).join("\r\n")}

.code

${asmproc.join("\r\n")}

start:
    ${asmcode.join("\r\n    ")}

    ${asmfoot.join("\r\n    ")}
    end start
`.replace(/\r\n|\r|\n/g, '\r\n');
fs.writeFileSync(path.join(__dirname, '../apps/blink.asm'), asmtext);