CoffeeScript meets Collection+JSON (cscj)
=========================================

cscj is a little templating library that makes writing the Collection+JSON media type painless:

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
      "error":{
         "code":"404",
         "message":"This is a test"
      },
      "links":[
         {
            "href":"http://localhost:5000",
            "rel":"index"
         }
      ],
      "items":[
         {
            "href":"http://localhost:5000/people/1",
            "links":[
               {
                  "href":"http://localhost:5000/1/photos",
                  "rel":"photos"
               }
            ],
            "data":[
               {
                  "name":"firstName",
                  "value":"Cameron",
                  "prompt":"First Name"
               },
               {
                  "name":"lastName",
                  "value":"Bytheway",
                  "prompt":"Last Name"
               }
            ]
         }
      ],
      "queries":[
         {
            "href":"http://localhost:5000/people",
            "rel":"people",
            "data":[
               {
                  "name":"firstName",
                  "prompt":"First Name"
               },
               {
                  "name":"lastName",
                  "prompt":"Last Name"
               }
            ]
         }
      ],
      "template":{
         "data":[
            {
               "name":"firstName",
               "prompt":"First Name"
            },
            {
               "name":"lastName",
               "prompt":"Last Name"
            }
         ]
      }
   }
}
```

Usage
-----

Just add it to your dependencies in `package.json` and you're ready to go!

Tests
-----
```bash
npm install -d
npm test
```
