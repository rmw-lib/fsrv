<!-- 本文件由 ./readme.make.md 自动生成，请不要直接修改此文件 -->

# @rmw/xxx

##  安装

```
yarn add @rmw/xxx
```

或者

```
npm install @rmw/xxx
```

## 使用

```coffee
#!/usr/bin/env coffee
import Fsrv from '@rmw/fsrv'
import test from 'tape-catch'
import {FLAG_END} from '@rmw/fsrv/const'

test 'fsrv/fs', (t)=>
  f = Fsrv "/Users/z/rmw-link/fsrv"

  # t.equal "", await fsrv.get("src/index.", 5)
  while 1
    for fp from [
      "src/index.coffee"
      "src/const.mjs"
      "src/console.coffee"
    ]
      offset = 0
      while true
        buf = await f.read(fp, offset)
        if 0 == buf.length
          break

        flag = buf[0]
        buf = buf[1..]

        if FLAG_END&flag
          console.log buf.toString('binary')
          break

        if offset == 0
          size = buf[..5].readUintBE 0,6
          buf = buf[5..]

        offset += buf.length
        console.log buf.toString('binary')
    await new Promise((r) => setTimeout(r, 2000))

  t.end()

```

## 关于

本项目隶属于**人民网络([rmw.link](//rmw.link))** 代码计划。

![人民网络](https://raw.githubusercontent.com/rmw-link/logo/master/rmw.red.bg.svg)
