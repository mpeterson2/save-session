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

## How it works

Save Session uses Atom's settings to save all of its data. If you look at your
settings for Save Session, you will see all the data saved there.

## Contributing

Contributions are of course welcome. Feel free to submit issues if you see
anything misbehaving. Pull requests are also welcome if you want to improve or
change something.
