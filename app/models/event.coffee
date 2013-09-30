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

  nextOccurrence: (afterMoment) ->
    if afterMoment
      m = _.find @get('occurrences'), (o) ->
        moment.utc(o.start).isAfter(afterMoment)
      if m
        return moment(m.start)
    else
      if @get('occurrences') and _.first(@get('occurrences'))
        m = moment.utc(_.first(@get('occurrences')).start)
        m.local()
        return m
      return undefined

  nextOccurrenceEnd: ->
    if @get('occurrences') and _.first(@get('occurrences'))
      m = moment.utc(_.first(@get('occurrences')).end)
      m.local()
      return m
    return undefined

  getStartDate: ->
    return moment.utc(_.first(@get('occurrences')).start)

  getEndDate: ->
    return moment.utc(_.first(@get('occurrences')).end)    

  imageUrl: (options) ->
    media = @get('media')
    if media?.length > 0
      opts = {}
      opts = {crop: 'fill', height: options.height, width: options.width} if options
      return $.cloudinary.url(ImageUtils.getId(media[0].url), opts)  
    else
      return undefined

  getICal:()->
    start = @nextOccurrence().format("X")
    end = @nextOccurrenceEnd().format("X")
    url = "/api/event/#{@id}/invite.ics?start=#{start}&end=#{end}"
    window.location.href = url

  clone: ->
    json = @toJSON()
    delete json.id
    delete json._id
    delete json._v
    delete json.occurrences
    delete json.fixedOccurrences
    delete json.schedules
    return new Event(json)

