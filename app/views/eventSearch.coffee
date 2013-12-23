template = require 'views/templates/eventSearch'
View = require 'views/base/view'

module.exports = class EventSearch extends View
  autoRender: true
  template: template
  tags : []
  events: 
    'submit form.eventSearchForm' : 'searchEvents'
    'click .whenPrev' : 'whenPrev'
    'click .whenNext' : 'whenNext'
    'click .reset' : 'resetSearch'

  listen:
    'geo:newAddress mediator' : 'updateAddress'   

  initialize: (@options) ->
    super(@options)
    @whenOptions = [
      {text: 'Anytime', start: moment().startOf('day')}
      {text: 'Today', start: moment().startOf('day'), end : moment().endOf('day')}
      {text: 'Tomorrow', start: moment().startOf('day').add('days',1), end : moment().endOf('day').add('days',1)}
      {text: 'This Weekend', start: moment().day(5).startOf('day'), end : moment().day(7).endOf('day')}
      {text: 'Next Week', start: moment().startOf('week').add('weeks',1).add('days',1), end : moment().endOf('week').add('weeks', 1).add('days',1)}
      {text: 'Next Weekend', start: moment().day(5).startOf('day').add('weeks',1), end : moment().day(7).endOf('day').add('weeks',1)}
      {text: 'Beyond', start: moment().startOf('day').day(1).add('weeks',2)}
    ]

  attach: ->
    super()
    @getTags(@options?.searchOptions?.tags)
    if @options?.searchOptions?.whenOption
      wo = _.indexOf @whenOptions, _.find @whenOptions, (item) =>
        item.text is @options.searchOptions.whenOption
      @updateWhen(wo)
    

  searchEvents: (e) ->
    e.preventDefault()
    @$el.find('.has-error').removeClass('has-error')
    near = @$el.find('input[name=near]').val()
    if not near
      @$el.find('input[name=near]').parent().addClass('has-error')
    else
      o = {near: near}
      if @$el.find('input[name=keyword]').val()
        o.keyword = @$el.find('input[name=keyword]').val()
        o.tags = ''
      else
        o.keyword = ''
      if @$el.find('input[name=tag]').val() != ''
        o.tags = $('.chosen-select.tag_chosen').chosen().val()

      c = @$el.find('.whenSelected').text()      
      w = _.find @whenOptions, (item) ->
        c is item.text
      o.whenOption = w.text if w.text
      o.start = w.start.toDate().toISOString()
      if w.end
        o.end = w.end.toDate().toISOString()
      o.radius = @$el.find('select[name=radius] > option:selected').val()
      @publishEvent 'event:searchChanged', o
      @publishEvent 'geo:newAddress', near

  resetSearch: (e) ->
    e.preventDefault()
    Chaplin.cookieManager.clear()
    @updateWhen(0)
    @$el.find('input[name=keyword]').val('')
    @$el.find('input[name=near]').val('')
    @$el.find('input[name=tags]').val('')
    window.location.reload(false)

  updateAddress: (addr) ->
    @$el.find('input[name=near]').val(addr)              

  getTemplateData: ->
    td = super()
    td.search = Chaplin.cookieManager.cookie.search || {}
    td

  whenPrev: ->
    c = @$el.find('.whenSelected').text()
    currentIndex = _.indexOf @whenOptions, _.find @whenOptions, (item) ->
      c is item.text
    if currentIndex is 0
      desiredIndex = @whenOptions.length - 1
    else
      desiredIndex = currentIndex - 1
    @updateWhen(desiredIndex)

  whenNext: ->
    c = @$el.find('.whenSelected').text()
    currentIndex = _.indexOf @whenOptions, _.find @whenOptions, (item) ->
      c is item.text
    if currentIndex is (@whenOptions.length - 1)
      desiredIndex = 0
    else
      desiredIndex = currentIndex + 1
    @updateWhen(desiredIndex)
    

  updateWhen: (newIndex) ->
    @$el.find('.whenSelected').text(@whenOptions[newIndex].text)

  getTags:(tag)->
    url = '/api/eventTag'
    $.ajax
      url: url
      method: "GET"
      success: (response) ->
        @tags = response
        _.each response, (item, index, list)=>
          if item.slug is tag
            $('.tag_chosen').append("<option value='"+item.slug+"' selected=true>"+item.text+"</option>")
          else
            $('.tag_chosen').append("<option value='"+item.slug+"'>"+item.text+"</option>")
        $(".chosen-select.tag_chosen").chosen({"no_results_text": "Oops, nothing found!","allow_single_deselect": true, width:"100%"})
      error: (error) ->
        alert error