class Template
  constructor: (@_template) ->
  href: (value)->
    @_template.href = value
  datum: (options)->
    @_template.data ||= []
    @_template.data.push options

module.exports = Template
