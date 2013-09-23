module.exports = class CookieManager 
  

  constructor: (@name) ->
    $.cookie.json = true;
    @cookie = $.cookie('localruckus') || {}

  updateSearch: (search) ->
    @cookie.search = search
    console.log @cookie
    $.cookie('localruckus', @cookie, { expires: 60, path: '/'});