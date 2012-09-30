class Item
  constructor: (@_item)->
  href: (value)->
    @_item.href = value
  link: (options)->
    @_item.links ||= []
    @_item.links.push options
  datum: (options)->
    @_item.data ||= []
    @_item.data.push options

module.exports = Item
