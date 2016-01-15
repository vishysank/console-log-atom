{CompositeDisposable} = require 'atom'

module.exports =
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
      if selectedText.length > 0
        editor.moveToEndOfLine()
        editor.insertNewline()
        editor.insertText("console.log('"+ selectedText.toUpperCase() + "', " + selectedText + ")")
      else
        editor.insertText("console.log()")
        editor.moveLeft(1)
