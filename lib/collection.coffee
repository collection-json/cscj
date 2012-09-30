Item = require "./item"
Query = require "./query"
Template = require "./template"

class Collection
  constructor: (@_collection)->
  error: (options)->
    @_collection.error = options
  href: (value)->
    @_collection.href = value
  link: (options)->
    @_collection.links ||= []
    @_collection.links.push options
  item: (itemFun)->
    item = {}
    @_collection.items ||= []
    @_collection.items.push item
    itemFun.call new Item(item)
  query: (queryFun)->
    query = {}
    @_collection.queries ||= []
    @_collection.queries.push query
    queryFun.call new Query(query)
  template: (templateFun)->
    @_collection.template = {}
    templateFun.call new Template(@_collection.template)

module.exports = Collection
