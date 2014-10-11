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
    disableNewFileOnOpenAlways: true
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

    # Activate Everything
    Project.activate()
    Dimensions.activate()
    SavePrompt.activate()

    if Fs.existsSync(Config.saveFile())
      buffersStr = Fs.readFileSync(Config.saveFile(), encoding: 'utf8')
    else
      buffers = null

    if buffersStr?
      buffers = JSON.parse(buffersStr)
      FirstBuffer.activate(buffers)
      Files.activate(buffers)
