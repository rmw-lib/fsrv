#!/usr/bin/env coffee
import {resolve} from 'path'
import console from './console'
import fs from 'fs/promises'
import {MB, FLAG_END, FLAG_FILE} from './const.mjs'
import LRU from 'lru-cache'

packUInt = (n, size=6)=>
  b = Buffer.allocUnsafe size
  b.writeUIntBE n,0,size
  return b

export class Fsrv
  constructor:(@root, @split=MB, max=2048)->
    @cache = new LRU({
      max
      dispose:(key, fd)=>
        fd.close()
    })

  read:(filepath, offset)->
    {split, cache} = @
    _key = resolve("/"+filepath)
    key = _key[1..]
    fd = cache.get(key)
    try
      if not fd
        fd = await fs.open(@root+_key)
        cache.set(key, fd)
      {size} = await fd.stat()
      diff = size - offset
      if diff <= 0
        return ''

      flag = FLAG_FILE

      r = []
      if diff <= split
        len = diff
        flag |= FLAG_END
      else
        len = split
        if offset == 0
          r.push packUInt(size-split)

      buf = Buffer.allocUnsafe(len)
      await fd.read(buf, 0, len, offset)

      r.push buf

      return [flag, Buffer.concat r]
    catch err
      console.error err
      return ''
      if fd
        cache.del key
        fd.close()


export default (map)=>
  new Fsrv map

