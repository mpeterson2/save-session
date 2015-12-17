# Save Session (Atom Package) [![Build Status](https://travis-ci.org/mpeterson2/save-session.svg?branch=master)](https://travis-ci.org/mpeterson2/save-session)

## Project Status: Deprecated

All of Save Session's functionality is now included in Atom core.

Check out [this pull request](https://github.com/atom/atom/pull/9968) for more
info.

## What is Save Session

Save Session is designed to reopen your last session in [Atom](https://atom.io/).
It automatically saves all file's contents in the background so you don't have
to worry as much about losing an important file. I liked how
[Sublime Text](http://www.sublimetext.com/) does this, so I wanted to recreate
it for Atom.

![preview](https://raw.githubusercontent.com/mpeterson2/save-session/master/preview.gif)

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
