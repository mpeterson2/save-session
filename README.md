# Save Session (Atom Package)

Save Session is designed to reopen your last session in [Atom](https://atom.io/).
It automatically saves all file's contents and other session information in the
background so you don't have to worry as much about losing an important file.
I liked how [Sublime Text](http://www.sublimetext.com/) does this, so I wanted
to recreate it for Atom

Here is a really high quality preview of a an unsaved file being reloaded when
Atom is closed and relaunched.

![preview](https://raw.githubusercontent.com/mpeterson2/save-session/master/preview.gif)

## What is saved

 - The project currently being worked on
 - The files currently being worked on, whether they are saved to disk or not
 - The size of the window and file tree
 - The position of the cursor

## Settings

### Save settings
These settings will control what the package saves.

 - `Buffer Save File` - The file to save your file info in so it can be restored.
 - `Restore Cursor` - Whethor or not the cursor position should be restored.
 - `Restore File Tree Size` - Whether or not the file tree size will be restored.
 - `Restore Open File Contents` - Whether or not file contents will be
 automatically restored on load. This has no effect if `Restore Open Files` is
 disabled.
 - `Restore Open Files` - Whether or not files will be reopened.
 - `Restore Project` - Whether or not the project will be reopened.
 - `Restore Window` - Whether or not the window size/positions will be saved.

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
at `<atom dir>/save-sessions-buffer.json`, but this can be changed through the
setting `Buffer Save File`.

## Contributing

Contributions are of course welcome. Feel free to submit issues if you see
anything misbehaving. Pull requests are also welcome if you want to improve or
change something.
