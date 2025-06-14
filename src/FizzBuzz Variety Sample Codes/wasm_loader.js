const fs = require('fs')
const buf = fs.readFileSync('add.wasm')
const mod = new WebAssembly.Module(buf)
const ins = new WebAssembly.Instance(mod, {})
const add = ins.exports.add
console.log(add(10, 21))

