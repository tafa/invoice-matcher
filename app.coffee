
{apiCall} = require './server/middleware'


module.exports = (app) ->
  
  a = require('./server/actions')(app)
  
  
  app.get '/', (req, res, next) ->
    res.render 'index'
  
  
  app.post '/api/post.js', apiCall, (req, res, next) ->
    invoice = JSON.parse req.x.invoice_json
    a.post_invoice invoice, (invoice, secretToken) ->
      res.api {
        invoice: invoice
        secret_invoice_token: secretToken
      }
  
  app.post '/api/withdraw.js', apiCall, (req, res, next) ->
    token = req.x.secret_invoice_token
    a.withdraw_invoice token, () ->
      res.api {}
  
  app.post '/api/search.js', apiCall, (req, res, next) ->
    a.search_by_time (invoices) ->
      res.api {
        t: new Date().getTime()
        invoices: invoices
      }
