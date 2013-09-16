View = require 'views/base/view'
template = require 'views/templates/header'

module.exports = class HeaderView extends View
  autoRender: true
  className: 'header'
  region: 'header'
  template: template

  events: 
    'submit form' : 'searchEvents'

  searchEvents: (e) ->
    e.preventDefault()
    near = @$el.find('input[name=near]').val()
    @publishEvent 'event:searchChanged', {near : near}