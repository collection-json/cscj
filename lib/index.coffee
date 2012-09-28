cscj = require("coffee-dsl").dsl()

CollectionJSON = require "collection-json"

collectionScope = (collection)->
  error: (options)->
    collection.getError options
  href: (value)->
    collection.href = value
  link: (options)->
    collection.addLink options
  item: (itemFun)->
    item = collection.addItem href: collection.href
    itemFun.call itemScope(item)
  query: (queryFun)->
    query = collection.addQuery href: collection.href, rel: "new-query"
    queryFun.call queryScope(query)
  template: (templateFun)->
    template = collection.getTemplate href: collection.href
    templateFun.call templateScope(template)

itemScope = (item)->
  href: (value)->
    item.href = value
  link: (options)->
    item.addLink options
  datum: (options)->
    item.addDatum options

queryScope = (query)->
  href: (value)->
    query.href = value
  rel: (value)->
    query.rel = value
  datum: (options)->
    query.addDatum options

templateScope = (template)->
  href: (value)->
    template.href = value
  datum: (options)->
    template.addDatum options

cscj.set "collection", (collectionFun)->
  collection = CollectionJSON.create()
  collectionFun.call collectionScope(collection)
  collection.toJSON()

module.exports = cscj
