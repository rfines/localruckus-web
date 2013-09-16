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
      i = x.imageUrl({height:150, width:266}) || 'http://placehold.it/266x150'
      eventGallery.append "<div class='col-lg-3'><img src='#{i}' /><a class='thumbnail' href='/event/#{x.id}'>#{x.get('name')}</a>"

  dispose: ->
    console.log 'dispose home page view'
    super