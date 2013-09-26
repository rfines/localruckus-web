template = require 'views/templates/error'
View = require 'views/base/view'

module.exports = class NotFoundView extends View
  autoRender: true
  className: 'error-page'
  template: template