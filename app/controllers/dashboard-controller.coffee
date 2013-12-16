Controller = require 'controllers/base/controller'
DiscoveryView = require 'views/discovery'


module.exports = class HomeController extends Controller

  index: ->
    @publishEvent "changeActiveIcon", ".all"
    c = Chaplin.cookieManager.cookie
    if c and c.lastSearch and moment(c.lastSearch).isAfter(moment().subtract('hours', 1))
      @view = new DiscoveryView({region: 'main', searchOptions : c.search})
      @view.loadEvents()
    else
      @view = new DiscoveryView({region: 'main'})
      if not c?.search?.sensor
        @view.loadEvents()
      if window?.navigator?.geolocation?.getCurrentPosition
        window.navigator.geolocation.getCurrentPosition (pos) =>
          $.get "http://maps.googleapis.com/maps/api/geocode/json?latlng=#{pos.coords.latitude},#{pos.coords.longitude}&sensor=false", (a, b, c) =>
            @publishEvent 'geo:newAddress', a.results[0].formatted_address
            @publishEvent 'event:searchChanged', {ll: "#{pos.coords.longitude},#{pos.coords.latitude}", near : a.results[0].formatted_address, sensor: true}

  music: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'MUSIC'
    @publishEvent "changeActiveIcon", ".music"
    @view = new DiscoveryView(@locationOptions(options))
    @view.loadEvents()

  family: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'FAMILY-AND-CHILDREN'
    @publishEvent "changeActiveIcon", ".family"
    @view = new DiscoveryView(@locationOptions(options))   
    @view.loadEvents()

  food: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'FOOD-AND-DRINK'
    @publishEvent "changeActiveIcon", ".food"
    @view = new DiscoveryView(@locationOptions(options))   
    @view.loadEvents()  

  art: ->
    options = {
      region: 'main'
      searchOptions : {}
    }  
    options.searchOptions.tags = 'ARTS'
    @publishEvent "changeActiveIcon", ".art"
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