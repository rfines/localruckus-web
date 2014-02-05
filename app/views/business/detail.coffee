template = require 'views/templates/business/detail'
View = require 'views/base/detail'
ShareThis = require 'views/shareThis'
Collection = require 'models/base/collection'
Event = require 'models/event'
EventItem = require 'views/eventItem'

module.exports = class BusinessDetail extends View
  autoRender: false
  className: 'business-detail'
  template: template
  owner: {}
  initialize: ->
    super
    @events = new Collection()
    @events.model = Event

  getTemplateData: =>
    td = super
    td.tags = @model.get('tags').join(', ')
    td

  loadAndRender: =>
    @model.fetch
      success: =>
        @events.url = "/api/business/#{@model.get('_id')}/events"
        @events.fetch
          success: =>
            @events
            @render()
            @getOwners (err, owner)=>
              console.log owner
              if err
                console.log err
                @$el.find(".claimBusiness").show()
              else if owner and owner.length > 0
                @$el.find(".claimBusiness").hide()

  attach: =>
    super
    for x in @events.models
      if x.nextOccurrence(moment()).isAfter(moment())
        @subview "event-#{x.id}", new EventItem(
          model : x
          collection : @events
          container: @$el.find('.eventGallery')
          className: 'col-lg-6 col-md-4 col-sm-12 col-xs-12 eventItem'
        )
  getOwners:(cb)=>
    url = "/api/business/#{@model.id}/user"
    $.ajax
      type: 'GET'
      url: url
      success: (data, textStatus, jqXHR)=>
        @owner = data
        cb null, data
      error:(jqXHR, textStatus, errorThrown)=>
        cb errorThrown,null