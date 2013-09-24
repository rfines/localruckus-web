template = require 'views/templates/business/detail'
View = require 'views/base/detail'
ShareThis = require 'views/shareThis'
Collection = require 'models/base/collection'
Event = require 'models/event'
EventItem = require 'views/eventItem'

module.exports = class BusinessDetail extends View
  autoRender: false
  className: 'business-detail'
  template: template

  initialize: ->
    super
    @events = new Collection()
    @events.model = Event

  getTemplateData: =>
    td = super
    td.tags = @model.get('tags').join(', ')
    td

  loadAndRender: =>
    @model.fetch
      success: =>
        @events.url = "/api/business/#{@model.get('_id')}/events"
        @events.fetch
          success: =>
            @render()

  attach: =>
    super
    for x in @events.models
      if x.nextOccurrence(moment())
        @subview "event-#{x.id}", new EventItem(
          model : x
          collection : @events
          container: @$el.find('.eventGallery')
          className: 'col-lg-6 col-md-6 col-sm-12 col-xs-12 eventItem'
        )