Controller = require 'controllers/base/controller'
HomePageView = require 'views/home-page-view'


module.exports = class HomeController extends Controller

  index: ->
    options = {
      region: 'main'
      searchOptions : {}
    }
    @view = new HomePageView(@locationOptions(options))
    if window?.navigator?.geolocation?.getCurrentPosition
      window.navigator.geolocation.getCurrentPosition (pos) =>
        $.get "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{pos.coords.latitude},#{pos.coords.longitude}&sensor=false", (a, b, c) =>
          @publishEvent 'geo:newAddress', a.results[0].formatted_address
        cookie = $.cookie('localruckus') || {}
        cookie.ll = "#{pos.coords.longitude},#{pos.coords.latitude}"
        cookie.grantedGeo = true
        $.cookie('localruckus', cookie, { expires: 60 });
        @publishEvent 'event:searchChanged', {ll: "#{pos.coords.longitude},#{pos.coords.latitude}"}

  music: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'MUSIC'
    @view = new HomePageView(@locationOptions(options))

  family: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'FAMILY-AND-CHILDREN'
    @view = new HomePageView(@locationOptions(options))   

  food: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'FOOD-AND-DRINK'
    @view = new HomePageView(@locationOptions(options))     

  art: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'ARTS'
    @view = new HomePageView(@locationOptions(options))         
   

  locationOptions: (options) ->
    if $.cookie('localruckus')?.ll or $.cookie('localruckus')?.near
      if $.cookie('localruckus').ll
        options.searchOptions.ll = $.cookie('localruckus').ll 
      else
        options.searchOptions.near = $.cookie('localruckus').near
    return options