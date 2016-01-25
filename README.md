# console-log package

console-log is a simple helper function that makes logging and debugging easy.

## Demo
![console-log Demo](https://raw.githubusercontent.com/vishysank/console-log-atom/master/assets/console-log-demo.gif)

## Installation
You can install this package from the CLI or from the Editor.
* CLI - ```apm install console-log```
* Editor - ```Atom > Preferences > Install > Search for console-log in Packages```

## Features

* **empty console.log function :** mimics ```log-tab``` functionality. When the hotkey ```ctrl-l``` is used anywhere in the editor without any selection it will add ```console.log()``` to the editor. (refer line 6 in gif)

* **filled in console.log function :** if you want to console.log a specific variable, constant or value in your code, just select the value and click the hotkey ```ctrl-l```. A console.log function with an identifier of the selected value in caps and the value will be added to a new line (so as not to break existing code), and will be indented to the same number of spaces as the previous line. (refer line 8 in gif)

## Configurations

* **Include semi-colons :** Choose whether you want to include semi-colons at end of console.log function. Depending on the linting standard you use, you can choose to include semicolons. **Defaults to no semi-colons**
* **Define Identifier case :** Choose whether to retain case of selected text when creating identifier. **Defaults to creating an identifier in capital case of selected text**

## How to Use

* can be used by using the hotkeys ```ctrl-l``` (OSX) **OR** (if ctrl-l is already mapped to ```editor:select-line``` since ```cmd``` is not used in windows)
* can be used by using the hotkeys ```ctrl-alt-l``` (Linux/Windows)
* can also be found in the command palette as ```Console Log:Add```

## Languages Supported
* Javascript

## Coming soon !
* **Coffescript Support**
* **JSON.stringify support within console.log**
* **Deconsole your file :** enable quick  cleaning of your file after you are done debugging.

## Help me help you !

If you see any bugs in this package or if you have any additional features that you would like, please add an issue to this repo and I will look to resolve it.
