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
          match = _.find Chaplin.datastore.businesses, (b) =>
            return b.id is @model.get('business')
          if match
            @business = match
            @render()
          else    
            @business = new Business()
            @business.id = @model.get('business')
            @business.fetch
              success: =>
                @render()
        else
          @render()

  getTemplateData: =>
    td = super
    td.tags = @model.get('tags').join(', ')
    td.business = @business.toJSON()
    td.businessId = @business.id
    td.businessName = @business.get('name').trim()
    if not td.cost or td.cost is 0
      td.cost = 'FREE'
    startTime = @model.nextOccurrence()?.format('h:mm a')
    endTime = @model.nextOccurrenceEnd()?.format('h:mm a')
    td.time = "#{@model.nextOccurrence()?.format('h:mm a')} to #{@model.nextOccurrenceEnd()?.format('h:mm a')}"
    td