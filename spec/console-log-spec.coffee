consoleLog = require("../lib/console-log.coffee")

describe "console.log inserts", ->
  beforeEach ->
    waitsForPromise ->
      atom.workspace.open("test.js")

  describe "back end inserts", ->
    devLayer = "backEnd"
    testString = "test"
    insert = "console.log()"

    it "should add insert at cursor position", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.insertText(testString)
      consoleLog.add(devLayer)
      expect(editor.getText()).toEqual "#{testString}#{insert}"
      editor.moveToBeginningOfLine()
      consoleLog.add(devLayer)
      expect(editor.getText()).toEqual "#{insert}#{testString}#{insert}"

    it "should add cursor between parenthesis of insert", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.insertText(testString)
      consoleLog.add(devLayer)
      expect(editor.getText()).toEqual "#{testString}#{insert}"
      editor.selectToEndOfLine()
      expect(editor.getSelectedText()).toEqual ")"

    it """
      should have a semi colon at end of insert
      if semi colon config is chosen
    """, ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set('console-log.semiColons', true)
      editor.insertText(testString)
      consoleLog.add(devLayer)
      expect(editor.getText()).toEqual "#{testString}#{insert};"
