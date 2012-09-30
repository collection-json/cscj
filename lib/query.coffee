class Query
  constructor: (@_query) ->
  href: (value)->
    @_query.href = value
  rel: (value)->
    @_query.rel = value
  datum: (options)->
    @_query.data ||= []
    @_query.data.push options

module.exports = Query
