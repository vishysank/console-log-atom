consoleLog = require "../lib/console-log.coffee"

describe "console.log inserts with identifier", ->
  insertType = 'simple'
  beforeEach ->
    waitsForPromise ->
      atom.workspace.open "test.js"

  testString = "test case"
  testObject = """
    object = {
      object2: {
        value: "test"
      }
    }
  """
  testES6ArrowFunction = """
    testFunction (param) => {
      return 'some value'
    }
  """
  testJSFunction = """
    function testFunction (param) {
      return 'some value'
    }
  """
  testFunctionWithoutKeyword = """
    testFunction (param) {
      return 'some value'
    }
  """
  testConditional = """
    if (test === test1) {
      return 'test2'
    }
  """

  describe "back end inserts", ->
    devLayer = "backEnd"

    describe "for Uppercase identifier Case Config", ->
      it "should add contain identifier identical to selected text", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testString
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection.toUpperCase()}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toContain "#{insert}"

      it """
        should add insert with identifier on next line,
        if not an object or function
      """, ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testString
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection.toUpperCase()}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toEqual """
          #{testString}
          #{insert}
        """

      it "should add insert with identifier after an object", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testObject
        editor.setCursorScreenPosition [0,0]
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection.toUpperCase()}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toEqual """
          #{testObject}
          #{insert}
        """

      describe "should add insert within function if param is selected", ->
        it "for es6 arrow function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText testES6ArrowFunction
          editor.setCursorScreenPosition [0,0]
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection.toUpperCase()}', #{selection})"
          consoleLog.add devLayer, insertType
          expect(editor.lineTextForScreenRow 1).toEqual "#{insert}"

        it "for a js function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText testJSFunction
          editor.setCursorScreenPosition [0,0]
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection.toUpperCase()}', #{selection})"
          consoleLog.add devLayer, insertType
          expect(editor.lineTextForScreenRow 1).toEqual "#{insert}"

        it "for a function without keyword", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText testFunctionWithoutKeyword
          editor.setCursorScreenPosition [0,0]
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection.toUpperCase()}', #{selection})"
          consoleLog.add devLayer, insertType
          expect(editor.lineTextForScreenRow 1).toEqual "#{insert}"

      describe "should add insert outside function if name is selected", ->
        it "for es6 arrow function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText testES6ArrowFunction
          editor.setCursorScreenPosition [0,0]
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection.toUpperCase()}', #{selection})"
          consoleLog.add devLayer, insertType
          expect(editor.lineTextForScreenRow 3).toEqual "#{insert}"

        it "for a js function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText testJSFunction
          editor.setCursorScreenPosition [0,0]
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection.toUpperCase()}', #{selection})"
          consoleLog.add devLayer, insertType
          expect(editor.lineTextForScreenRow 3).toEqual "#{insert}"

        it "for a function without keyword", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText testFunctionWithoutKeyword
          editor.setCursorScreenPosition [0,0]
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection.toUpperCase()}', #{selection})"
          consoleLog.add devLayer, insertType
          expect(editor.lineTextForScreenRow 3).toEqual "#{insert}"

      it "should add insert above conditional", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testConditional
        editor.setCursorScreenPosition [0,0]
        editor.moveToEndOfWord()
        editor.moveToEndOfWord()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection.toUpperCase()}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.lineTextForScreenRow 0).toEqual "#{insert}"

      it """
        should have a semi colon at end of insert
        if semi colon config is chosen
      """, ->
        editor = atom.workspace.getActiveTextEditor()
        atom.config.set 'console-log.semiColons', true
        editor.insertText testString
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection.toUpperCase()}', #{selection});"
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toEqual """
          #{testString}
          #{insert}
        """

    describe "for lowercase identifier Case Config", ->
      beforeEach ->
        atom.config.set 'console-log.identifierCase', true

      it "should add contain identifier identical to selected text", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testString
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toContain "#{insert}"

      it """
        should add insert with identifier on next line,
        if not an object or function
      """, ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testString
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toEqual """
          #{testString}
          #{insert}
        """

      it "should add insert with identifier after an object", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testObject
        editor.setCursorScreenPosition [0,0]
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toEqual """
          #{testObject}
          #{insert}
        """

      describe "should add insert within function if param is selected", ->
        it "for es6 arrow function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText testES6ArrowFunction
          editor.setCursorScreenPosition [0,0]
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection}', #{selection})"
          consoleLog.add devLayer, insertType
          expect(editor.lineTextForScreenRow 1).toEqual "#{insert}"

        it "for a js function", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText testJSFunction
          editor.setCursorScreenPosition [0,0]
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection}', #{selection})"
          consoleLog.add devLayer, insertType
          expect(editor.lineTextForScreenRow 1).toEqual "#{insert}"

        it "for a function without keyword", ->
          editor = atom.workspace.getActiveTextEditor()
          editor.insertText testFunctionWithoutKeyword
          editor.setCursorScreenPosition [0,0]
          editor.moveToEndOfWord()
          editor.moveToEndOfWord()
          editor.selectToEndOfWord()
          selection = editor.getSelectedText()
          insert = "console.log('#{selection}', #{selection})"
          consoleLog.add devLayer, insertType
          expect(editor.lineTextForScreenRow 1).toEqual "#{insert}"


      describe "should add insert outside function if name is selected", ->
      it "for es6 arrow function", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testES6ArrowFunction
        editor.setCursorScreenPosition [0,0]
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.lineTextForScreenRow 3).toEqual "#{insert}"

      it "for a js function", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testJSFunction
        editor.setCursorScreenPosition [0,0]
        editor.moveToEndOfWord()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.lineTextForScreenRow 3).toEqual "#{insert}"

      it "a function without keyword", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testFunctionWithoutKeyword
        editor.setCursorScreenPosition [0,0]
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.lineTextForScreenRow 3).toEqual "#{insert}"

      it "should add insert above conditional", ->
        editor = atom.workspace.getActiveTextEditor()
        editor.insertText testConditional
        editor.setCursorScreenPosition [0,0]
        editor.moveToEndOfWord()
        editor.moveToEndOfWord()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', #{selection})"
        consoleLog.add devLayer, insertType
        expect(editor.lineTextForScreenRow 0).toEqual "#{insert}"

      it """
        should have a semi colon at end of insert
        if semi colon config is chosen
      """, ->
        editor = atom.workspace.getActiveTextEditor()
        atom.config.set 'console-log.semiColons', true
        editor.insertText testString
        editor.moveToBeginningOfLine()
        editor.selectToEndOfWord()
        selection = editor.getSelectedText()
        insert = "console.log('#{selection}', #{selection});"
        consoleLog.add devLayer, insertType
        expect(editor.getText()).toEqual """
          #{testString}
          #{insert}
        """

  describe "front end inserts", ->
    devLayer = "frontEnd"
    backgroundColor = "red"
    textColor = "blue"
    backgroundStylingConfig = 'console-log.backgroundStyling'
    textStylingConfig = 'console-log.textStyling'
    backgroundStyleInsert = "background:#{backgroundColor};"
    textStyleInsert = "color:#{textColor};"
    # no need to replicate all the above tests for frontEnd
    # test below ascertaine that the code works properly based on the
    # config definitions for backgroundStyling and textStyling

    it "should not include any styling if configs are set to none", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set backgroundStylingConfig, "none"
      atom.config.set textStylingConfig, "none"
      editor.insertText testString
      editor.moveToBeginningOfLine()
      editor.selectToEndOfWord()
      selection = editor.getSelectedText()
      insert = "console.log('#{selection.toUpperCase()}', #{selection})"
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual """
      #{testString}
      #{insert}
      """

    it "should include background styling if config is set", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set backgroundStylingConfig, backgroundColor
      atom.config.set textStylingConfig, "none"
      editor.insertText testString
      editor.moveToBeginningOfLine()
      editor.selectToEndOfWord()
      selection = editor.getSelectedText()
      # coffeelint: disable=max_line_length
      insert = "console.log('%c#{selection.toUpperCase()}', '#{backgroundStyleInsert}', #{selection})"
      # coffeelint: enable=max_line_length
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual """
      #{testString}
      #{insert}
      """

    it "should include text styling if config is set", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set backgroundStylingConfig, "none"
      atom.config.set textStylingConfig, textColor
      editor.insertText testString
      editor.moveToBeginningOfLine()
      editor.selectToEndOfWord()
      selection = editor.getSelectedText()
      # coffeelint: disable=max_line_length
      insert = "console.log('%c#{selection.toUpperCase()}', '#{textStyleInsert}', #{selection})"
      # coffeelint: enable=max_line_length
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual """
      #{testString}
      #{insert}
      """

    it "should include both background and text styling if config are set", ->
      editor = atom.workspace.getActiveTextEditor()
      atom.config.set backgroundStylingConfig, backgroundColor
      atom.config.set textStylingConfig, textColor
      editor.insertText testString
      editor.moveToBeginningOfLine()
      editor.selectToEndOfWord()
      selection = editor.getSelectedText()
      # coffeelint: disable=max_line_length
      insert = "console.log('%c#{selection.toUpperCase()}', '#{backgroundStyleInsert}#{textStyleInsert}', #{selection})"
      # coffeelint: enable=max_line_length
      consoleLog.add devLayer, insertType
      expect(editor.getText()).toEqual """
      #{testString}
      #{insert}
      """
