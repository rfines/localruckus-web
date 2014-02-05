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
  events: 
    'submit form.transferForm' : 'contact'
  loadAndRender: =>
    @model.fetch
      success: =>
        @events.url = "/api/business/#{@model.get('_id')}/events"
        @events.fetch
          success: =>
            @events
            @render()
            @getOwners (err, owner)=>
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
          className: 'col-lg-4 col-md-6 col-sm-6 col-xs-12 eventItem'
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
  contact: (e) ->
    e.preventDefault()
    @$el.find('.transferForm .has-error').removeClass('has-error')
    name = @$el.find('.transferForm input[name=name]')
    business = @$el.find('.transferForm input[name=businessName]')
    email = @$el.find('.transferForm input[name=email]')
    text = @$el.find('.transferForm textarea[name=text]')
    subject = 'Local Ruckus Business Transfer Request'
    address = @$el.find('.transferForm input[name=address]')
    if name.val() and email.val() and text.val() and address.val()
      $.ajax
        type: "POST"
        url: '/lrApi/transferRequest'
        data: {name : name.val(), businessName:business.val(), email: email.val(), text : text.val(), subject: subject, address: address.val()}
        dataType: 'json'   
        success: (data, status, xhr) ->
          $('#claim-modal').modal('hide')
    else
      name.parent().addClass('has-error') if not name.val()
      email.parent().addClass('has-error') if not email.val()
      text.parent().addClass('has-error') if not text.val()
      business.parent().addClass('has-error') if not business.val()
      address.parent()/addClass('has-error') if not address.val()
