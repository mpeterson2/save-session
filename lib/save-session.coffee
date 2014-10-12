{$} = require 'atom'
Fs = require 'fs'
Config = require './config'
Dimensions = require './dimensions'
Files = require './files'
FirstBuffer = require './first-buffer'
Project = require './project'
SavePrompt = require './save-prompt'

module.exports =

  configDefaults:
    disableNewFileOnOpen: true
    restoreProject: true
    restoreWindow: true
    restoreFileTreeSize: true
    restoreOpenFilesPerProject: true
    restoreOpenFiles: true
    restoreOpenFileContents: true
    restoreCursor: true
    skipSavePrompt: true

  activate: (state) ->
    # Default settings that couldn't be set up top.
    if not Config.saveFolder()?
      Config.saveFolderDefault()

    # Activate everything
    Project.activate()
    Dimensions.activate()
    SavePrompt.activate()
    FirstBuffer.activate()

    # Activate files
    Fs.exists Config.saveFile(), (exists) =>
      if exists
        Fs.readFile Config.saveFile(), encoding: 'utf8', (err, str) =>
          buffers = JSON.parse(str)
          Files.activate(buffers)
      else
        Files.activate([])
