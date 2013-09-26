Controller = require 'controllers/base/controller'
NotFoundView = require 'views/notFound'


module.exports = class HomeController extends Controller

  notFound: ->
    @view = new NotFoundView({region: 'main'})