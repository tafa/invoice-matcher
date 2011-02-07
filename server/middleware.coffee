

exports.apiCall = (req, res, next) ->
  req.x = req.body or {}
  res.api = (y) ->
    j = JSON.stringify y
    res.writeHead 200, {'Content-Type': 'text/javascript'}
    res.end j
  next()

