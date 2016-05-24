consoleLog = require "../lib/console-log.coffee"

describe "console.log with JSON.stringify inserts", ->
  insertType = 'stringify'
  insert = "console.log(JSON.stringify())"
  noSelectionTestInsert = "console.log(JSON.stringify('TEST'))"
  beforeEach ->
    waitsForPromise ->
      atom.workspace.open "test.js"

  describe "back end inserts", ->
    devLayer = "backEnd"
    testString = "test"

    it "should add insert at cursor position", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.insertText testString
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual "#{testString}#{insert}"
      editor.moveToBeginningOfLine()
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual "#{insert}#{testString}#{insert}"

    it "should add cursor between parenthesis of insert", ->
      editor = atom.workspace.getActiveTextEditor()
      editor.insertText testString
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual "#{testString}#{insert}"
      editor.selectToEndOfLine()
      expect(editor.getSelectedText()).toEqual "))"

    it """
      should have a semi colon at end of insert
      if semi colon config is chosen
    """, ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set 'console-log.semiColons', true
      editor.insertText testString
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual "#{testString}#{insert};"

    it """
      should have TEST string as insert
      if noSelectionTestInsert config is selected
    """, ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set 'console-log.noSelectionInsert', true
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual "#{noSelectionTestInsert}"

  describe "front end inserts", ->
    devLayer = "frontEnd"
    styleColor = "red"

    it "should have no styling if configs are set to none", ->
      editor = atom.workspace.getActiveTextEditor()
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual insert

    it """
      if no text is selected,
      should have no background styling even if config is set
    """, ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set 'console-log.backgroundStyling', styleColor
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual insert

    it """
      if no text is selected,
      should have no text styling even if config is set
    """, ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set 'console-log.textStyling', styleColor
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual insert
