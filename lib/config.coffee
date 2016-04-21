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
