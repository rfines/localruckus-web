Controller = require 'controllers/base/controller'
HomePageView = require 'views/home-page-view'


module.exports = class HomeController extends Controller
  index: ->
    options = {
      region: 'main'
      searchOptions : {}
    }
    if $.cookie('localruckus')?.ll or $.cookie('localruckus')?.near
      if $.cookie('localruckus').ll
        options.searchOptions.ll = $.cookie('localruckus').ll 
      else
        options.searchOptions.near = $.cookie('localruckus').near
    @view = new HomePageView(options)
    if window?.navigator?.geolocation?.getCurrentPosition
      window.navigator.geolocation.getCurrentPosition (pos) =>
        $.get "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{pos.coords.latitude},#{pos.coords.longitude}&sensor=false", (a, b, c) =>
          @publishEvent 'geo:addressFound', a.results[0].formatted_address
        cookie = $.cookie('localruckus') || {}
        cookie.ll = "#{pos.coords.longitude},#{pos.coords.latitude}"
        cookie.grantedGeo = true
        $.cookie('localruckus', cookie, { expires: 60 });
        @publishEvent 'event:searchChanged', {ll: "#{pos.coords.longitude},#{pos.coords.latitude}"}

  music: ->
    @view = new HomePageView
      region: 'main'
      searchOptions: {tags: 'ROCK', near: '64105'}