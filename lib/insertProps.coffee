module.exports =
  simple:
    cursorOffset: 1
    emptyInsert: 'console.log()'
    selectedTextInsert: (text) ->
      "#{text}"

  stringify:
    cursorOffset: 2
    emptyInsert: 'console.log(JSON.stringify())'
    selectedTextInsert: (text) ->
      "JSON.stringify(#{text})"
