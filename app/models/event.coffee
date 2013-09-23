Model = require 'models/base/model'
ImageUtils = require 'utils/imageUtils'
CONFIG = require('config')

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
        moment(o.start).isAfter(afterMoment)
      if m
        return moment(m.start)
    else
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

  getStartDate: ->
    return moment(_.first(@get('occurrences')).start)

  getEndDate: ->
    return moment(_.first(@get('occurrences')).end)    

  imageUrl: (options) ->
    media = @get('media')
    if media?.length > 0
      opts = {}
      opts = {crop: 'fill', height: options.height, width: options.width} if options
      return $.cloudinary.url(ImageUtils.getId(media[0].url), opts)  
    else
      return undefined
  getICal:()->
    url = "#{CONFIG.baseUrl}/api/event/#{@id}/getCalendar?start=#{encodeUDIComponent(@nextOccurrence)}&end=#{encodeURIComponent(@nextOccurrenceEnd)}"
    $.ajax
      type:'GET'
      url:url
      success: (response)=>
        console.log response
        if response.success
          return response.file
      error:(error)=>
        console.log error
        return error

  clone: ->
    json = @toJSON()
    delete json.id
    delete json._id
    delete json._v
    delete json.occurrences
    delete json.fixedOccurrences
    delete json.schedules
    return new Event(json)

