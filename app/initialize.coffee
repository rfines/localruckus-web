Application = require 'application'
routes = require 'routes'

$ ->
  console.log 'initialize'
  new Application {
    title: 'Local Ruckus - Do the Local Thing',
    controllerSuffix: '-controller',
    routes
  }
