express = require('express')
http    = require('http')
path    = require('path')
taskAPI = require('./task')
config  = require('../config')

app     = express()

query = [
  "client_id=" + config.client_id
  "redirect_uri=" + config.redirect_uri
].join('&')

app.set 'port', process.env.PORT || 8080
app.set 'view engine', 'jade'
app.use express.query()
app.use express.static(path.join(__dirname, '../public'))

app.use (req, res, next) ->
  if req.path is '/login/callback'
    if req.query.access_token
      taskAPI.teambition.token = req.query.access_token
      res.redirect('/')
    else if req.query.code
      taskAPI.getToken req.query.code, (err, ret) ->
        if ret.access_token
          taskAPI.teambition.token = ret.access_token
          res.redirect('/')
        else res.json(ret)
  else if not taskAPI.teambition.token
    res.redirect('https://account.teambition.com/oauth2/authorize?' + query)
  else next()

app.get '/', (req, res) -> res.render('index', { title: 'Todo App|Express + Teambition' })

server = http.createServer(app).listen app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'))

require('./socket')(server)