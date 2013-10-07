Model = require 'models/base/model'
ImageUtils = require 'utils/imageUtils'


module.exports = class Event extends Model
  
  urlRoot : "/api/event"

  nextOccurrence: (afterMoment) ->
    return moment.utc(@get('nextOccurrence').start)

  nextOccurrenceEnd: ->
    return moment.utc(@get('nextOccurrence').end)

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