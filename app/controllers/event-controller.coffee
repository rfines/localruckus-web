Controller = require 'controllers/base/controller'
EventDetail = require 'views/event/detail'
Event = require 'models/event'

module.exports = class EventController extends Controller
  detail: (params) ->
    event = new Event()
    event.id = params.id
    @view = new EventDetail
      region : 'main'
      model : event
