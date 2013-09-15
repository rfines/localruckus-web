template = require 'views/templates/home'
View = require 'views/base/view'

module.exports = class HomePageView extends View
  autoRender: true
  className: 'home-page'
  template: template

  attach: () ->
    super()
    eventGallery = @$el.find('.eventGallery')
    for x in @collection.models
      console.log x
      eventGallery.append "<div class='col-lg-3'><a class='thumbnail'>#{x.get('name')}</a>"