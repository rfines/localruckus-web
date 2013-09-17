template = require 'views/templates/event/detail'
View = require 'views/base/view'
ShareThis = require 'views/shareThis'

module.exports = class EventDetail extends View
  autoRender: false
  className: 'event-detail'
  template: template

  initialize: ->
    super
    @loadAndRender()

  loadAndRender: =>
    @model.fetch
      success: @render

  attach: =>
    super()
    @subview('shareThis', new ShareThis({container: '.shareIcons'}))      

  getTemplateData: =>
    console.log 'getTemplateData'
    td = super
    td.i = @model.imageUrl({height:150, width:266}) || 'http://placehold.it/266x150' 
    console.log td.i
    td