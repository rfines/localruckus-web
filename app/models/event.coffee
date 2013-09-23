Model = require 'models/base/model'
ImageUtils = require 'utils/imageUtils'

module.exports = class Event extends Model
  
  urlRoot : "/api/event"

  validation :
    name:
      required: true        
    description:
      required: true
    location:
      required: true
    contactPhone:
      required: false
      pattern: "phone"

  nextOccurrence: ->
    if @get('occurrences') and _.first(@get('occurrences'))
      m = moment(_.first(@get('occurrences')).start)
      m.local()
      return m
    return undefined

  nextOccurrenceEnd: ->
    if @get('occurrences') and _.first(@get('occurrences'))
      m = moment(_.first(@get('occurrences')).end)
      m.local()
      return m
    return undefined

  lastOccurrence: ->
    if @get('occurrences') and _.last(@get('occurrences'))
      m = moment(_.last(@get('occurrences')).start)
      m.local()
      return m
    else if @get('fixedOccurrences') and _.last(@get('fixedOccurrences'))
      m = moment(_.last(@get('fixedOccurrences')).end)
      m.local()
      return m   
    else if @get('schedules') and @get('schedules').length > 0
      m = moment(_.first(@get('schedules')).end)
      m.local()
      return m
    return undefined 

  dateDisplayText: ->
    now = moment()
    ne = @nextOccurrence()
    if ne
      next = ne
      days = ne.startOf('day').diff(now.startOf('day'), 'days', true)
      if days > 1
        return next.format('MM/DD/YYYY')        
      else
        if days is 0
          return 'Today'
        else
          return 'Tomorrow'
    else
      if @lastOccurrence()
        return @lastOccurrence().format('MM/DD/YYYY')
      else
        return ''

  getStartDate: ->
    return moment(_.first(@get('occurrences')).start)

  getEndDate: ->
    return moment(_.first(@get('occurrences')).end)    

  getSortDate: ->
    return @nextOccurrence() || @lastOccurrence()

  imageUrl: (options) ->
    media = @get('media')
    if media?.length > 0
      opts = {}
      opts = {crop: 'fill', height: options.height, width: options.width} if options
      return $.cloudinary.url(ImageUtils.getId(media[0].url), opts)  
    else
      return undefined    

  scheduleText: ->
    dayOrder =  ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
    dayCountOrder = ['Last', 'First', 'Second', 'Third', 'Fourth']
    if @get('schedules')?[0]
      s = @get('schedules')[0]
      endDate = moment(s.end)
      if s.dayOfWeek?.length is 0 and s.dayOfWeekCount?.length is 0
        return 'Every Day'
      else
        out = ""
        days = _.map s.dayOfWeek, (i) ->
          return dayOrder[i]
        if s.dayOfWeekCount?.length > 0
          out = "The #{dayCountOrder[s.dayOfWeekCount]} #{days.join(', ')} of the month"
        else
          out = "Every #{days.join(', ')}"
        out = "#{out} until #{endDate.format('MM/DD/YYYY')}"
        return out
    else
      return ''

  clone: ->
    json = @toJSON()
    delete json.id
    delete json._id
    delete json._v
    delete json.occurrences
    delete json.fixedOccurrences
    delete json.schedules
    return new Event(json)