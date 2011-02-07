
assert = require 'assert'
http = require 'http'


readText = (s, callback) ->
  chunks = []
  s.on 'data', (data) -> chunks.push data.toString 'utf-8'
  s.on 'end', () -> callback chunks.join ''


api = (fname, x, callback) ->
  j = JSON.stringify x
  opt = {
    host: 'localhost'
    port: 8000
    path: "/api/#{fname}.js"
    method: 'POST'
    headers: {
      'Content-Type': 'application/json'
    }
  }
  req = http.request opt, (res) ->
    readText res, (j2) ->
      if res.statusCode != 200
        console.log '----- Response -----'
        console.log j2
        throw new Error "code #{res.statusCode}"
      try
        y = JSON.parse j2
      catch e
        throw e
      callback y
  req.write j
  req.end()


INVOICES = [
  {
    amount: "0.00"
    currency: "BTC"
    bitcoin_address: "0"
    info: {
      
    }
  }
  {
    amount: "1.11"
    currency: "BTC"
    bitcoin_address: "1"
    info: {
      
    }
  }
  {
    amount: "2.22"
    currency: "BTC"
    bitcoin_address: "2"
    info: {
      
    }
  }
]


module.exports =
  
  misc: (be) ->
    n = 1
    
    api 'post', {invoice_json: JSON.stringify INVOICES[2]}, (y2) ->
      api 'post', {invoice_json: JSON.stringify INVOICES[1]}, (y1) ->
        api 'post', {invoice_json: JSON.stringify INVOICES[0]}, (y0) ->
          api 'withdraw', {secret_invoice_token: y2.secret_invoice_token}, (y2w) ->
            api 'search', {info: {}}, (y) ->
              for x in y.invoices
                delete x.info.t
              assert.eql y.invoices, INVOICES[0...-1]
              n--
    
    be(()->assert.equal n, 0)


