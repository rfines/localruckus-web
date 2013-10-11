CONFIG = require('config')
express = require("express")
app = express()
port = process.env.PORT || 3001
apiProxy = require('./server/apiProxy')
Mandrill = require("mandrill-api").Mandrill
process.env.MANDRILL_APIKEY = process.env.MANDRILL_APIKEY || CONFIG.email.mandrill.apiKey
process.env.MANDRILL_USERNAME = process.env.MANDRILL_APIKEY || CONFIG.email.mandrill.apiKey

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

app.get "/api/getdefevents", (req, res) ->
  res.redirect(301, "#{CONFIG.hooplaUrl}integrate/widget/524997f03df814cfaf00002b");
  
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

app.post "/lrApi/contact", (req, res) ->
  m = new Mandrill()
  sendOptions = 
    message: 
      text : "Name: #{req.body.name}\n\nMessage: #{req.body.text}"
      subject: req.body.subject
      from_email : req.body.email
      to: [{email:"info@localruckus.com"}]
  success = ->
    res.send 200, {status: 'SUCCESS'}
    res.end()
  error = (err) ->
    res.send 500, err
    res.end()
  console.log 'ready to send'
  m.messages.send sendOptions, success, error

app.get "/*", (req, res) ->
  data =
    development: CONFIG.development
    apiUrl : CONFIG.apiUrl
    baseUrl : CONFIG.baseUrl
    cloudinary : CONFIG.cloudinary
    googleAnalytics : CONFIG.googleAnalytics
  res.render "index.hbs", data

app.listen(port);
console.log "Started LocalRuckus - http://localhost:#{port}"