template = require 'views/templates/event/detail'
View = require 'views/base/view'

module.exports = class EventDetail extends View
  autoRender: false
  className: 'event-detail'
  template: template

  initialize: ->
    super
    @loadAndRender()

  loadAndRender: =>
    @model.fetch
      success: @render

  dispose: ->
    console.log 'dispose event detail'
    super