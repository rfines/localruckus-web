module.exports = (match) ->
  match '', 'dashboard#index'
  match 'music', 'dashboard#music'
  match 'art', 'dashboard#art'
  match 'food', 'dashboard#food'
  match 'family', 'dashboard#family'
  match 'event/:id', 'event#detail'
  match 'business/:id', 'business#detail'

