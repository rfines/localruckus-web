template = require 'views/templates/home'
View = require 'views/base/view'
Event = require 'models/event'

module.exports = class HomePageView extends View
  autoRender: true
  className: 'home-page'
  template: template

  attach: () ->
    super()
    eventGallery = @$el.find('.eventGallery')
    console.log @collection.models[0]
    for x in @collection.models
      console.log x.getImage()
      eventGallery.append "<div class='col-lg-3'><a class='thumbnail'><img src='#{x.getImage()}'></a>"