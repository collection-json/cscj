cscj = require("coffee-dsl").dsl()

collectionScope = (collection)->
  error: (options)->
    collection.error = options
  href: (value)->
    collection.href = value
  link: (options)->
    collection.links ||= []
    collection.links.push options
  item: (itemFun)->
    item = {}
    collection.items ||= []
    collection.items.push item
    itemFun.call itemScope(item)
  query: (queryFun)->
    query = {}
    collection.queries ||= []
    collection.queries.push query
    queryFun.call queryScope(query)
  template: (templateFun)->
    collection.template = {}
    templateFun.call templateScope(collection.template)

itemScope = (item)->
  href: (value)->
    item.href = value
  link: (options)->
    item.links ||= []
    item.links.push options
  datum: (options)->
    item.data ||= []
    item.data.push options

queryScope = (query)->
  href: (value)->
    query.href = value
  rel: (value)->
    query.rel = value
  datum: (options)->
    query.data ||= []
    query.data.push options

templateScope = (template)->
  href: (value)->
    template.href = value
  datum: (options)->
    template.data ||= []
    template.data.push options

cscj.set "collection", (collectionFun)->
  collection = {version:"1.0"}
  root = {collection:collection}
  collectionFun.call collectionScope(collection)
  root

module.exports = cscj
