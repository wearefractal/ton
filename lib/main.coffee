processors = []

add = (name, test) -> processors.unshift name: name, test: test
remove = (name) -> delete processors[idx] for proc, idx in processors when proc.name is name
stringify = (val) ->
  for obj in processors
    out = obj.test val
    return out if out?

# Add our built-in types
add "object", (val) -> 
  if typeof val is "object"
    keys = Object.keys val
    return "{}" unless keys.length
    return "{#{keys.map((key) -> "#{stringify(key)}:#{stringify(val[key])}").join(',')}}"
add "RegExp", (val) -> String val if val instanceof RegExp
add "Date", (val) -> "new Date(\"#{val.toISOString()}\")" if val instanceof Date
add "Array", (val) -> "[#{val.map(stringify).join(',')}]" if Array.isArray val
add "function", (val) -> String val if typeof val is 'function'
add "number", (val) -> String val if typeof val is 'number'
add "boolean", (val) -> String val if typeof val is 'boolean'
add "string", (val) -> JSON.stringify(val) if typeof val is 'string'
add "undefined", (val) -> "undefined" if typeof val is 'undefined'
add "null", (val) -> "null" if val is null

module.exports =
  add: add
  remove: remove
  stringify: stringify
  parse: (str) -> eval "(#{str})" # TODO: write a parser