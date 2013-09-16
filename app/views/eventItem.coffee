template = require 'views/templates/eventItem'
View = require 'views/base/view'
Business = require 'models/business'

module.exports = class EventItem extends View
  autoRender: false
  className: 'col-lg-2 col-md-3 col-sm-4 col-xs-6 eventItem'
  template: template

  initialize: ->
    super
    @loadAndRender()

  loadAndRender: =>
    if @model.get('business')
      @business = new Business()
      @business.id = @model.get('business')
      @business.fetch
        success: =>
          @render()
    else
      @render()

  getTemplateData: ->
    td = super()
    td.i = @model.imageUrl({height:150, width:266}) || 'http://placehold.it/266x150' 
    td.businessId = @model.get('business')
    td.businessName = @business.get('name') if @business
    td