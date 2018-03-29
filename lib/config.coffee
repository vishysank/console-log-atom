module.exports =
  config:
    semiColons:
      type: 'boolean'
      title: 'Include semi-colons at end of console.log function'
      description: """
        To meet linting requirements, you can choose to include semicolons.
        Defaults to no semi-colons
      """
      default: false
    noSelectionInsert:
      type: 'boolean'
      # coffeelint: disable=max_line_length
      title: "Include 'TEST' string within console statement if no text is selected"
      # coffeelint: enable=max_line_length
      description: """
        Default behaviour does renders empty console statement
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
    identifierPrefix:
      type: 'string'
      title: 'Identifier prefix'
      description: """
        Should be easy to spot. Useful when searching big logs. Example: '<<<--->>>'
      """
      default: ''
    contextMenu:
      type: 'boolean'
      title: 'Context menu'
      default: true
