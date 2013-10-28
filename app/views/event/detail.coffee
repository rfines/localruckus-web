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
        console.log @model.get('host') != @model.get('business')
        if @model.get('business') and @model.get('host') and (@model.get('host') != @model.get('business'))
          hMatch = _.find Chaplin.datastore.businesses, (b) =>
            return b.id is @model.get('host')
          match = _.find Chaplin.datastore.businesses, (b) =>
            return b.id is @model.get('business')
          if match
            @business = match
            if hMatch
              @host = hMatch
            @render()
          else    
            @business = new Business()
            @business.id = @model.get('business')
            @business.fetch
              success: =>
                
            @host = new Business()
            @host.id = @model.get('host')
            @host.fetch
              success: =>
                @render()
        else if @model.get('business')
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

  
  getTemplateData: =>
    td = super()
    td.tags = toTitleCase(@model.get('tags').join(', '))
    td.business = @business.toJSON()
    td.businessId = @business.id
    td.businessName = @business.get('name').trim()
    if @host
      td.hostName = @host.get('name')
      td.hostAddress = @host.get("location").address
      console.log td.hostName
    if not td.cost or td.cost is 0
      td.cost = 'FREE'
    startTime = @model.nextOccurrence()?.utc().format('h:mm a')
    endTime = @model.nextOccurrenceEnd()?.utc().format('h:mm a')
    if endTime > startTime
      td.time = "#{startTime} to #{endTime}"
    else
      endTime = ''
      td.time= "#{startTime}"
    fixed = []
    for x in @model.get('fixedOccurrences')
      fixed.push "#{moment(x.start).format('MM/DD/YYYY')} from #{startTime} to #{endTime}"
    td.fixed = fixed
    if td.business?.contactPhone?.length >0
      td.showPhone=true
    else
      td.showPhone = false
    if @model.has('contactPhone') or @model.has('contactName') or @model.has('contactEmail') or @model.has('website')
      td.showMoreInfo = true
    else
      td.showMoreInfo = false
    td
    
  events:
    "click .addToCalendar": "addToCalendar"
    "click .closeModal":"closeModal"

  closeModal:(e)->
    e.preventDefault() if e
    $('.calendarModal').modal('hide')
  
  addToCalendar:(e)=>
    e.preventDefault() if e
    calType=$(".calendarSelect").val()
    if calType is 'ical'
      file =@model.getICal()
    else
      gCal = @googleCalUrl()
      window.open(gCal,'_blank')


  googleCalUrl:()=>
    name = encodeURIComponent(@model.get('name'))
    calName = "Local Ruckus: #{name}"
    eventDescription = encodeURIComponent(@model.get('description'))
    sDate = @model.nextOccurrence().format("YYYYMMDDTHHmmss")
    eDate = @model.nextOccurrenceEnd().format("YYYYMMDDTHHmmss")
    d = "#{sDate}/#{eDate}"
    address = @model.get('location').address
    id = @model.id
    return "https://www.google.com/calendar/render?action=TEMPLATE&dates=#{d}&details=#{eventDescription}&location=#{address}&text=#{calName}&sprop=partner:localruckus.com&sprop=partneruuid:#{id}&pli=1&sf=true&output=xml" 
  toTitleCase = (str) ->
    str.replace /\w\S*/g, (txt) ->
      txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()