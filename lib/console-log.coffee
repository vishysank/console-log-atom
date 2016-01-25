{CompositeDisposable} = require 'atom'

module.exports =

  config:
    semiColons:
      type: 'boolean',
      title: 'Include semi-colons at end of console.log function',
      description: 'Depending on the linting standard you use, you can choose to include semicolons. Defaults to no semi-colons'
      default: false

  subscriptions: null
  
  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'console-log:add': => @add()

  deactivate: ->
    @subscriptions.dispose()

  add: ->
    if editor = atom.workspace.getActiveTextEditor()
      selectedText = editor.getSelectedText()
      semiColonConfig = atom.config.get('console-log.semiColons')
      semiColonValue = if semiColonConfig then ';' else ''
      cursorOffset = if semiColonConfig then 2 else 1

      if selectedText.length > 0
        editor.moveToEndOfLine()
        editor.insertNewline()
        editor.insertText("console.log('#{selectedText.toUpperCase()}', #{selectedText})#{semiColonValue}")
      else
        editor.insertText("console.log()#{semiColonValue}")
        editor.moveLeft(cursorOffset)
