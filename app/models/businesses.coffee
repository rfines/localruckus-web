Collection = require 'models/base/collection'
Business = require('models/business')

module.exports = class Businesses extends Collection
  model : Business
  url: ->
    "/api/business"