template = require 'views/templates/eventSearch'
View = require 'views/base/view'

module.exports = class EventSearch extends View
  autoRender: true
  template: template

  events: 
    'submit form.eventSearchForm' : 'searchEvents'

  listen:
    'geo:newAddress mediator' : 'updateAddress'   

  initialize: ->
    super()

  searchEvents: (e) ->
    e.preventDefault()
    near = @$el.find('input[name=near]').val()
    o = {near: near}
    if @$el.find('input[name=keyword]').val()
      o.keyword = @$el.find('input[name=keyword]').val()
    @publishEvent 'event:searchChanged', o
    @publishEvent 'geo:newAddress', near

  updateAddress: (addr) ->
    @$el.find('input[name=near]').val(addr)              

  getTemplateData: ->
    td = super()
    td.search = Chaplin.cookieManager.cookie.search || {}
    td