require 'lib/view-helper' # Just load the view helpers, no return value

module.exports = class View extends Chaplin.View
  # Precompiled templates function initializer.
  attach:()->
    super()
    $('input, textarea').placeholder();

  getTemplateFunction: ->
    @template

  stopLoading: ->
    $('#pageLoader').hide()

  startLoading: ->
    $('#pageLoader').show()