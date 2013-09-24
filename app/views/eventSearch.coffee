template = require 'views/templates/eventSearch'
View = require 'views/base/view'

module.exports = class EventSearch extends View
  autoRender: true
  template: template

  events: 
    'submit form.eventSearchForm' : 'searchEvents'
    'click .whenPrev' : 'whenPrev'
    'click .whenNext' : 'whenNext'

  listen:
    'geo:newAddress mediator' : 'updateAddress'   

  initialize: ->
    super()
    @whenOptions = [
      {text: 'Anytime', start: moment().startOf('day')}
      {text: 'Today', start: moment().startOf('day'), end : moment().startOf('day').add('days',1)}
      {text: 'Tomorrow', start: moment().startOf('day').add('days',1), end : moment().endOf('day').add('days',1)}
      {text: 'This Weekend', start: moment().day(5).startOf('day'), end : moment().day(7).endOf('day')}
      {text: 'Next Week', start: moment().startOf('week').add('weeks',1).add('days',1), end : moment().endOf('week').add('weeks', 1).add('days',1)}
      {text: 'Next Weekend', start: moment().day(5).startOf('day').add('weeks',1), end : moment().day(7).endOf('day').add('weeks',1)}
      {text: 'Beyond', start: moment().startOf('day').day(1).add('weeks',2)}
    ]

  searchEvents: (e) ->
    e.preventDefault()
    near = @$el.find('input[name=near]').val()
    o = {near: near}
    if @$el.find('input[name=keyword]').val()
      o.keyword = @$el.find('input[name=keyword]').val()
      o.tags = ''
    else
      o.keyword = ''
    c = @$el.find('.whenSelected').text()      
    w = _.find @whenOptions, (item) ->
      c is item.text
    o.start = w.start.toDate().toISOString()
    o.end = w.end.toDate().toISOString() if w.end
    o.radius = @$el.find('select[name=radius] > option:selected').val()
    console.log o
    @publishEvent 'event:searchChanged', o
    @publishEvent 'geo:newAddress', near

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