CONFIG = require('config')
express = require("express")
app = express()
port = process.env.PORT || 3001
apiProxy = require('./server/apiProxy')

app.configure ->
  app.set('view engine', 'hbs')
  app.set('views', __dirname + '/server/views')
  app.use('/client', express.static(__dirname+'/public'))
  app.use(express.bodyParser())
  app.use(express.cookieParser())
  app.use(express.cookieSession({secret:'secret_heh'}))
  app.use (err, req, res, next) ->
    console.error err.stack
    res.send 500, "Something broke!"
  
#api urls use proxy to set headers
app.get "/api/*", (req, res) ->
  apiProxy.handler(req,res,"GET")
app.post "/api/*", (req,res) ->
  apiProxy.handler(req,res,'POST')
app.put "/api/*", (req,res) ->
  apiProxy.handler(req,res,'PUT')
app.delete "/api/*", (req,res) ->
  apiProxy.handler(req,res,'DELETE')

app.get "/robots.txt", (req, res) ->
  res.set
    'Content-Type': 'text/plain'
  res.render CONFIG.robotsFile

app.get "/*", (req, res) ->
  data =
    development: CONFIG.development
    apiUrl : CONFIG.apiUrl
    baseUrl : CONFIG.baseUrl
  res.render "index.hbs", data

app.listen(port);
console.log "Started LocalRuckus - http://localhost:#{port}"