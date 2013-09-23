Application = require 'application'
routes = require 'routes'
CookieManager = require 'cookieManager'
Datastore = require 'datastore'

$ ->
  Chaplin.datastore = new Datastore()
  Chaplin.cookieManager = new CookieManager()
  new Application {
    title: 'Local Ruckus - Do the Local Thing',
    controllerSuffix: '-controller',
    routes
  }

  #  format an ISO date using Moment.js
  #  http://momentjs.com/
  #  moment syntax example: moment(Date("2011-07-18T15:50:52")).format("MMMM YYYY")
  #  usage: {{dateFormat creation_date format="MMMM YYYY"}}
  Handlebars.registerHelper "dateFormat", (context, block) ->
    if window.moment
      f = block.hash.format or "MM/DD/YYYY"
      return moment(context).format(f)
    else
      return context