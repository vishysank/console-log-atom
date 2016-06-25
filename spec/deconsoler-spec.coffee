consoleLog = require "../lib/console-log.coffee"

describe "Deconsoler :", ->
  beforeEach ->
    waitsForPromise ->
      atom.workspace.open "test.js"

  testString = """
    console.log('test');
    test string
    console.log('TEST', test)
    test string
    console.log('TEST', JSON.stringify(test))
    test string
    console.log()
  """

  testStringWithoutConsoleInserts = """
    test string
    test string
    test string
  """
  consoleInsertLineNumbers = [1,3,5,7]

  it "should remove all console.log statements", ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText testString
    consoleLog.deconsole()
    expect(editor.getText()).toNotContain "console.log"

  it "should remove lines that contain console.log statements", ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText testString
    consoleLog.deconsole()
    expect(editor.getText()).toEqual testStringWithoutConsoleInserts

  it "should remove lines that contain console.log statements", ->
    editor = atom.workspace.getActiveTextEditor()
    editor.insertText testString
    consoleLog.deconsole()
    notificationArray = atom.notifications.getNotifications()
    expect(notificationArray[0].type).toEqual "success"
    expect(notificationArray[0].message).toContain "test.js has been deconsoled"
    expect(notificationArray[0].options.detail).toContain """
      #{consoleInsertLineNumbers.length} rows with console.log have been removed
    """
    expect(notificationArray[0].options.detail).toContain """
      Line locations: #{consoleInsertLineNumbers.join()}
    """
