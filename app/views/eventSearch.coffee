template = require 'views/templates/eventSearch'
View = require 'views/base/view'

module.exports = class EventSearch extends View
  autoRender: true
  template: template
  tags : []
  events: 
    'submit form.eventSearchForm' : 'searchEvents'
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
    if @options?.searchOptions?.when
      $('.date-range option')[@options.searchOptions.when].selected = true
  

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

      c = @$el.find('.date-range').val()      
      w = @whenOptions[c]
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
    @$el.find('input[name=keyword]').val('')
    @$el.find('input[name=near]').val('')
    @$el.find('input[name=tags]').val('')
    @$el.find('.date-range').val('0')
    l = window.location.href
    if l.indexOf('/#') != -1
      parts = l.indexOf('/#')
      l = l.substr(0,parts)
    window.location.href = l
  updateAddress: (addr) ->
    @$el.find('input[name=near]').val(addr)              

  getTemplateData: ->
    td = super()
    td.search = Chaplin.cookieManager.cookie.search || {}
    if @options?.searchOptions?.whenOption
      wo = _.indexOf @whenOptions, _.find @whenOptions, (item) =>
        item.text is @options.searchOptions.whenOption
      console.log wo
      console.log @options
      td.search.when=wo
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
    $(".chosen-select.tag_chosen").chosen({"no_results_text": "Oops, nothing found!","allow_single_deselect": true, width:"100%"})
    if tag
      tagOpt = {}
      $('.chosen-select.tag_chosen').val(tag)
      $('.chosen-select.tag_chosen').trigger("chosen:updated")
        
  sortByKey = (array, key) ->
    array.sort (a, b) ->
      x = a[key]
      y = b[key]
      if typeof x is "string"
        x = x.toLowerCase()
        y = y.toLowerCase()
      (if (x < y) then -1 else ((if (x > y) then 1 else 0)))
