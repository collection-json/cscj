cscj = require("coffee-dsl").dsl()
Collection = require "./collection"

cscj.set "collection", (collectionFun)->
  collection = {version:"1.0"}
  root = {collection:collection}
  collectionFun.call new Collection(collection)
  root

module.exports = cscj
