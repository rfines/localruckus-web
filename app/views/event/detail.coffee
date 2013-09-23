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
    td.date = "#{@model.nextOccurrence().format('MM/DD/YYYY')} from #{startTime} to #{endTime}"
    td
  events:
    "click .addToCal": "addToCalendar"
    "click .closeModal":"closeModal"
  closeModal:(e)->
    e.preventDefault() if e
    @$('calendarModal').modal('hide')
  
  addToCalendar:(e)=>
    e.preventDefault() if e
    calType=@$el.find("calendarSelect").val()
    if calType is 'ical'
      file =@model.getICal()
    else
      gCal = @googleCalurl()
      window.open(gCal,'_blank')



  googleCalUrl:()=>
    calName = "Local Ruckus: #{@model.get('name')}"
    eventDescription = @model.get('description')
    sDate = @model.nextOccurrence().format("yyyyMMddTHHmmss")
    address = @model.get('location').address
    id = @model.id
    return "https://www.google.com/calendar/render?action=TEMPLATE&dates=#{sDate}&details=#{eventDescription}&location=#{address}&text=#{calName}&sprop=partner:localruckus.com&sprop=partneruuid:#{id}&pli=1&sf=true&output=xml" 
