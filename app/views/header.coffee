View = require 'views/base/view'
template = require 'views/templates/header'

module.exports = class HeaderView extends View
  autoRender: true
  className: 'header'
  region: 'header'
  template: template

  events: 
    'submit form.contactForm' : 'contact'

  initialize: ->
    super

  contact: (e) ->
    e.preventDefault()
    @$el.find('.contactForm .has-error').removeClass('has-error')

    name = @$el.find('.contactForm input[name=name]')
    email = @$el.find('.contactForm input[name=email]')
    text = @$el.find('.contactForm textarea[name=text]')

    if name.val() and email.val() and text.val()
      $.ajax
        type: "POST"
        url: '/lrApi/contact'
        data: {name : name.val(), email: email.val(), text : text.val()}
        dataType: 'json'   
        success: (data, status, xhr) ->
          $('#contactUs').modal('hide')
    else
      name.parent().addClass('has-error') if not name.val()
      email.parent().addClass('has-error') if not email.val()
      text.parent().addClass('has-error') if not text.val()
