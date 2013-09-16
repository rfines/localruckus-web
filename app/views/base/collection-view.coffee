View = require 'views/base/view'

module.exports = class CollectionView extends Chaplin.CollectionView
  getTemplateFunction: View::getTemplateFunction

  stopLoading: ->
    $('#pageLoader').hide()

  startLoading: ->
    $('#pageLoader').show()