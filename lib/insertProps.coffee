module.exports =
  simple:
    cursorOffset: 1
    emptyInsert: (noSelectionTextInsertConfig, styles) ->
      if noSelectionTextInsertConfig && styles.length > 0
      then "console.log('%cTEST', #{styles})"
      else if noSelectionTextInsertConfig
      then "console.log('TEST')"
      else "console.log()"
    selectedTextInsert: (text) ->
      "#{text}"

  stringify:
    cursorOffset: 2
    emptyInsert: (noSelectionTextInsertConfig) ->
      if noSelectionTextInsertConfig
      then "console.log(JSON.stringify('TEST'))"
      else 'console.log(JSON.stringify())'
    selectedTextInsert: (text) ->
      "JSON.stringify(#{text}, null, 2)"
