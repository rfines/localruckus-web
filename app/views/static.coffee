View = require 'views/base/view'

module.exports = class Static extends View
  autoRender: true
  className: 'home-page'

  initialize: (@options)->
    super(@options)
    @template = @options.template