module.exports = (match) ->
  match '', 'dashboard#index'
  match 'music', 'dashboard#music'
  match 'art', 'dashboard#art'
  match 'food', 'dashboard#food'
  match 'family', 'dashboard#family'
  match 'event/:id', 'event#detail'
  match ':category/details/:id/:name', 'event#detail'
  match 'business/:id', 'business#detail'
  match 'businesses/details/:id/:name', 'business#detail'
  match 'terms', 'static#terms'
  match 'privacy', 'static#privacy'
  match '*anything', 'error#notFound'
