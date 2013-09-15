Controller = require 'controllers/base/controller'
HomePageView = require 'views/home-page-view'
Events = require 'models/events'

module.exports = class HomeController extends Controller
  index: ->
    collection = new Events()
    collection.fetch
      success: =>
        @view = new HomePageView
          region: 'main'
          collection: collection
