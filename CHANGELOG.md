## 0.1.0 - First Release
* can generate an empty console.log function
* if a value is selected, generates a console log of that value, with a string identifier on next line.

## 0.2.0 - Fixed documentation
* More thorough documentation to make app easier to use

## 0.3.1 - Fixed Cursor Positioning
* he cursor is placed between log and the first bracket, now the cursor was placed within the brackets.

## 0.6.2 - Added include semi-colons configuration Option
* Choose whether you want to include semi-colons at end of console.log function. Depending on the linting standard you use, you can choose to include semicolons. **Defaults to no semi-colons**

## 0.7.0 - Added identifier Case configuration Option.
* Choose whether to retain case of selected text when creating identifier. **Defaults to creating an identifier in capital case of selected text**

## 0.8.0 - Added console.log option with JSON.stringify
* Can generate a console.log function with a JSON.stringify method using ```ctrl-o``` or ```ctrl-alt-o```

## 0.9.1 - Smart detection of objects
* If selected text is the variable being defined to create an object, places console.log after object has been created to prevent any code breaks.

## 0.10.0 - Added Deconsoler
* ```ctrl-shift-D``` will clean out all the lines that contain console.log statements in the file.
