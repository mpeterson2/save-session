## 0.4.0 - Removing the new file buffer
* The new file is automatically closed when Atom starts if there were previous
files open.

## 0.3.2 - Bug fixes
* Fixed a bug where closing a buffer was not saved.

## 0.3.1 - Bug fixes
* Fixed a bug where you had to reopen an Atom window for the Skip Save Prompt setting
to actually save.

## 0.3.0 - Disabled save on exit
* Skip Save Prompt will disable the save on exit prompt
* Fixed some bugs

## 0.2.4 - Minor edits
* Just readme edits and deleting some unused stuff.

## 0.2.3 - Cursor Position
* The cursor position is now saved on edits

## 0.2.2 - More settings
* Users can specify what they want to save now.

## 0.2.1 - Settings
* Users can specify their buffer save file.

## 0.2.0 - Buffers are saved a file.
* Buffers are saved to a file instead of settings so users can open their config
files without breaking everything.

## 0.1.2 - Fixed Readme

## 0.1.1 - Published Package

## 0.1.0 - First Release
* The project is reopened if there is no project already open.
* Dimensions are reloaded
* Open files are reloaded if the project is reloaded.
  * Files will be opened with the contents they had when they were closed
  * This includes unsaved files
