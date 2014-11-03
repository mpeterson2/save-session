# Save Session (Atom Package) [![Build Status](https://travis-ci.org/mpeterson2/save-session.svg?branch=master)](https://travis-ci.org/mpeterson2/save-session)

Save Session is designed to reopen your last session in [Atom](https://atom.io/).
It automatically saves all file's contents and other session information in the
background so you don't have to worry as much about losing an important file.
I liked how [Sublime Text](http://www.sublimetext.com/) does this, so I wanted
to recreate it for Atom

![preview](https://raw.githubusercontent.com/mpeterson2/save-session/master/preview.gif)

## What is saved

 - The project currently being worked on
 - The files currently being worked on, whether they are saved to disk or not
 - The size of the window and file tree
 - The position of the cursor

## Settings

If you haven't downloaded the package yet, this is what you can customize.

### User settings

 - `Disable New File On Open` - Whether or not to auto close the new file auto
 opened by Atom.
 - `Data Save Folder` - The root folder to save the session data in.
 - `Restore Cursor` - Whether or not the cursor position should be restored.
 - `Restore File Tree Size` - Whether or not the file tree size will be restored.
 - `Restore Open Files Per Project` - If enabled, only files from previous sessions
 with the save project will be restored. Otherwise, files from your last session
 will be restored.
 - `Restore Open File Contents` - Whether or not file contents will be
 automatically restored on load. This has no effect if `Restore Open Files` is
 disabled.
 - `Restore Open Files` - Whether or not files will be reopened.
 - `Restore Project` - Whether or not the project will be reopened.
 - `Restore Window` - Whether or not the window size/positions will be saved.
 - `Skip Save Prompt` - This will disable the save on exit prompt.
 - `Extra Delay` - Adds an extra delay for saving files when typing.
 - `Restore Scroll Position` - **Experimental** Saves the scroll position of files.

### Other settings
These settings are used by the package to restore data. You can change them, but
they will all be set by the package when a related event happens.

 - `Height` - The height of the editor
 - `Width` - The width of the editor
 - `X` - The x position of the editor
 - `Y` - The y position of the editor

### Commands

There is currently only one command: `Save Session: Reopen Project`. This is
mostly for me, or other developers. All it does is reopen the current project.
This allows you to edit a package and reload it without exiting out of your
current window or loosing the project in the new window.

## How it works

Save Session saves your data in two different ways. The first, is through Atom's
settings API. Simple things like window dimensions are saved here, but nothing
complicated. The second is on your file system. Things like files info is stored
in a folder at `<atom package dir>/save-session/<project path>/projects.json` by
default.

## Contributing

Feel free to submit issues if you see anything misbehaving. The more information
you can give me about your issue the better. Things like operating system, Atom
version, Save Session version, your Save Session config, other installed
packages, and any error messages in the console that mention Save Session are
helpful.

Pull requests are also welcome if you want to improve or change something.
