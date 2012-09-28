
@collection ->

  @error code: "404", message: "This is a test"

  @href site

  @link href: site, rel: "index"

  @item ->
    @href "#{site}/people/1"
    @link href: "#{site}/1/photos", rel: "photos"
    @datum name: "firstName", value: "Cameron", prompt: "First Name"
    @datum name: "lastName", value: "Bytheway", prompt: "Last Name"

  @query ->
    @href "#{site}/people"
    @rel "people"
    @datum name: "firstName", prompt: "First Name"
    @datum name: "lastName", prompt: "Last Name"

  @template ->
    @datum name: "firstName", prompt: "First Name"
    @datum name: "lastName", prompt: "Last Name"
