View = require 'views/base/view'
template = require 'views/templates/header'

module.exports = class HeaderView extends View
  autoRender: true
  className: 'header'
  region: 'header'
  template: template

  events: 
    'submit form' : 'searchEvents'

  listen:
    'geo:newAddress mediator' : 'updateAddress'

  initialize: ->
    super
    @cookie = $.cookie('localRuckus') || {}

  searchEvents: (e) ->
    e.preventDefault()
    near = @$el.find('input[name=near]').val()
    @cookie.near = near
    $.cookie('localruckus', @cookie, { expires: 60 });
    @publishEvent 'event:searchChanged', {near : near}
    @publishEvent 'geo:newAddress', near

  updateAddress: (addr) ->
    @$el.find('input[name=near]').val(addr)

  getTemplateData: ->
    td = super()
    td.near = @cookie.near if @cookie.near
    td