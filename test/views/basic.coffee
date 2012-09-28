
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
