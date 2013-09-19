template = require 'views/templates/shareThis'
View = require 'views/base/view'

module.exports = class ShareThis extends View
  autoRender: true
  template: template

  initialize: ->
    super