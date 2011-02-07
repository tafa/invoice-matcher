
{pack, unpack} = require 'msgpack'


# <code>msgpack.pack</code> isn't an ordinary <code>Buffer</code>.
exports.msgpackToBuffer = (x) ->
  new Buffer(pack(x).toString('base64'), 'base64')



# Ensure we don't return 1. (Easier than trusting/verifying each JS impl)
exports.random = random = () ->
  x = Math.random()
  if x == 1 then 0 else x


# <code>[a, b]</code>
exports.randomInteger = randomInteger = (a, b) ->
  Math.floor(random() * (b - a + 1)) + a


exports.randomToken = randomToken = (n = 8) ->
  alphabet58 = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'
  (for i in [0...n]
    alphabet58.substr randomInteger(0, 57), 1
  ).join('')


