module.exports = require("coffee-dsl").dsl()

module.exports.set "collection", (collectionFun)->
  collection = {version:"1.0"}
  root = {collection:collection}
  collectionFun.call new exports.Collection(collection)
  root

exports.Base = class Base
  constructor: (@_obj) ->
  href: (value)->
    @_obj.href = value

exports.Data = class Data extends exports.Base
  datum: (options)->
    @_obj.data ||= []
    @_obj.data.push options

# expose internal objects for extensions
exports.Collection = class Collection extends Base
  error: (options)->
    @_obj.error = options
  link: (options)->
    @_obj.links ||= []
    @_obj.links.push options
  item: (itemFun)->
    item = {}
    @_obj.items ||= []
    @_obj.items.push item
    itemFun.call new exports.Item(item)
  query: (queryFun)->
    query = {}
    @_obj.queries ||= []
    @_obj.queries.push query
    queryFun.call new exports.Query(query)
  template: (templateFun)->
    @_obj.template = {}
    templateFun.call new exports.Template(@_obj.template)

exports.Item = class Item extends exports.Data
  link: (options)->
    @_obj.links ||= []
    @_obj.links.push options

exports.Query = class Query extends exports.Data
  rel: (value)->
    @_obj.rel = value
  prompt: (value)->
    @_obj.prompt = value

exports.Template = class Template extends exports.Data
