template = require 'views/templates/discovery'
View = require 'views/base/view'
EventSearch = require 'views/eventSearch'
EventGallery = require 'views/eventGallery'

module.exports = class HomePageView extends View
  autoRender: true
  className: 'home-page'
  template: template

  initialize: (@options) ->
    @options = @options || {}
    super(options)

  attach: ->
    super()
    @subview('eventSearch', new EventSearch({container: @$el.find('.eventSearch'), searchOptions: @options.searchOptions}))
    @subview('eventGallery', new EventGallery({container: @$el, searchOptions: @options.searchOptions}))
    @publishEvent 'adjustTitle', 'Local Ruckus - Do the Local Thing'

  loadEvents: ->
    @subview('eventGallery')?.loadEvents()