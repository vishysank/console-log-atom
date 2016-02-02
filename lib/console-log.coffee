{CompositeDisposable} = require 'atom'

module.exports =

  config:
    semiColons:
      type: 'boolean'
      title: 'Include semi-colons at end of console.log function'
      description: 'Depending on the linting standard you use, you can choose to include semicolons. Defaults to no semi-colons'
      default: false
    identifierCase:
      type: 'boolean'
      title: 'Retain case of selected text when creating identifier'
      description: 'Default behaviour creates an identifier in capital case of selected text'
      default: false

  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add': => @add()
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-JSON-stringify': => @addWithJSONStringify()

  deactivate: ->
    @subscriptions.dispose()

  add: ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      semiColonConfig = atom.config.get('console-log.semiColons')
      identifierCaseConfig = atom.config.get('console-log.identifierCase')
      semiColonValue = if semiColonConfig then ';' else ''
      cursorOffset = if semiColonConfig then 3 else 2

      if selectedText.length > 0
        identifier =
          if identifierCaseConfig
          then selectedText else selectedText.toUpperCase()
        selectedTextScreenRow = editor.getSelectedScreenRange().getRows()
        editorLineCount = editor.getLastScreenRow()
        checkedRows = 0

        editor.moveToBeginningOfLine()
        editor.selectToEndOfLine()

        functionCheckSelection = editor.getSelectedText().split(" ")
        objectCheckSelection = editor.getSelectedText().split("")
        objectCheckValues = ['=>', "function", "if"]
        objectFlag = true
        objectCount = 0

        functionCheckSelection.forEach (e) ->
          if objectCheckValues.indexOf(e) > -1
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
        editor.insertText("console.log('#{identifier}', #{selectedText})#{semiColonValue}")
      else
        editor.insertText("console.log()#{semiColonValue}")
        editor.moveLeft(cursorOffset)


  addWithJSONStringify: ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      semiColonConfig = atom.config.get('console-log.semiColons')
      identifierCaseConfig = atom.config.get('console-log.identifierCase')
      semiColonValue = if semiColonConfig then ';' else ''
      cursorOffset = if semiColonConfig then 3 else 2

      if selectedText.length > 0
        identifier =
          if identifierCaseConfig
          then selectedText else selectedText.toUpperCase()
        selectedTextScreenRow = editor.getSelectedScreenRange().getRows()
        editorLineCount = editor.getLastScreenRow()
        checkedRows = 0

        editor.moveToBeginningOfLine()
        editor.selectToEndOfLine()

        functionCheckSelection = editor.getSelectedText().split(" ")
        objectCheckSelection = editor.getSelectedText().split("")
        objectCheckValues = ['=>', "function", "if"]
        objectFlag = true
        objectCount = 0

        functionCheckSelection.forEach (e) ->
          if objectCheckValues.indexOf(e) > -1
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
        editor.insertText("console.log('#{identifier}', JSON.stringify(#{selectedText}))#{semiColonValue}")
      else
        editor.insertText("console.log(JSON.stringify())#{semiColonValue}")
        editor.moveLeft(cursorOffset)
