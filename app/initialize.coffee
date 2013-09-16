Application = require 'application'
routes = require 'routes'

$ ->
  $.cookie.json = true;
  new Application {
    title: 'Local Ruckus - Do the Local Thing',
    controllerSuffix: '-controller',
    routes
  }
