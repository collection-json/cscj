
@collection ->

  @error code: "404", message: "This is a test"

  @href urlFor controller: "index"

  @link href: urlFor(controller: "index"), rel: "index"

  @item ->
    @href urlFor item
    @link href: urlFor(controller: "photos"), rel: "photos"
    for k, v of item
      @datum name: k, value: v

  @query ->
    @href urlFor controller: "people"
    @rel "people"
    @datum name: "firstName", prompt: "First Name"
    @datum name: "lastName", prompt: "Last Name"

  @template ->
    @datum name: "firstName", prompt: "First Name"
    @datum name: "lastName", prompt: "Last Name"
