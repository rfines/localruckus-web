template = require 'views/templates/business/detail'
View = require 'views/base/view'

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

  getTemplateData: =>
    td = super
    td.tags = @model.get('tags').join(', ')
    td