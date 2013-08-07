Collection = require 'models/base/collection'
Event = require('models/event')

module.exports = class Events extends Collection
  model : Event
  url: "#{window.apiUrl}event?near=64105&radius=10000"
  
