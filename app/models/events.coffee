Collection = require 'models/base/collection'
Event = require('models/event')

module.exports = class Events extends Collection
  model : Event
  start : moment().toDate().toISOString()
  radius: 16093
  tags:"MUSIC,FAMILY-AND-CHILDREN,ARTS,ENTERTAINMENT"
  limit : 50
  skip : 0

  url: ->
    u = "/api/event?"
    p = {}
    p.ll = @ll if @ll
    p.near = @near if @near
    p.keyword = @keyword if @keyword
    p.tags = @tags if @tags?.length > 0 and not p.keyword
    p.skip = @skip
    p.limit = @limit
    p.start = @start
    p.end = @end if @end
    p.radius = @radius
    u = u + $.param(p)
    return u
    
  comparator : (event) ->
    event.nextOccurrence(moment(@start))?.toDate().toISOString()