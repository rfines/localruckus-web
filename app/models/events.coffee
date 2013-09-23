Collection = require 'models/base/collection'
Event = require('models/event')

module.exports = class Events extends Collection
  model : Event

  url: ->
    u = "/api/event?"
    p = {}
    p.ll = @ll if @ll
    p.near = @near if @near
    p.tags = @tags if @tags?.length > 0
    p.limit = 100
    p.keyword = @keyword if @keyword
    console.log @start
    console.log @end
    p.start = @start || moment().toDate().toISOString()
    p.end = @start if @start
    u = u + $.param(p)
    return u
    
  comparator : (event) ->
    console.log 'calling comparator'
    event.getSortDate()?.toDate().toISOString()
  
  upcomingEvents: (limit) ->
    c = @filter (item) ->
      item.nextOccurrence() and item.nextOccurrence().isAfter(moment())
    c = _.first(c, 10) if limit
    return new Events(c)

  pastEvents: (limit) ->
    c = @filter (item) ->
      not item.nextOccurrence() or item.nextOccurrence().isBefore(moment())
    c = _.first(c, 10) if limit
    return new Events(c)    
  
  promotionRequests: ()->
    @get 'promotionRequests'

  hasMedia: (mediaId) ->
    @some (item) ->
      if item.has('media')
        return _.some item.get('media'), (i) ->
          i._id is mediaId    
      else
        return false
