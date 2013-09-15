View = require 'views/base/view'
template = require 'views/templates/footer'

module.exports = class Footer extends View
  container: 'body'
  id: 'footer'
  template: template
  autoRender: true