module.exports = class CookieManager 
  cookie : $.cookie('localruckus')

  constructor: (@name) ->
    @cookie = $.cookie('localruckus') || {}

  updateSearch: (search) ->
    @cookie.search = searchOptions
    $.cookie('localruckus', @cookie)