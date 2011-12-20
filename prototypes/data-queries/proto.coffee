# TODO: blocked by https://github.com/ql-io/ql.io/issues/57

Engine = require 'ql.io-engine'
engine = new Engine connection: 'close'

script = """
foo = {
  "fname" : "Hello",
  "lname" : "World",
  "place" : "Sammamish, WA"};
data = select fname, lname, place from foo;
return {
  "data" :  "{data}"
};
"""

engine.exec script, (err, res) ->
    console.log res.body[0]