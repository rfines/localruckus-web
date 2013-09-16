Model = require 'models/base/model'
ImageUtils = require 'utils/imageUtils'

module.exports = class Business extends Model

  urlRoot : "/api/business"
  
  imageUrl: (options) ->
    media = @get('media')
    if media?.length > 0
      return $.cloudinary.url(ImageUtils.getId(media[0].url), {crop: 'fill', height: options.height, width: options.width})  
    else
      return undefined