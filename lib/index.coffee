fs = require "fs"
coffee = require "coffee-script"
CollectionJSON = require "collection-json"

readCache = {}
cacheStore = {}
requires = {}

render = (str, renderOptions, done)->
  shimmed =
  """
  (()->
    #{replaceAll(str, '\n','\n\t')}
  ).call __cscj
  """

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

  __cscj =
    collection: (collectionFun)->
      collection = CollectionJSON.create()
      collectionFun.call collectionScope(collection)
      collection.toJSON()

  renderOptions.__cscj = __cscj

  try
    result = coffee.eval shimmed, sandbox:renderOptions
    done null, result
  catch e
    done e

module.exports = (path, options, done)->
  fs.readFile path, "utf8", (err, str)->
    return done err if err
    render str, options, done

module.exports.render = render

# http://fagnerbrack.com/en/2012/03/27/javascript-replaceall/
# Faster than str.replace
replaceAll = (str, token, newToken, ignoreCase) ->
  i = -1
  _token = undefined
  if typeof token is "string"
    _token = (if ignoreCase is true then token.toLowerCase() else `undefined`)
    str = str.substring(0, i)
             .concat(newToken)
             .concat(str.substring(i + token.length)) while (i = ((if _token isnt `undefined` then str.toLowerCase().indexOf(_token, (if i >= 0 then i + newToken.length else 0)) else str.indexOf(token, (if i >= 0 then i + newToken.length else 0))))) isnt -1
  str
