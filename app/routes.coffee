module.exports = (match) ->
  match '', 'dashboard#index'
  match 'event/:id', 'event#detail'
