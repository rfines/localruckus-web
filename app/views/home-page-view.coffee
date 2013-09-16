template = require 'views/templates/home'
View = require 'views/base/view'
Events = require 'models/events'
EventItem = require 'views/eventItem'

module.exports = class HomePageView extends View
  autoRender: false
  className: 'home-page'
  template: template
  searchOptions = {}

  initialize: ->
    super
    @loadEvents()
    @subscribeEvent 'event:searchChanged', (searchOptions) =>
      @searchOptions = searchOptions
      @loadEvents()

  loadEvents: ->
    @collection = new Events()
    @collection.ll = "#{@searchOptions.ll}" if @searchOptions?.ll
    @collection.near = "#{@searchOptions.near}" if @searchOptions?.near
    console.log @searchOptions
    @collection.fetch 
      success: =>
        @$el.empty()
        @render()


  attach: () ->
    super()
    eventGallery = @$el.find('.eventGallery')
    for x in @collection.models
      @subview("eventItem-#{x.id}", new EventItem({container: eventGallery, model: x})) 

  dispose: ->
    console.log 'dispose home page view'
    super