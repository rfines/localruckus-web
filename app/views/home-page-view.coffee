template = require 'views/templates/home'
View = require 'views/base/view'
CollectionView = require 'views/base/collection-view'
Events = require 'models/events'
EventItem = require 'views/eventItem'

module.exports = class HomePageView extends CollectionView
  autoRender: false
  className: 'home-page'
  template: template
  renderItems: true
  itemView: EventItem
  listSelector: '.eventGallery'

  initialize: (options) ->
    @collection = new Events()
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