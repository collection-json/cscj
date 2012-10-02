CoffeeScript meets Collection+JSON (cscj) [![Build Status](https://secure.travis-ci.org/CamShaft/cscj.png)](http://travis-ci.org/CamShaft/cscj)
=========================================

cscj is a little templating library that makes writing the Collection+JSON media type painless.

Public API
----------

```coffee
cscj = require "cscj"

view = """
@collection ->
  @href "http://example.com"
"""

fn = cscj.compile view, options
fn(locals)
```

### Options

* `locals` Local variable object
* `filename` Used in exceptions
* `debug` Outputs tokens and function body generated

Syntax
------

A collection is started by defining the root:

```coffee
@collection ->

  # Collection parts go here

```

### Collection

```coffee
@collection ->
  
  # Let's set our `href`
  @href "http://example.com"

  # Oops there was an error!
  @error title: "Not Found!", code: "404", message: "This is not the collection your are looking for"

  # We can also specify the error type
  @error "password", title: "Invalid password": code: "400", message: "Too short"

  # We can add some links
  @link href: "http://example.com", rel: "index"
  @link href: "http://example.com/users", rel: "users"
  @link href: "http://example.com/posts", rel: "posts"

  # Add an item
  @item ->

    # Item parts go here

  # Add a query
  @query ->

    # Query parts go here

  # Add a template
  @template ->

    # Template parts go here

```

### Item

```coffee
@item ->

  # Href
  @href "http://example.com/users/1"

  # Links
  @link href: "http://example.com/users/1/photos", rel: "photos"
  @link href: "http://example.com/users/1/friends", rel: "friends"

  # Data
  @datum name: "firstName", value: "Cameron", prompt: "First Name"
  @datum name: "lastName", value: "Bytheway", prompt: "Last Name"
```

### Query

```coffee
@query ->

  # Href
  @href "http://example.com/users"

  # Rel
  @rel "users"

  # Data
  @datum name: "firstName", prompt: "First Name"
  @datum name: "lastName", prompt: "Last Name"

  # Optional

  # Encoding is defined by the extension for URI Templates
  # https://github.com/mamund/collection-json/blob/master/extensions/uri-templates.md
  @encoding "uri-template"
```

### Template

```coffee
@template ->

  # Data
  @datum name: "firstName", prompt: "First Name"
  @datum name: "lastName", prompt: "Last Name"

  # Optional

  # The following are defined by the extension for multiple templates
  # https://github.com/mamund/collection-json/blob/master/extensions/templates.md

  @href "http://example.com/users/avatar"

  @rel "avatar"

  @type "application/x-www-form-urlencoded"

  @name "avatar"
```

Referencing Local Variables
---------------------------

When we pass in locals, they are referenced as normal variables:

```coffee
# example.coffee
cscj = require "cscj"

cscj.renderFile "./view.coffee", {root: "http://example.com"}, (error, collection)->
  console.log collection
```

```coffee
# view.coffee
@collection ->
  
  @href root
```

Running this code will output:

```json
{
   "collection":{
      "href":"http://example.com",
      "version":"1.0"
   }
}
```

You can also define helpers:

```coffee
# example2.coffee
cscj = require "cscj"

locals =
  links: (collection)->
    collection.link rel: "index", href: "http://example.com"
    collection.link rel: "users", href: "http://example.com/users"
  root: "http://example.com"

cscj.renderFile "./view.coffee", locals, (error, collection)->
  console.log collection
```

```coffee
# view.coffee
@collection ->

  @href root
  links @
```

Running this code will output:

```json
{
   "collection":{
      "href":"http://example.com",
      "version":"1.0",
      "links": [
        { "href": "http://example.com", "rel": "index" },
        { "href": "http://example.com/users", "rel": "users" }
      ]
   }
}
```

Using CoffeeScript
------------------

Since the template is just CoffeeScript you can do some powerful stuff:

```coffee
@collection ->
  ...
  for item in items
    @item ->

      @href item.href

      # Iterate the links in the item
      for link in item.links
        @link rel: link.rel, href: link.href

      # Iterate the keys in the item and add them to the `data` array
      for key, value of item
        @datum name: key, value: value if not (key in ["href", "links"])
  ...
```

Example
-------

```coffee
# views/index.coffee
@collection ->

  root = "http://localhost:5000"

  @error code: "404", message: "This is a test"

  @href root

  @link href: root, rel: "index"

  @item ->
    @href "#{root}/people/1"
    @link href: "#{root}/1/photos", rel: "photos"
    @datum name: "firstName", value: "Cameron", prompt: "First Name"
    @datum name: "lastName", value: "Bytheway", prompt: "Last Name"

  @query ->
    @href "#{root}/people"
    @rel "people"
    @datum name: "firstName", prompt: "First Name"
    @datum name: "lastName", prompt: "Last Name"

  @template ->
    @datum name: "firstName", prompt: "First Name"
    @datum name: "lastName", prompt: "Last Name"
```

which would render

```json
{
   "collection":{
      "href":"http://localhost:5000",
      "version":"1.0",
      "error":{ "code":"404", "message":"This is a test" },
      "links":[
         { "href":"http://localhost:5000", "rel":"index" }
      ],
      "items":[
         {
            "href":"http://localhost:5000/people/1",
            "links":[
               { "href":"http://localhost:5000/1/photos", "rel":"photos" }
            ],
            "data":[
               { "name":"firstName", "value":"Cameron", "prompt":"First Name" },
               { "name":"lastName", "value":"Bytheway", "prompt":"Last Name" }
            ]
         }
      ],
      "queries":[
         {
            "href":"http://localhost:5000/people",
            "rel":"people",
            "data":[
               { "name":"firstName", "prompt":"First Name" },
               { "name":"lastName", "prompt":"Last Name" }
            ]
         }
      ],
      "template":{
         "data":[
            { "name":"firstName", "prompt":"First Name" },
            { "name":"lastName", "prompt":"Last Name" }
         ]
      }
   }
}
```

Tests
-----
```bash
npm install -d
npm test
```
