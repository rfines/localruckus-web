Collection = require 'models/base/collection'
Event = require('models/event')

module.exports = class Events extends Collection
  model : Event
  start : moment().toDate().toISOString()
  radius: 16093
  tags:"MUSIC,FAMILY-AND-CHILDREN,ARTS"

  url: ->
    u = "/api/event?"
    p = {}
    p.ll = @ll if @ll
    p.near = @near if @near
    p.tags = @tags if @tags?.length > 0
    p.limit = 100
    p.keyword = @keyword if @keyword
    p.start = @start
    p.end = @end if @end
    p.radius = @radius
    u = u + $.param(p)
    return u
    
  comparator : (event) ->
    event.nextOccurrence(moment(@start))?.toDate().toISOString()