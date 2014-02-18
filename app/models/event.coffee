Model = require 'models/base/model'
ImageUtils = require 'utils/imageUtils'


module.exports = class Event extends Model
  
  url: ->
    console.log 'in the url function'
    console.log 'id is ' + @id
    if @isNew()
      return "/api/event"
    else
      console.log 'else case'
      console.log 'id is ' + @id
      return "/api/event/#{@id}"  

  nextOccurrence: (afterMoment) ->
    if afterMoment
      occ = _.find @get('occurrences'), (item)->
        #console.log item
        return moment.utc(item.start).isAfter(afterMoment)
      if occ?.start
        return moment.utc(occ.start)
      else if @get('occurrences').length > 0
        return moment.utc(@get('occurrences')[0].start)
      else
        return moment.utc(@get('nextOccurrence').start)
    else
      return moment.utc(@get('nextOccurrence').start)

  nextOccurrenceEnd: (afterMoment) ->
    if afterMoment
      occ = _.find @get('occurrences'), (item)->
        #console.log item
        return moment.utc(item.end).isAfter(afterMoment)
      if occ?.end
        return moment.utc(occ.end)
      else if @get('occurrences').length > 0
        return moment.utc(@get('occurrences')[0].end)
      else
        return moment.utc(@get('nextOccurrence').end)
    else
      return moment.utc(@get('nextOccurrence').end)
  

  imageUrl: (options) ->
    media = @get('media')
    if media?.length > 0
      opts = {}
      opts = {crop: 'fill', height: options.height, width: options.width} if options
      imgUrl = $.cloudinary.url(ImageUtils.getId(media[0].url), opts)  
      imgUrl = imgUrl.replace("w_#{options.width}", "w_#{options.width},f_auto,q_85") if options
      return imgUrl
    else
      return undefined

  getICal:()->
    start = @nextOccurrence().format("X")
    end = @nextOccurrenceEnd().format("X")
    url = "/api/event/#{@id}/invite.ics?start=#{start}&end=#{end}"
    window.location.href = url