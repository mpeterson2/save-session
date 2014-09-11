# save-session package

Save Session is designed to reopen your last session. It automatically saves all
your file's contents in the background so you don't have to worry as much about
losing an important file.

# What is saved

 - The project currently being worked on
 - The files currently being worked on, whether they are saved or not
 - The size of the window and file tree

# How it works

Save Session uses Atom's settings to save all of its data. If you look at your
settings for Save Session, you will see all the data saved there.

## Project and files

The project and files are saved on a timer. The timer is currently set at five
seconds. This is done for projects because there is no listener for project
changes as far as I am aware.

I didn't know about this when I started this, but I just found out that
[onDidStopChanging](https://atom.io/docs/api/v0.126.0/Editor#instance-onDidStopChanging),
a listener for editors, exists. At some point, file should be saved using this.

## Resizing

The window dimensions use the window's `onresize` listener, so that will be
saved when you resize. The file tree size is saved along with this.

![A screenshot of your spankin' package](https://f.cloud.github.com/assets/69169/2290250/c35d867a-a017-11e3-86be-cd7c5bf3ff9b.gif)
