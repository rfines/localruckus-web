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
    @publishEvent "showButton"
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
    if not newOptions.end
      delete @searchOptions.end
    Chaplin.cookieManager.updateSearch(@searchOptions)
    @loadEvents()  

  loadEvents: =>
    @publishEvent "showButton"
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
    @collection.radius = @searchOptions.radius if @searchOptions?.radius
    @collection.fetch 
      success: =>
        @$el.empty()
        @render()
        if @collection.length is 0
          @$el.find('.emptyState').show()
          @publishEvent "hideButton"
        else if @collection.length < 50
          console.log @collection.length
          @publishEvent "hideButton"
        @stopLoading()

  initItemView: (model) =>
    new EventItem({model : model, collection : @collection})

  loadMore: =>
    c = new Events()
    c.ll = @collection.ll
    c.near = @collection.near
    c.keyword = @collection.keyword
    c.tags = @collection.tags
    c.start = @collection.start
    c.end = @collection.end
    c.radius = @collection.radius
    c.skip = @collection.skip + 50
    @collection.skip = c.skip
    console.log c
    console.log @collection.skip
    @collection.on "add", (m) ->
      console.log 'added'
    c.fetch 
      success: =>
        console.log 'success'
        console.log c.models.length
        if c.models.length < 50
          @publishEvent "hideButton"
        @collection.add(c.models)
        @$el.empty()
        @render()
        @stopLoading()  