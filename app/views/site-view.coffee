View = require 'views/base/view'
template = require 'views/templates/site'

# Site view is a top-level view which is bound to body.
module.exports = class SiteView extends View
  container: 'body'
  id: 'site-container'
  regions:
    header: '#header'
    main: '#main'
    footer: '#footer'
  template: template

  events: 
    'submit form.contactForm' : 'contact'

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