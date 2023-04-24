var { createScoped, STRAP, SCOPED, EXPRESS, createString, STAMP } = compile$common;
var wke_h = path.join(__dirname, "../dlls/wke.h");
var wke_inc = path.join(__dirname, "../coms/wke.inc");
var resolved = /^(type|mask|size|width|length)$/;
var sizemap = {
    short: "word",
    char: 'byte',
    bool: 'byte',
    BOOL: 'dword',
    HDC: 'dword',
    HWND: 'dword',
    int: 'dword',
    double: 'real8',
    DWORD: "dword",
    COLORREF: "dword",
    pointer: 'dword',
    size_t: 'dword',
    __int64: "qword"
};
var defined = Object.create(null);
var data = fs.readFileSync(wke_h).toString().replace(/\/\/.*?(\r\n|\r|\n)|\/\*[\s\S]*?\*\//g, '').replace(/unsigned\s(\w+)/g, (_, w) => w in sizemap ? _ : "unsigned int " + w).replace(/\s*#if\s*(!)?\s*defined\(([\s\S]*?)\)([\s\S]*?)(?:#else([\s\S]*?))?#endif/g, function (_, not, condition, resolve, reject) {
    condition = condition in defined;
    if (not) condition = !condition;
    if (condition) return resolve || '';
    return reject || '';
});
class C extends compile$Program {
    straps = `if,else,return,switch,case,try,catch,break,goto,while,continue,default,do,typedef,struct`.split(',');
};
C.prototype.createScoped = createScoped;
var code = compile$scanner2(data, C);
var prefixes = /^(unsigned|const)$/;
var namedef = function (s) {
    var n = s.next;
    if (n && n.type === EXPRESS) {
        var nn = n.next;
        if (!nn || nn.type !== SCOPED || nn.entry !== "{") {
            return [n];
            throw `未定义结构体${n.text}`;
        }
        var nnn = nn.next;
        if (!nnn) throw `未定义变量名${n.text}`;
        return [n, nn, nnn, nnn.next];
    }
    return;
};
// console.log(code.used.struct);
var sizedef = function (o) {
    while (prefixes.test(o.text)) o = o.next;
    var t = o.text;
    var n = o.next;
    if (n && n.type === STAMP && /^\*+$/.test(n.text)) {
        t = "pointer";
        n = n.next;
    }
    var size = sizemap[t];
    if (!size) {
        if (o.text === 'struct') {
            n = o.next;
            var type = n.text;
            n = n.next;
            if (/^\*+$/.test(n.text)) type = "pointer", n = n.next;
            if (n.type === SCOPED) collect(n), n = n.next;
            size = sizemap[type];
            if (n.text === ';') console.log( name,type,createString([o,o.next,o.next.next,o.next.next.next]))
        }
        else if (o.text === 'enum') {
            n = enumdef(o);
            n = n.prev;
            size = "dword";
        }
        else throw console.log(o), `无法确定类型大小:${o.text} ${t}`;
    }
    if (isArray(size)) {
        size = size[0] + (size[1] ? " " + size[1] + " dup(?)" : "");
    }
    if (!n) throw console.log(o), `无法确定属性名`;
    var name = n.text;
    n = n.next;
    var repeat;
    if (n && n.type === SCOPED && n.entry === '[') {
        repeat = createString(n);
        n = n.next;
    }
    if (n && n.type === STAMP && n.text === '=') {
        throw `暂不支持结构体赋值:${name}`;
    }
    return [name, size, repeat, n && n.next]
};
var collect = function (body) {
    var o = body.first;
    var mp = Object.create(null);
    while (o) {
        var [name, size, repeat, o] = sizedef(o);
        mp[name] = [size, repeat];
    }
    return mp;
}
var procs = Object.create(null);
var procdef = function (n) {
    if (n && prefixes.test(n.text)) n = n.next;
    if (!n) throw console.log(n), `未发现类型名`;
    var type = n.text;
    n = n.next;
    if (n && n.text === ':') n = n.next, type += ":" + n.text, n = n && n.next;
    if (n && /^\*+$/.test(n.text)) n = n.next, type = 'pointer';
    if (!n) throw `未定义类型名`;
    if (n.type !== SCOPED && n.entry !== "(") {
        var name = n.text;
        if (!sizemap[type]) throw console.log(n), `未知类型: ${type}`;
        sizemap[name] = sizemap[type];
        return n;
    }
    if (!n.last) throw `未定义函数名`;
    var name = n.last.text;
    n = n.next;
    if (!n || n.type !== SCOPED && n.entry !== "(") return n;
    var mp = collect(n);
    procs[name] = mp;
    sizemap[name] = "dword";
    return n;
};
var enums = Object.create(null);
var enummap = Object.create(null);
var enumdef = function (e) {
    var nb = namedef(e);
    if (!nb) return;
    var [temp, body, name, next] = nb;
    var inc = 0;
    var mp = Object.create(null);
    createString(body).replace(/\s*,\s*$/, '').split(/\s*,\s*/).forEach(b => {
        var [n, v] = b.trim().split(/\s*=\s*/);
        if (v) inc = v in mp ? mp[v] : +eval(v);
        mp[n] = inc++;
        if (n in enummap) throw `重复定义玫举常量${n}: ${enummap[n]} ${mp[n]}`;
        enummap[n] = mp[n];
    });
    sizemap[name.text] = 'dword';
    enums[name.text] = mp;
    return next;
};
var structs = Object.create(null);
var structdef = function (s) {
    var nb = namedef(s);
    if (!nb) return;
    var [temp, body, name, next] = nb;
    if (!body) {
        var [name, size, repeat, next] = sizedef(s);
        sizemap[name] = [size, repeat];
        return next;
    }
    sizemap[name.text] = name.text;
    if (body.type === SCOPED) structs[name.text] = collect(body);
    return next;
};
var typedef = function (n) {
    switch (n.text) {
        case "struct": return structdef(n);
        case "enum": return enumdef(n);
        default: return procdef(n);
    }
};
var loop = function (code) {
    var o = code.first;
    while (o) switch (o.type) {
        case STAMP:
            o = o.next;
            break;
        case STRAP:
            switch (o.text) {
                case "typedef":
                    var n = o.next;
                    if (!n) throw `缺少类型`;
                    o = typedef(n);
                    break;
                default:
                    o = o.next;
            }
            break;
        default:
            o = o.next;
    }

};
loop(code);

fs.writeFileSync(wke_inc, `${Object.keys(enums).map(k => {
    var nums = enums[k];
    return `;${k} enum\r\n${Object.keys(nums).map(k => `${k} equ ${nums[k]}`).join("\r\n")}\r\n;${k} ende`;
}).join('\r\n\r\n')}\r\n\r\n${Object.keys(structs).map(k => {
    var ucts = structs[k];
    return `${k} struct\r\n    ${Object.keys(ucts).map(k => {
        var [type, repeat] = ucts[k];
        if (resolved.test(k)) k += "_";
        if (repeat) type += " " + repeat + " dup(?)";
        else type += type in structs ? "<?>" : " ?";
        return `${k} ${type}`;
    }).join("\r\n    ")}\r\n${k} ends`;
}).join("\r\n\r\n")}\r\n`);
// console.log(structs)