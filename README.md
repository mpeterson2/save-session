# Save Session (Atom Package)

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

### User settings

 - `Disable New File On Open` - Whether or not to auto close the new file auto
 opened by Atom if other files will be restored.
 - `Disable New File On Open Always` - Will never show the new file that Atom
 opens, even if other files are not going to be restored.
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

### Other settings
These settings are used by the package to restore data. You can change them, but
they will all be set by the package when a related event happens.

 - `Height` - The height of the editor
 - `Width` - The width of the editor
 - `X` - The x position of the editor
 - `Y` - The y position of the editor

## How it works

Except for file data, Save Session uses Atom's settings to save its data. If you
look at your settings for Save Session, you will see it all there.

Files are saved in as json on a file. By default, this file is stored
at `<atom package dir>/save-session/<projectPath>/projects.json`, but this can
be changed through the setting `Data Save Folder`.

## Contributing

Contributions are of course welcome. Feel free to submit issues if you see
anything misbehaving. Pull requests are also welcome if you want to improve or
change something.
