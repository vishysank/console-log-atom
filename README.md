[![Build Status](https://travis-ci.org/vishysank/console-log-atom.svg?branch=master&style=flat-square)](https://travis-ci.org/vishysank/console-log-atom)
[![apm](https://img.shields.io/apm/l/console-log.svg?style=flat-square)](https://atom.io/packages/console-log)
[![apm](https://img.shields.io/apm/v/console-log.svg?style=flat-square)](https://atom.io/packages/console-log)
[![apm](https://img.shields.io/apm/dm/console-log.svg?style=flat-square)](https://atom.io/packages/console-log)
# console-log package

console-log is a simple  and smart helper function that makes logging and debugging easy.
**New Config options added**

## Features (click for demo)
### Basic Logging
* ```ctrl-l``` (OSX) or ```ctrl-alt-l``` (Linux/Windows) - [Generates a console.log with identifier if text/variable is selected, and empty console.log if no text is selected.](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/console-log-demo.gif)
* ```ctrl-o``` (OSX) or ```ctrl-alt-o``` (Linux/Windows) - [Generates a console.log with text/variable within a JSON.stringify method.](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/console-log-stringify-demo.gif)

### Smart Object Logging (Incremental improvements in works)
* [If selected text is the variable being defined to create an object, places console.log after object has been created to prevent any code breaks.](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/console-log-object-demo.gif)

### Smart Function Logging (Early release still in works)
* [If function name is selected, places console.log after function has been created. If param is selected, places the console.log statement within the param](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/console-log-function-demo.gif)

### Smart Conditionals Logging (early release)
* [if a variable used in a definition of the conditional in an if statement is logged, the insert is placed on the line above the if statement, so that the logging is not lost if the condition doesn't pass. For subsequent chained conditionals, insert is placed within the conditional.](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/console-log-conditional-demo.gif)

### Logging Cleanup
* ```ctrl-shift-D``` - [clean out all the lines that contain console.log statements in the file.](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/deconsoler-demo.gif)

### Identifier Styling (Chrome Dev Tools only)
**Note:- This functionality will only work for selected text**
* ```ctrl-alt-c``` (plain insert) or ```ctrl-alt-s``` (JSON.stringify insert) - [For logging in the chrome dev tools console, you can choose to enable text styling for the identifier](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/styling-demo.png)

## Installation
You can install this package from the CLI or from the Editor.
* CLI - ```apm install console-log```
* Editor - ```Atom > Preferences > Install > Search for console-log in Packages```

## Configurations

* **Include semi-colons :** Choose whether you want to include semi-colons at end of console.log function. Depending on the linting standard you use, you can choose to include semicolons. **Defaults to no semi-colons**
* **Define Identifier case :** Choose whether to retain case of selected text when creating identifier. **Defaults to creating an identifier in capital case of selected text**
* **Include background style for identifier:** For logging in the chrome dev tools console, you can choose to enable background styling for the identifier **defaults to none**
* **Include text style for identifier:** For logging in the chrome dev tools console, you can choose to enable text styling for the identifier **defaults to none**
* **Include String TEST for identification if no text selected:** Rather than include a dumb ```console.log()``` insert, if you can select to have ```console.log('TEST')``` inserted, which will show up as the code run past it.

## Languages Supported
* Javascript

## Coming soon !
* Support for single line es6 arrow functions
* **code contributions are welcome.**

## Help me help you !

If you see any bugs in this package or if you have any additional features that you would like, please add an issue to this repo and I will look to resolve it.
