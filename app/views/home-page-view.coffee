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

  events: 
    'submit form' : 'searchEvents'

  listen:
    'geo:newAddress mediator' : 'updateAddress'  

  initialize: (options) ->
    @collection = new Events()
    super(options)
    @startLoading()
    @cookie = $.cookie('localRuckus') || {}
    @searchOptions = options.searchOptions || {near: 66762}
    @loadEvents()
    @subscribeEvent 'event:searchChanged', (searchOptions) =>
      @searchOptions = searchOptions
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
        @stopLoading()

  updateAddress: (addr) ->
    @$el.find('input[name=near]').val(addr)        

  searchEvents: (e) ->
    e.preventDefault()
    near = @$el.find('input[name=near]').val()
    @cookie.near = near
    $.cookie('localruckus', @cookie, { expires: 60 });
    @publishEvent 'event:searchChanged', {near : near}    
    @publishEvent 'geo:newAddress', near