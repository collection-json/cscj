
should = require "should"

cscj = require ".."

expectations = (error, result)->
  should.not.exist error
  should.exist result
  should.exist result.collection
  should.exist result.collection.version
  should.exist result.collection.error
  should.exist result.collection.links
  should.exist result.collection.items
  should.exist result.collection.queries
  should.exist result.collection.template
  result.collection.links.length.should.equal 1
  result.collection.items.length.should.equal 1

describe "CoffeeScript Collection+JSON", ->
  it "should render a basic view", (done)->

    cscj.renderFile "#{__dirname}/views/basic.coffee", {}, (error, result)->
      expectations error, result
      done()

  it "should render a view with variables", (done)->

    cscj.renderFile "#{__dirname}/views/variables.coffee", {site: "http://localhost:5000"}, (error, result)->
      expectations error, result
      done()

  it "should render a view with helpers", (done)->

    urlFor = (otps)->
      "http://localhost:5000"

    options =
      urlFor: urlFor
      item:
        firstName: "Cameron"
        lastName: "Bytheway"

    cscj.renderFile "#{__dirname}/views/helpers.coffee", options, (error, result)->
      expectations error, result
      done()

  it "should give an error when a variable is not in scope", (done)->
    cscj.renderFile "#{__dirname}/views/variables.coffee", {}, (error, result)->
      should.exist error
      done()


  it "should give an error when a helper throws an exception", (done)->
    message = "Just for fun"
    urlFor = (otps)->
      throw new Error message
    cscj.renderFile "#{__dirname}/views/helpers.coffee", {urlFor:urlFor}, (error, result)->
      should.exist error
      error.message.should.equal message
      done()
