# Save Session (Atom Package) [![Build Status](https://travis-ci.org/mpeterson2/save-session.svg?branch=master)](https://travis-ci.org/mpeterson2/save-session)

## Project Status: Undeprecated

Since not all of Save Session's functionality has been added into Atom's core,
Save Session is now undeprecated and has been modified to work with Atom 0.193.0.
All that Save Session does now is manage unsaved files.

Check out [this issue](https://github.com/atom/atom/issues/1603#issuecomment-93599126)
for the status of this functionality being added to Atom core.

## What is Save Session

Save Session is designed to reopen your last session in [Atom](https://atom.io/).
It automatically saves all file's contents in the background so you don't have
to worry as much about losing an important file. I liked how
[Sublime Text](http://www.sublimetext.com/) does this, so I wanted to recreate
it for Atom.

![preview](https://raw.githubusercontent.com/mpeterson2/save-session/master/preview.gif)

## What is saved

 - The project currently being worked on
 - The files currently being worked on, whether they are saved to disk or not
 - The size of the window and file tree
 - The position of the cursor

## Settings

 - `Data Save Folder` - The root folder to save the session data in.
 - `Restore Open File Contents` - Whether or not file contents will be
 automatically restored on load.
 - `Skip Save Prompt` - This will disable the save on exit prompt.
 - `Extra Delay` - Adds an extra delay for saving files when typing.

## How it works

File info is stored in a folder at
`<atom package dir>/save-session/<project path>/projects.json` by default and
gets reloaded at when you reopen the same project again.

## Contributing

Feel free to submit issues if you see anything misbehaving. The more information
you can give me about your issue the better. Things like operating system, Atom
version, Save Session version, your Save Session config, other installed
packages, and any error messages in the console that mention Save Session are
helpful.

Pull requests are also welcome if you want to improve or change something.
