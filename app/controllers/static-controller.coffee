Controller = require 'controllers/base/controller'
StaticView = require 'views/static'


module.exports = class StaticController extends Controller

  terms: ->
    @view = new StaticView({region: 'main', template: require('views/templates/terms')})

  privacy: ->
    @view = new StaticView({region: 'main', template: require('views/templates/privacy')})    