Application = require 'application'
routes = require 'routes'

$ ->
  console.log 'initialize'
  $.cookie.json = true;
  console.log $.cookie('localruckus')
  new Application {
    title: 'Local Ruckus - Do the Local Thing',
    controllerSuffix: '-controller',
    routes
  }
