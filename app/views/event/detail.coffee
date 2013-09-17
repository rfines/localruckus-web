template = require 'views/templates/event/detail'
View = require 'views/base/view'
ShareThis = require 'views/shareThis'
Business = require 'models/business'

module.exports = class EventDetail extends View
  autoRender: false
  className: 'event-detail'
  template: template

  initialize: ->
    super
    @loadAndRender()

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

  attach: =>
    super()
    @subview('shareThis', new ShareThis({container: '.shareIcons'}))      
    mapLatLng = new google.maps.LatLng(@model.get('location').geo.coordinates[1], @model.get('location').geo.coordinates[0])
    mapOptions =
      zoom: 15
      center: mapLatLng
      disableDefaultUI: true
      mapTypeId: google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map(document.getElementById("map_#{@model.id}"), mapOptions)        
    google.maps.event.trigger(map, "resize")
    marker = new google.maps.Marker({position: mapLatLng, map: map})    

  getTemplateData: =>
    td = super
    td.i = @model.imageUrl({height:400, width:266}) || 'http://placehold.it/266x150' 
    td.tags = @model.get('tags').join(', ')
    td.business = @business.toJSON()
    if not td.cost or td.cost is 0
      td.cost = 'FREE'
    startTime = @model.nextOccurrence().format('h:mm a')
    endTime = @model.nextOccurrenceEnd().format('h:mm a')
    td.date = "#{@model.nextOccurrence().format('MM/DD/YYYY')} from #{startTime} to #{endTime}"
    td