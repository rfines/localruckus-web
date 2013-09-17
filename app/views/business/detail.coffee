template = require 'views/templates/business/detail'
View = require 'views/base/view'
ShareThis = require 'views/shareThis'

module.exports = class BusinessDetail extends View
  autoRender: false
  className: 'business-detail'
  template: template

  initialize: ->
    super
    @loadAndRender()

  loadAndRender: =>
    @model.fetch
      success: =>
        @render()

  attach: =>
    super()
    @subview('shareThis', new ShareThis({container: '.shareIcons'}))

  getTemplateData: =>
    td = super
    td.i = @model.imageUrl() || 'http://placehold.it/266x150' 
    td.tags = @model.get('tags').join(', ')
    td