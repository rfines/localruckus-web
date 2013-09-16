module.exports = (match) ->
  match '', 'dashboard#index'
  match 'music', 'dashboard#music'
  match 'event/:id', 'event#detail'

