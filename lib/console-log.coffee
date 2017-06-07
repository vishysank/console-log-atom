{CompositeDisposable} = require 'atom'
settings = require './config'
methods = require './methods'
insertProps = require './insertProps'
contextMenu = require './contextMenu'

module.exports =
  config: settings.config
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add': =>
        @add 'backEnd', 'simple'
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-styling': =>
        @add 'frontEnd', 'simple'
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-JSON-stringify': =>
        @add 'backEnd', 'stringify'
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add-with-JSON-stringify-and-styling': =>
        @add 'frontEnd', 'stringify'
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:deconsoler': => @deconsole()
    @subscriptions.add atom.config.observe 'console-log.contextMenu', (showContextMenu) =>
      if showContextMenu
        @contextMenu = atom.contextMenu.add contextMenu
      else
        @contextMenu?.dispose()

  deactivate: ->
    @subscriptions.dispose()
    @contextMenu?.dispose()

  add: (devLayer, insertType) ->
    if editor = atom.workspace.getActiveTextEditor()
      configProp = methods.getConfig
      cursorOffset = insertProps[insertType].cursorOffset
      selectedText = editor.getSelectedText()
      semiColonConfig = configProp 'console-log.semiColons'
      semiColonValue = ''
      styleValues = methods.setStyleValue
      backgroundStylingConfig = configProp 'console-log.backgroundStyling'
      backgroundStyle = styleValues 'background', backgroundStylingConfig
      textStylingConfig = configProp 'console-log.textStyling'
      textStyle = styleValues 'color', textStylingConfig
      styles =
        if devLayer == 'frontEnd'
        then "#{backgroundStyle}#{textStyle}" else ''

      if semiColonConfig
        semiColonValue = ';'
        cursorOffset++

      if selectedText.length > 0
        if selectedText[selectedText.length - 1] == ';'
          selectedText = selectedText.slice(0, -1)

        checkedRows = 0
        conditionalCheckValues = ['if ', 'if (', 'if(' ]
        chainedconditionalCheckValue = 'else if'
        conditionalFlag = false
        editorLineCount = editor.getLastScreenRow()
        functionCheckValues = ['=>', 'function', '){', ') {']
        identifierCaseConfig = configProp 'console-log.identifierCase'
        identifier = (
          if identifierCaseConfig
          then selectedText else selectedText.toUpperCase()
        ).replace /('|\\)/g, '\\$1'

        objectFlag = true
        objectCount = 0
        selectedTextScreenRow = editor.getSelectedScreenRange().getRows()

        selectedTextInsert =
          insertProps[insertType].selectedTextInsert selectedText

        editor.selectToBeginningOfLine()
        lineTextBeforeSelectedText = editor.getSelectedText().split ''
        editor.moveToFirstCharacterOfLine()
        editor.selectToEndOfLine()
        functionCheckSelection = editor.getSelectedText()
        objectCheckSelection = functionCheckSelection.split ''

        if '(' not in lineTextBeforeSelectedText
          objectFlag = true

        for val in functionCheckValues
          if functionCheckSelection.indexOf(val) > -1
            objectFlag = false

        if functionCheckSelection.match(new RegExp('^if[ (]'))
          objectFlag = false
          conditionalFlag = true

        if functionCheckSelection.indexOf(chainedconditionalCheckValue) > -1
          objectFlag = false
          conditionalFlag = false

        if objectFlag
          objectCount = objectCount + methods.objectCheck objectCheckSelection

        while objectCount > 0
          if selectedTextScreenRow < editorLineCount
            editor.moveToBeginningOfLine()
            editor.moveDown 1
            editor.selectToEndOfLine()
            selectedTextScreenRow++
            checkedRows++
            objectCheckSelection = editor.getSelectedText().split ''
            objectCount =
              objectCount + methods.objectCheck objectCheckSelection
          else
            editor.moveUp checkedRows
            objectCount = 0

        if conditionalFlag
          editor.moveToBeginningOfLine()
          editor.insertNewline()
          editor.moveUp 1
          if styles.length > 0
            # coffeelint: disable=max_line_length
            editor.insertText "console.log('%c#{identifier}', '#{styles}', #{selectedTextInsert})#{semiColonValue}"
            # coffeelint: enable=max_line_length
          else
            # coffeelint: disable=max_line_length
            editor.insertText "console.log('#{identifier}', #{selectedTextInsert})#{semiColonValue}"
            # coffeelint: enable=max_line_length
          editor.moveToBeginningOfLine()
          editor.selectToEndOfLine()
          editor.autoIndentSelectedRows()
          editor.moveDown 1
          editor.moveToEndOfLine()
          editor.insertNewline()
          if styles.length > 0
            # coffeelint: disable=max_line_length
            editor.insertText "console.log('%cCONDITION PASSED', '#{styles}')#{semiColonValue}"
            # coffeelint: enable=max_line_length
          else
            # coffeelint: disable=max_line_length
            editor.insertText "console.log('CONDITION PASSED')#{semiColonValue}"
        else
          editor.moveToEndOfLine()
          editor.insertNewline()
          if styles.length > 0
            # coffeelint: disable=max_line_length
            editor.insertText "console.log('%c#{identifier}', '#{styles}', #{selectedTextInsert})#{semiColonValue}"
            # coffeelint: enable=max_line_length
          else
            # coffeelint: disable=max_line_length
            editor.insertText "console.log('#{identifier}', #{selectedTextInsert})#{semiColonValue}"
            # coffeelint: enable=max_line_length
      else
        noSelectionTextInsertConfig =
          methods.getConfig 'console-log.noSelectionInsert'
        emptyInsert =
          # coffeelint: disable=max_line_length
          insertProps[insertType].emptyInsert noSelectionTextInsertConfig, styles
          # coffeelint: enable=max_line_length

        editor.insertText "#{emptyInsert}#{semiColonValue}"
        editor.moveLeft cursorOffset

  deconsole: ->
    if editor = atom.workspace.getActiveTextEditor()
      editor.setCursorScreenPosition [0,0]
      editorLineCount = editor.getLastScreenRow()
      checkedRow = 0
      messageRowSet = []
      filePath = editor.getPath()

      while checkedRow <= editorLineCount
        editor.selectToEndOfLine()
        checkedRowText = editor.getSelectedText()

        if checkedRowText.indexOf('console.log') > -1
          selectedTextScreenRow = editor.getSelectedScreenRange().getRows()
          messageRowSet.push checkedRow + 1
          editor.deleteLine()
          checkedRow++
        else
          checkedRow++
          editor.moveToBeginningOfLine()
          editor.moveDown 1

      editor.setCursorScreenPosition [(editorLineCount+1), 0]
      atom.notifications.addSuccess "#{filePath} has been deconsoled",
        detail: """
          #{messageRowSet.length} rows with console.log have been removed
          Line locations: #{messageRowSet}
          If you want to revert after closing this message,
          hit "undo" * the number of lines that have been removed
        """,
        dismissable: true
