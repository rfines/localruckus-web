CollectionView = require 'views/base/collection-view'
Events = require 'models/events'
EventItem = require 'views/eventItem'
EventSearch = require 'views/eventSearch'
template = require 'views/templates/eventGallery'

module.exports = class EventGallery extends CollectionView
  autoRender: false
  renderItems: true
  itemView: EventItem
  className : 'eventGallery'
  template: template

  listen:
    'event:searchChanged mediator' : 'searchChanged'

  initialize: (@options) ->
    @collection = new Events()
    @options.collection = @collection
    super(options)
    @startLoading()
    if @options.searchOptions
      @searchOptions = @options.searchOptions
    else
      @searchOptions = {}
      c = Chaplin.cookieManager.cookie
      if c.ll or c.near
        if c.ll
          @searchOptions.ll = c.ll
        else
          @searchOptions.near = c.near
      else
        @searchOptions.near = 64105

  getTemplateData: =>
    td = super()
    td.searchOptions = @searchOptions
    td

  searchChanged: (newOptions) =>
    @startLoading()
    for x in _.keys(newOptions)
      @searchOptions[x] = newOptions[x]
    if newOptions.ll and not newOptions.near
      delete @searchOptions.near
    if newOptions.near and not newOptions.ll
      delete @searchOptions.ll
    console.log @searchOptions
    Chaplin.cookieManager.updateSearch(@searchOptions)
    @loadEvents()  

  loadEvents: =>
    oldCollection = @collection
    @collection = new Events()
    if @searchOptions?.ll
      @collection.ll = "#{@searchOptions.ll}"
      @collection.near = undefined
    else if @searchOptions?.near
      @collection.near = "#{@searchOptions.near}" if @searchOptions?.near
    else
      if oldCollection?.ll
        @collection.ll = "#{oldCollection.ll}"
        @collection.near = undefined
      else if oldCollection?.near
        @collection.near = "#{oldCollection.near}"
    @collection.keyword = @searchOptions.keyword if @searchOptions?.keyword
    @collection.tags = @searchOptions.tags if @searchOptions?.tags
    @collection.start = @searchOptions.start if @searchOptions?.start
    @collection.end = @searchOptions.end if @searchOptions?.end
    @collection.fetch 
      success: =>
        @$el.empty()
        @render()
        if @collection.length is 0
          @$el.find('.emptyState').show()
        @stopLoading()

  initItemView: (model) =>
    new EventItem({model : model, collection : @collection})