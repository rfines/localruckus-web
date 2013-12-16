View = require 'views/base/view'
template = require 'views/templates/header'

module.exports = class HeaderView extends View
  autoRender: true
  className: 'header'
  region: 'header'
  template: template

  initialize: ->
    super
  listen: 
    "changeActiveIcon mediator":"changeActiveIcon"
  changeActiveIcon:(className) ->
    console.log "removing active class"
    @$el.find(".active").removeClass 'active'
    @$el.find(className).addClass 'active'
    