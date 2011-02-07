
{randomToken, msgpackToBuffer} = require './util'


MISC__NUM_INVOICES = 'n'
ZTIME__T = 't'
MAX_RESULTS = 10


module.exports = (app) ->
  
  app.storage = {
    redis_misc: {}
    redis_invoices: {}
    redis_ztime: {}
    redis_secret_tokens: {}
    #redis_code: {}
    #redis_zgeo: {}
  }
  
  
  post_invoice: (invoice, callback) ->
    
    t = new Date().getTime()
    invoice.info.t = t
    secretToken = randomToken 8
    
    app.redis_misc.incr MISC__NUM_INVOICES, (e, r) ->
      packedId = msgpackToBuffer r
      #TODO: async
      app.redis_invoices.set packedId, JSON.stringify(invoice), (e, r) ->
        app.redis_ztime.zadd ZTIME__T, t, packedId, (e, r) ->
          app.redis_secret_tokens.set secretToken, packedId, (e, r) ->
            callback invoice, secretToken
  
  withdraw_invoice: (token, callback) ->
    app.redis_secret_tokens.get token, (e, packedId) ->
      #TODO: async
      app.redis_invoices.del packedId
      app.redis_ztime.zrem ZTIME__T, packedId
      app.redis_secret_tokens.del token
      callback()
  
  search_by_time: (callback) ->
    app.redis_ztime.zrevrange ZTIME__T, 0, MAX_RESULTS, (e, keys) ->
      app.redis_invoices.mget keys, (e, jsons) ->
        invoices = []
        for x in jsons
          if x
            invoices.push JSON.parse x
        callback invoices
  
  