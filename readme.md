这个项目的源码文件都使用utf-8编码，这与masm默认的unicode编码有所区别。
项目中提供二进制的masm32编译工具及依赖文件（参考罗云彬的书从网络收集，没有验证是否包含病毒）。
项目中提供的二进制[miniblink](https://github.com/weolar/miniblink49/releases)也来源于网络，未验证是否包含病毒。

要编译本项目，仍需要安装如下依赖项辅助编译：
1. [nodejs](https://nodejs.org/zh-cn)

2. 安装好nodejs后执行下面的命令，全局安装[efront](https://www.npmjs.com/package/efront):

```javascript
npm install -g efront
```

安装好依赖项之后，切换到项目目录，执行如下命令编译本项目
```shell
    tools\build.bat apps\mbasm.asm
```

3. 字符串编码
   * `dw`后的字符串将自动转换成utf16编码
   * `db`后的字符串将自动转换成utf8编码
   * `byte`,`word`不转换