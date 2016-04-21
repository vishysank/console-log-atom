{CompositeDisposable} = require 'atom'
settings = require('./config')

module.exports =
  config: settings.config
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add': =>
        @add('backEnd', 'simple')
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-styling': =>
        @add('frontEnd', 'simple')
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-JSON-stringify': =>
        @add('backEnd', 'stringify')
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-JSON-stringify-and-styling': =>
        @add('frontEnd', 'stringify')
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:deconsoler': => @deconsole()

  deactivate: ->
    @subscriptions.dispose()

  # TODO: move add to a new file
  add: (devLayer, insertType) ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      semiColonConfig = atom.config.get('console-log.semiColons')
      semiColonValue = ''
      cursorOffset = switch insertType
        when 'simple' then 1
        when 'stringify' then 2
      emptyInsert = switch insertType
        when 'simple' then 'console.log()'
        when 'stringify' then 'console.log(JSON.stringify())'

      if semiColonConfig
        semiColonValue = ';'
        cursorOffset++

      if selectedText.length > 0
        backgroundStylingConfig =
          atom.config.get('console-log.backgroundStyling')
        textStylingConfig = atom.config.get('console-log.textStyling')
        backgroundStyle =
          if backgroundStylingConfig == 'none'
          then '' else "background:#{backgroundStylingConfig}; "
        textStyle =
          if textStylingConfig == 'none'
          then '' else "color:#{textStylingConfig};"
        styles =
          if devLayer == 'frontEnd'
          then "#{backgroundStyle}#{textStyle}" else ''
        identifierCaseConfig = atom.config.get('console-log.identifierCase')
        identifier =
          if identifierCaseConfig
          then selectedText else selectedText.toUpperCase()
        selectedTextScreenRow = editor.getSelectedScreenRange().getRows()
        editorLineCount = editor.getLastScreenRow()
        checkedRows = 0
        selectedTextInsert = switch insertType
          when 'simple' then "#{selectedText}"
          when 'stringify' then "JSON.stringify(#{selectedText})"

        editor.selectToBeginningOfLine()
        lineTextBeforeSelectedText = editor.getSelectedText().split("")

        editor.moveToBeginningOfLine()
        editor.selectToEndOfLine()

        functionCheckSelection = editor.getSelectedText()
        objectCheckSelection = editor.getSelectedText().split("")
        objectCheckValues = ['=>', "function", "if", "){", ") {"]
        objectFlag = true
        objectCount = 0

        objectCheckValues.forEach (e) ->
          if functionCheckSelection.indexOf(e) > -1
            objectFlag = false

        if objectFlag == false
          if lineTextBeforeSelectedText.indexOf('(') < 0
            objectFlag = true

        if objectFlag == true
          objectCheckSelection.forEach (e) ->
            if e == '{'
              objectCount++
            if e == '}'
              objectCount--

        while objectCount > 0
          if selectedTextScreenRow < editorLineCount
            editor.moveToBeginningOfLine()
            editor.moveDown(1)
            editor.selectToEndOfLine()
            selectedTextScreenRow++
            checkedRows++
            objectCheckSelection = editor.getSelectedText().split("")
            objectCheckSelection.forEach (e) ->
              if e == '{'
                objectCount++
              if e == '}'
                objectCount--
          else
            editor.moveUp(checkedRows)
            objectCount = 0

        editor.moveToEndOfLine()
        editor.insertNewline()
        if styles.length > 0
          # coffeelint: disable=max_line_length
          editor.insertText("console.log('%c#{identifier}', '#{styles}', #{selectedTextInsert})#{semiColonValue}")
          # coffeelint: enable=max_line_length
        else
          # coffeelint: disable=max_line_length
          editor.insertText("console.log('#{identifier}', #{selectedTextInsert})#{semiColonValue}")
          # coffeelint: enable=max_line_length
      else
        editor.insertText("#{emptyInsert}#{semiColonValue}")
        editor.moveLeft(cursorOffset)

  deconsole: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.setCursorScreenPosition([0,0])
      editorLineCount = editor.getLastScreenRow()
      checkedRow = 0
      rowsToBeDeconsoled = []
      messageRowSet = []
      filePath = editor.getPath()

      while checkedRow <= editorLineCount
        editor.selectToEndOfLine()
        functionCheckSelection = editor.getSelectedText()

        if functionCheckSelection.indexOf('console.log') > -1
          selectedTextScreenRow = editor.getSelectedScreenRange().getRows()
          rowsToBeDeconsoled.push selectedTextScreenRow

        checkedRow++
        editor.moveToBeginningOfLine()
        editor.moveDown(1)

      editor.setCursorScreenPosition([(editorLineCount+1), 0])

      rowsToBeDeconsoled.forEach (row) ->
        editor.addCursorAtScreenPosition([row,0])
        editor.selectToEndOfLine()
        messageRowSet.push (row * 1) + 1

      if rowsToBeDeconsoled.length > 0
        editor.deleteLine()
        editor.setCursorScreenPosition([0,0])

      atom.notifications.addSuccess "#{filePath} has been deconsoled",
        detail: """
        #{rowsToBeDeconsoled.length} rows with console.log have been removed
        Line locations: #{messageRowSet}
        If you want to revert after closing this message,
        hit "undo" twice
        """,
        dismissable: true
