Model = require 'models/base/model'

module.exports = class Event extends Model
  
  initialize: () ->
    super()
    console.log 'initializing event'
    @getImage()

  getImage: ->
    console.log 'get Image'
    m = @get('media')
    if m and m[0] and m[0].url
      u = m[0].url
      t = u.split('/')
      a = t.indexOf('upload')
      t[a+1] = 'c_fill,h_163,w_266'
      return t.join('/')
    else
      return "http://placehold.it/266x163?text=Ruckus!"