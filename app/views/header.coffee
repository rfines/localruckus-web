View = require 'views/base/view'
template = require 'views/templates/header'

module.exports = class HeaderView extends View
  autoRender: true
  className: 'header'
  region: 'header'
  template: template

  events: 
    'submit form.contactForm' : 'contact'
    'click .suggestBusiness' : 'suggestBusiness'
    'click .suggestEvent' : 'suggestEvent'
    'click .contactUs' : 'contactUs'

  listen:
    'suggestEvent mediator' : 'suggestEvent'
    'suggestEvent mediator' : 'suggestBusiness'

  initialize: ->
    super

  contact: (e) ->
    e.preventDefault()
    @$el.find('.contactForm .has-error').removeClass('has-error')

    name = @$el.find('.contactForm input[name=name]')
    email = @$el.find('.contactForm input[name=email]')
    text = @$el.find('.contactForm textarea[name=text]')
    subject = @$el.find('.contactForm input[name=subject]') || 'Contact Form Submission from LocalRuckus.com'
    if name.val() and email.val() and text.val()
      $.ajax
        type: "POST"
        url: '/lrApi/contact'
        data: {name : name.val(), email: email.val(), text : text.val(), subject: subject.val()}
        dataType: 'json'   
        success: (data, status, xhr) ->
          $('#contactUs').modal('hide')
    else
      name.parent().addClass('has-error') if not name.val()
      email.parent().addClass('has-error') if not email.val()
      text.parent().addClass('has-error') if not text.val()

  suggestBusiness: ->
    @$el.find('#contactUs .line1').text('Suggest a Business or Event for LocalRuckus')
    @$el.find('input[name=subject]').attr('value', 'Suggest Business or Event Submission from LocalRuckus.com')

  suggestEvent: ->
    @$el.find('#contactUs .line1').text('Suggest an Event for LocalRuckus')
    @$el.find('input[name=subject]').attr('value', 'Suggest Event Submission from LocalRuckus.com')

  contactUs: ->
    @$el.find('#contactUs .line1').text('Questions or Comments?')
    @$el.find('input[name=subject]').attr('value', 'Contact Form Submission from LocalRuckus.com')
    