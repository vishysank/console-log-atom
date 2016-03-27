# console-log package

console-log is a simple  and smart helper function that makes logging and debugging easy. Some basic features:
* Generates a console.log with identifier if text/variable is selected, and empty console.log if no text text is selected. (Look at demo for ```params``` and ```paramValue```)
* Generates a console.log with text/variable within a JSON.stringify method. (Look at demo gif for ```paramObject```)
* If selected text is the variable being defined to create an object, places console.log after object has been created to prevent any code breaks.(Look at demo gif for ```paramObject2```)
* clean out all the lines that contain console.log statements in the file.

## Demo of Adding console.log Statements
![console-log Demo](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/console-log-demo.gif)

## Demo of removing console.log Statements
![Remove console-log Demo](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/deconsoler-demo.gif)

## Installation
You can install this package from the CLI or from the Editor.
* CLI - ```apm install console-log```
* Editor - ```Atom > Preferences > Install > Search for console-log in Packages```

## Configurations

* **Include semi-colons :** Choose whether you want to include semi-colons at end of console.log function. Depending on the linting standard you use, you can choose to include semicolons. **Defaults to no semi-colons**
* **Define Identifier case :** Choose whether to retain case of selected text when creating identifier. **Defaults to creating an identifier in capital case of selected text**
* **Include background style for identifier:** For logging in the chrome dev tools console, you can choose to enable background styling for the identifier **defaults to none**
* **Include text style for identifier:** For logging in the chrome dev tools console, you can choose to enable text styling for the identifier **defaults to none**

## How to use

* **empty console.log function :**
  * ```ctrl-l``` (OSX) or ```ctrl-alt-l``` (Linux/Windows) - mimics ```log-tab``` functionality. When the hotkey(s) is used anywhere in the editor without any selection it will add ```console.log()``` to the editor. Can also be found in the command palette as ```Console Log:Add```

  * ```ctrl-o``` (OSX) or ```ctrl-alt-l``` (Linux/Windows) - When the hotkey ```ctrl-o``` is used anywhere in the editor without any selection it will add ```console.log(JSON.stringify())``` to the editor. Can also be found in the command palette as ```Console Log:Add with JSON.stringify```

* **filled in console.log function :**
  * select text and then ```ctrl-l``` (OSX) or ```ctrl-alt-l``` (Linux/Windows) -  A console.log function with an identifier of the selected value in caps and the value will be added to a new line (so as not to break existing code), and will be indented to the same number of spaces as the previous line. Can also be found in the command palette as ```Console Log:Add```

  * select text and then ```ctrl-o``` (OSX) or ```ctrl-alt-l``` (Linux/Windows) - Same as the above, except the selected text will be couched in a ```JSON.stringify()``` function. Can also be found in the command palette as ```Console Log:Add with JSON.stringify```

* **Remove console.log statements :**
  * ```ctrl-shift-D``` will clean out all the lines that contain console.log statements in the file.

## Languages Supported
* Javascript

## Coming soon !
* **Support for multiple selections**

## Help me help you !

If you see any bugs in this package or if you have any additional features that you would like, please add an issue to this repo and I will look to resolve it.
