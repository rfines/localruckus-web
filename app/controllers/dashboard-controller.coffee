Controller = require 'controllers/base/controller'
HomePageView = require 'views/home-page-view'


module.exports = class HomeController extends Controller
  index: ->
    console.log 'show index'
    @view = new HomePageView
      region: 'main'
    if window?.navigator?.geolocation?.getCurrentPosition
      window.navigator.geolocation.getCurrentPosition (pos) =>
        @publishEvent 'event:searchChanged', {ll: "#{pos.coords.longitude},#{pos.coords.latitude}"}
