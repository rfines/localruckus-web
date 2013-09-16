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
        console.log pos
        cookie = $.cookie('localruckus') || {}
        cookie.ll = "#{pos.coords.longitude},#{pos.coords.latitude}"
        cookie.grantedGeo = true
        $.cookie('localruckus', cookie, { expires: 60 });
        @publishEvent 'event:searchChanged', {ll: "#{pos.coords.longitude},#{pos.coords.latitude}"}

  music: ->
    @view = new HomePageView
      region: 'main'
      searchOptions: {tags: 'ROCK', near: '64105'}