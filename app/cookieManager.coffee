module.exports = class CookieManager 
  

  constructor: (@name) ->
    $.cookie.json = true;
    @cookie = $.cookie('localruckus') || {}

  updateSearch: (search) ->
    @cookie.search = search
    @cookie.lastSearch = new Date()
    d = new Date()
    x = d.setTime(d.getTime()+(60*60*1000))
    y=new Date(x)
    $.cookie('localruckus', @cookie, { expires: y, path: '/'});

  clear: () ->
    delete @cookie.lastSearch
    delete @cookie.search
    d = new Date()
    time =(d.getTime()+(60*60*1000)) 
    x = d.setTime(time)
    y = new Date(x)
    $.cookie('localruckus', @cookie, { expires: y, path: '/'});