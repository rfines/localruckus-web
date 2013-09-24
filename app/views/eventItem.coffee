template = require 'views/templates/eventItem'
View = require 'views/base/view'
Business = require 'models/business'

module.exports = class EventItem extends View
  autoRender: false
  className: 'col-lg-3 col-md-4 col-sm-6 col-xs-12 eventItem'
  template: template
  mapped: false

  events:
    'mouseover .imageOrMap' : 'showMap'
    'mouseout .imageOrMap' : 'showImage'
    'click .imageOrMap' : 'gotoEvent'

  initialize: ->
    super
    @loadAndRender()

  loadAndRender: =>
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
            Chaplin.datastore.businesses.push @business
            @render()
    else
      @render()

  attach: ->
    super()
    @$el.find('.map').hide()
    $('.dates-popover').popover(
      trigger: 'hover'
      placement: 'bottom'
      content: @model.get('scheduleText')
    )

  getTemplateData: ->
    td = super()
    td.i = @model.imageUrl({height:150, width:266}) || 'http://placehold.it/266x150' 
    td.businessId = @model.get('business')
    td.businessName = @business.get('name') if @business
    td.isRecurring = @model.get('scheduleText')?.length > 0
    start = moment(@collection.start || new Date()).startOf('day')
    td.nextOccurrence = @model.nextOccurrence(start).format("ddd, MMM Do")    
    td.time = "#{@model.nextOccurrence()?.format('h:mm a')} to #{@model.nextOccurrenceEnd()?.format('h:mm a')}"
    td

  showMap: ->
    @$el.find('.imageOrMap .image').hide()
    @$el.find('.imageOrMap .map').show()
    if not @mapped
      @mapped = true
      mapLatLng = new google.maps.LatLng(@model.get('location').geo.coordinates[1], @model.get('location').geo.coordinates[0])
      mapOptions =
        zoom: 15
        center: mapLatLng
        disableDefaultUI: true
        mapTypeId: google.maps.MapTypeId.ROADMAP
      map = new google.maps.Map(document.getElementById("map_#{@model.id}"), mapOptions)        
      google.maps.event.trigger(map, "resize")
      marker = new google.maps.Marker({position: mapLatLng, map: map})

  showImage: ->
    @$el.find('.imageOrMap .image').show()
    @$el.find('.imageOrMap .map').hide()

  gotoEvent: ->
    @publishEvent '!router:route', "/event/#{@model.id}"