template = require 'views/templates/eventItem'
View = require 'views/base/view'

module.exports = class EventItem extends View
  autoRender: true
  className: 'col-lg-2 col-md-3 col-sm-4 col-xs-6 eventItem'
  template: template

  getTemplateData: ->
    td = super()
    td.i = @model.imageUrl({height:150, width:266}) || 'http://placehold.it/266x150' 
    td