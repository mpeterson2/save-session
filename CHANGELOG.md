## 0.12.5
* Added some of JohnMurga's changes
* New windows work better now, but still aren't perfect

## 0.12.4
* Removed some debugging messages.

## 0.12.3
* Really fixed the issue from 0.12.2.
* Removed the backwards compatibility for now.

## 0.12.2
* Fixed an issue with checking for the path incorrectly.

## 0.12.1
* Fixed an issue with saving/opening projects with Atom's new project setup
thanks to smiffy6969.

## 0.12.0
* Now saves fullscreen thanks to quarterto.

## 0.11.5
* Fixed a deprecation issue.

## 0.11.4
* Something went wrong so this version was skipped.

## 0.11.3
* Fixed an thrown error in Atom 0.166.0

## 0.11.2
* Fixed an `Undefined is not a function` issue with closing the first undefined
buffer.

## 0.11.1
* Fixed an issue with opening files without a cursor position

## 0.11.0 Added a delay option
* An option was added for an additional delay for saving files after typing.

## 0.10.0 Added lot's of tests
* Some refactoring
* Added tests for everything except files

## 0.9.0 First steps to saving scroll position
* It will save scrolls when files are normally saved
* It's a little weird because of how Atom restores scrolling. Unfortunately, I
don't have much control over it at the moment.

## 0.8.10 Fix for users without an open project

## 0.8.9 Another syntax fix...

## 0.8.8 Another syntax fix

## 0.8.7 Missed an @ symbol...
* Should fix issue #20 now

## 0.8.6 Fixed an issue with Windows and saving per project
* Fixes issue #20

## 0.8.5 No changes...

## 0.8.4 Command for reloading project, Better handing of json errors
* A command called `Reopen Project` will reopen the currently active project.
This was mainly done for development/testing.
* Json errors are handled better, instead of just crashing, it will just delete
the project file and continue restoring.
* Updated readme

## 0.8.3 Added descriptions to settings

## 0.8.2 Fixed an issue with opening new windows
* Opening a new window (cmd+N) will no longer open the project you were just
working on. It will open up the undefined project.

## 0.8.1 Fixed a config issue

## 0.8.0 Files open asynchronously, removed `Disable New File On Open Always`
* Files are now opened asynchronously, which should help the initial load time
* The `Disable New File On Open Always` setting has been removed, and is now the
way `Disable New File On Open` works.

## 0.7.4 Big refactor and save on exit fix
* Moved code to separate files to clean up the main file.
* Fixed an issue where having save on exit enabled and canceling the exit after
being prompted to save would still exit Atom.

## 0.7.3 Refactor and new preview gif
* Refactored the code by moving config stuff to its own file
* Updated the preview gif to show some newer features

## 0.7.2 Fixed Windows Bug
* Fixed an issue with Windows using `\` for file separators over `/`

## 0.7.1 - Updated readme

## 0.7.0 - Restoring files per project
* Added a setting that allows files to be restored per project instead of
globally.

## 0.6.0 - Always open without default file
* Added the option to never open the file that Atom opens automatically on
startup. Default is false.

## 0.5.5 - Small fixes
* Removed option when opening files since it didn't do what I expected :(.
* Enabled save on close prompt for closing a single file at a time.

## 0.5.4 - Bug fix
* Fixed an error thrown when splitting panes.

## 0.5.3 - Bug fix
* Disabling the disable new file on open setting should work now.

## 0.5.2 - Bug fix
* Should no longer have issues with restoring unsaved files with disabling the
new file on open.

## 0.5.1 - Safer closing of the new file buffer
* There are now checks to be sure that the file is empty and has no path before
it is closed.

## 0.5.0 - Changed saving the project
* The project is now saved when the window gets focus instead of with file edits.

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
