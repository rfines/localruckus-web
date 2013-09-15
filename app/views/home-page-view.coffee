template = require 'views/templates/home'
View = require 'views/base/view'
Events = require 'models/events'

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
      eventGallery.append "<div class='col-lg-3'><a class='thumbnail'>#{x.get('name')}</a>"