Controller = require 'controllers/base/controller'
DiscoveryView = require 'views/discovery'


module.exports = class HomeController extends Controller

  index: ->
    c = Chaplin.cookieManager.cookie
    @view = new DiscoveryView({region: 'main'})
    if not c?.search?.sensor
      @view.loadEvents()
    if window?.navigator?.geolocation?.getCurrentPosition
      window.navigator.geolocation.getCurrentPosition (pos) =>
        $.get "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{pos.coords.latitude},#{pos.coords.longitude}&sensor=false", (a, b, c) =>
          @publishEvent 'geo:newAddress', a.results[0].formatted_address
        @publishEvent 'event:searchChanged', {ll: "#{pos.coords.longitude},#{pos.coords.latitude}", sensor: true}

  music: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'MUSIC'
    @view = new DiscoveryView(@locationOptions(options))
    @view.loadEvents()

  family: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'FAMILY-AND-CHILDREN'
    @view = new DiscoveryView(@locationOptions(options))   
    @view.loadEvents()

  food: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'FOOD-AND-DRINK'
    @view = new DiscoveryView(@locationOptions(options))   
    @view.loadEvents()  

  art: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'ARTS'
    console.log @locationOptions(options)
    @view = new DiscoveryView(@locationOptions(options))         
    @view.loadEvents()

  locationOptions: (options) ->
    c = Chaplin.cookieManager.cookie
    if c?.ll or c?.near
      if c.ll
        options.searchOptions.ll = c.ll 
      else
        options.searchOptions.near = c.near
    else
      options.searchOptions.near = '64105'
    return options    