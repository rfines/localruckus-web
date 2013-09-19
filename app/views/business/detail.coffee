template = require 'views/templates/business/detail'
View = require 'views/base/detail'
ShareThis = require 'views/shareThis'

module.exports = class BusinessDetail extends View
  autoRender: false
  className: 'business-detail'
  template: template

  getTemplateData: =>
    td = super
    td.i = @model.imageUrl() || 'http://placehold.it/266x150' 
    td.tags = @model.get('tags').join(', ')
    td