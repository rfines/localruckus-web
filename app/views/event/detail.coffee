template = require 'views/templates/event/detail'
View = require 'views/base/detail'
ShareThis = require 'views/shareThis'
Business = require 'models/business'

module.exports = class EventDetail extends View
  autoRender: false
  className: 'event-detail'
  template: template

  loadAndRender: =>
    @model.fetch
      success: =>
          if @model.get('business')
            @business = new Business()
            @business.id = @model.get('business')
            @business.fetch
              success: =>
                @render()
          else
            @render()

  getTemplateData: =>
    td = super
    td.i = @model.imageUrl() || 'http://placehold.it/266x150' 
    td.tags = @model.get('tags').join(', ')
    td.business = @business.toJSON()
    td.businessName = @business.get('name').trim()
    if not td.cost or td.cost is 0
      td.cost = 'FREE'
    startTime = @model.nextOccurrence().format('h:mm a')
    endTime = @model.nextOccurrenceEnd().format('h:mm a')
    td.date = "#{@model.nextOccurrence().format('MM/DD/YYYY')} from #{startTime} to #{endTime}"
    td