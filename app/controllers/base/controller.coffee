SiteView = require 'views/site-view'
HeaderView = require 'views/header'
FooterView = require 'views/footer'

module.exports = class Controller extends Chaplin.Controller
  beforeAction: ->
    Chaplin.mediator.subscribe 'adjustTitle', (title) =>
      @adjustTitle(title)
    @compose 'site', SiteView
    @compose 'header', HeaderView
    @compose 'footer', FooterView