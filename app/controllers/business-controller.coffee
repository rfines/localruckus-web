Controller = require 'controllers/base/controller'
BusinessDetail = require 'views/business/detail'
Business = require 'models/business'

module.exports = class BusinessController extends Controller
  detail: (params) ->
    business = new Business()
    business.id = params.id
    @view = new BusinessDetail
      region : 'main'
      model : business
