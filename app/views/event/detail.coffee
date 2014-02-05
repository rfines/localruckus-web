template = require 'views/templates/event/detail'
View = require 'views/base/detail'
ShareThis = require 'views/shareThis'
Business = require 'models/business'

module.exports = class EventDetail extends View
  autoRender: false
  className: 'event-detail'
  template: template
  eventTags:[]

  loadAndRender: =>
    @model.fetch
      success: =>
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
    @getTags()
    td.business = @business.toJSON()
    td.businessId = @business.id
    td.businessName = @business.get('name').trim()
    if @model.get('website')?.indexOf('http') is -1
      td.website = "http://#{@model.get('website')}"
    if @model.get('ticketUrl')?.indexOf('http') is -1
      td.ticketUrl = "http://#{@model.get('ticketUrl')}"
    if @host
      td.hostName = @host.get('name')
      td.hostAddress = @host.get("location").address
    if not @model.has('cost')
      td.cost=""
    else if td.cost is 0
      td.cost = 'FREE'
    else
      td.cost = 'Starting at $'+@model.get('cost')+".00"
      
    next = @model.nextOccurrence(moment())
    startTime = moment(next).utc()
    endTime = moment(@model.nextOccurrenceEnd(moment())).utc()
    if endTime and endTime?.isAfter(startTime)
      td.time = "#{moment(startTime).utc().format('h:mm a')} to #{moment(endTime).utc().format('h:mm a')}"
    else
      endTime = ''
      td.time= "#{startTime}"
    fixed = []
    if @model.get('fixedOccurrences')?.length > 0
      for x in @model.get('fixedOccurrences')
        if endTime
          fixed.push "#{moment(x.start).format('MM/DD/YYYY')} from #{startTime.format('h:mm a')} to #{endTime.format('h:mm a')}"
        else
          fixed.push "#{moment(x.start).format('MM/DD/YYYY')} from #{startTime.format('h:mm a')}"
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
  attach:()=>
    super()
    if not @model.has('cost')
      console.log "trying to hide the cost/tickets"
      @$el.find("#cost_dt").hide()
      @$el.find("#cost_dd").hide()
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

  getTagText:(tags, allTags, cb)=>
    tagText = []
    if allTags and allTags.length >0 
      _.each tags, (item)=>
        s= {}
        s = item
        temp =_.find allTags, (tag)=>
          return tag.slug == s
        if temp and tagText.indexOf(temp.text) is -1
          tagText.push temp.text
      cb tagText
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
  getTags:()=>
    url = '/api/eventTag'
    $.ajax
      url: url
      method: "GET"
      success: (response) =>
        @getTagText(@model.get('tags'), response, (arr)=>
          textArr = arr
          if textArr?.length > 1
            joined = textArr.join(", ")
            $('.tags_dd').html(joined)
          else
            joined = textArr.join(", ")
            $('.tags_dd').html(joined)
        )
      error: (error) =>
        console.log error
  toTitleCase = (str) ->
    str.replace /\w\S*/g, (txt) ->
      txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()