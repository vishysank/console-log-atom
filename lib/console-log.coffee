{CompositeDisposable} = require 'atom'

module.exports =
  # TODO: move this config data to a new file
  config:
    semiColons:
      type: 'boolean'
      title: 'Include semi-colons at end of console.log function'
      description: """
        Depending on the linting standard you use, you can choose to include semicolons. Defaults to no semi-colons
        """
      default: false
    identifierCase:
      type: 'boolean'
      title: 'Retain case of selected text when creating identifier'
      description: """
        Default behaviour creates an identifier in capital case of selected text
        """
      default: false
    backgroundStyling:
      type: 'string'
      title: 'Include background styling for console identifier'
      description: """
        Currently only supported for logging displayed in chrome browser console
        """
      default: 'none'
      enum: [
        'none',
        'red',
        'blue',
        'green',
        'purple',
        'black'
      ]
    textStyling:
      type: 'string'
      title: 'Include text styling for console identifier'
      description: """
        Currently only supported for logging displayed in chrome browser console
        """
      default: 'none'
      enum: [
        'none',
        'red',
        'blue',
        'green',
        'purple',
        'white'
      ]
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add': => @add('backEnd')
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-styling': => @add('frontEnd')
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-JSON-stringify': => @addWithJSONStringify('backEnd')
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-JSON-stringify-and-styling': => @addWithJSONStringify('frontEnd')
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:deconsoler': => @deconsole()

  deactivate: ->
    @subscriptions.dispose()

  # TODO: move add to a new file
  add: (devLayer) ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      semiColonConfig = atom.config.get('console-log.semiColons')
      semiColonValue = if semiColonConfig then ';' else ''
      cursorOffset = if semiColonConfig then 2 else 1

      if selectedText.length > 0
        backgroundStylingConfig = atom.config.get('console-log.backgroundStyling')
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
          editor.insertText("console.log('%c#{identifier}', '#{styles}', #{selectedText})#{semiColonValue}")
        else
          editor.insertText("console.log('#{identifier}', #{selectedText})#{semiColonValue}")
      else
        editor.insertText("console.log()#{semiColonValue}")
        editor.moveLeft(cursorOffset)

  # TODO: addWithJSONStringify should be moved to a new file
  addWithJSONStringify: (devLayer) ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      semiColonConfig = atom.config.get('console-log.semiColons')
      semiColonValue = if semiColonConfig then ';' else ''
      cursorOffset = if semiColonConfig then 3 else 2

      if selectedText.length > 0
        backgroundStylingConfig = atom.config.get('console-log.backgroundStyling')
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
          editor.insertText("console.log('%c#{identifier}', '#{styles}', JSON.stringify(#{selectedText}))#{semiColonValue}")
        else
          editor.insertText("console.log('#{identifier}', JSON.stringify(#{selectedText}))#{semiColonValue}")
      else
        editor.insertText("console.log(JSON.stringify())#{semiColonValue}")
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
