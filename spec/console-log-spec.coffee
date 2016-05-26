consoleLog = require "../lib/console-log.coffee"

describe "console.log inserts", ->
  insertType = 'simple'
  beforeEach ->
    waitsForPromise ->
      atom.workspace.open "test.js"

  testString = "test"
  insert = "console.log()"

  describe "back end inserts", ->
    devLayer = "backEnd"
    noSelectionTestInsert = "console.log('TEST')"

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
      consoleLog.add devLayer, insertType
      editor.selectToEndOfLine()
      expect(editor.getSelectedText()).toEqual ")"

    it """
      should have a semi colon at end of insert
      if semi colon config is chosen
    """, ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set 'console-log.semiColons', true
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual "#{insert};"

    describe "when noSelectionTestInsert config is selected", ->
      it "should have TEST string as insert", ->
        editor = atom.workspace.getActiveTextEditor()
        atom.config.set 'console-log.noSelectionInsert', true
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toEqual noSelectionTestInsert

  describe "front end inserts", ->
    devLayer = "frontEnd"
    styleColor = "red"
    noSelectionTestInsert =
      "console.log('%cTEST', background:#{styleColor};color:#{styleColor};)"

    it "should have no styling if configs are set to none", ->
      editor = atom.workspace.getActiveTextEditor()
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual insert

    it "should have no background styling even if config is set", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set 'console-log.backgroundStyling', styleColor
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual insert

    it "should have no text styling even if config is set", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set 'console-log.textStyling', styleColor
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual insert

    describe "when noSelectionTestInsert config is selected", ->
      it "should have TEST string as insert and and config values set", ->
        editor = atom.workspace.getActiveTextEditor()
        atom.config.set 'console-log.noSelectionInsert', true
        atom.config.set 'console-log.backgroundStyling', styleColor
        atom.config.set 'console-log.textStyling', styleColor
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toEqual noSelectionTestInsert
