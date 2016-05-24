{CompositeDisposable} = require 'atom'

module.exports =
  getConfig: (prop) ->
    atom.config.get prop

  setStyleValue: (styleType, val) ->
    if val == 'none'
    then '' else "#{styleType}:#{val};"

  objectCheck: (selection) ->
    objectCount = 0
    for val in selection
      if val == '{'
        objectCount++
      if val == '}'
        objectCount--

    return objectCount
