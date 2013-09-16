template = require 'views/templates/home'
View = require 'views/base/view'
Events = require 'models/events'
EventItem = require 'views/eventItem'

module.exports = class HomePageView extends View
  autoRender: false
  className: 'home-page'
  template: template

  initialize: (options) ->
    super(options)
    @searchOptions = options.searchOptions || {near: 66762}
    @loadEvents()
    @subscribeEvent 'event:searchChanged', (searchOptions) =>
      @searchOptions = searchOptions
      console.log @searchOptions
      @loadEvents()

  loadEvents: ->
    @collection = new Events()
    if @searchOptions?.ll
      @collection.ll = "#{@searchOptions.ll}"
      @collection.near = undefined
    else
      @collection.near = "#{@searchOptions.near}" if @searchOptions?.near
    @collection.tags = @searchOptions.tags if @searchOptions?.tags
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