module.exports = class CookieManager 
  

  constructor: (@name) ->
    $.cookie.json = true;
    @cookie = $.cookie('localruckus') || {}

  updateSearch: (search) ->
    @cookie.search = search
    $.cookie('localruckus', @cookie, { expires: 60, path: '/'});