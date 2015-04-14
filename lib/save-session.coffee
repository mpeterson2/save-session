{$} = require 'atom-space-pen-views'
Fs = require 'fs'
Config = require './config'
Dimensions = require './dimensions'
Files = require './files'
FirstBuffer = require './first-buffer'
Project = require './project'
SavePrompt = require './save-prompt'

module.exports =

  config:
    disableNewFileOnOpen:
      type: 'boolean'
      default: true
      description: 'Auto close the default file opened by Atom'
    restoreProjects:
      type: 'boolean'
      default: true
      description: 'Restore last opened projects'
    restoreWindow:
      type: 'boolean'
      default: true
      description: 'Restore window size'
    restoreFileTreeSize:
      type: 'boolean'
      default: true
      description: 'Restore file tree size'
    restoreOpenFiles:
      type: 'boolean'
      default: true
      description: 'Restore files from the previous session'
    restoreOpenFileContents:
      type: 'boolean'
      default: true
      description: 'Restore the contents of files that were unsaved in the last session'
    restoreOpenFilesPerProject:
      type: 'boolean'
      default: true
      description: 'Restore files from previous sessions per project'
    restoreCursor:
      type: 'boolean'
      default: true
      description: 'Restore the cursor position in a file'
    restoreScrollPosition:
      type: 'boolean'
      default: true
      description: 'Restore the scroll position in a file'
    skipSavePrompt:
      type: 'boolean'
      default: true
      description: 'Disable the save on exit prompt'
    extraDelay:
      type: 'integer'
      default: 500
      description: "Add an extra delay time in ms for auto saving files after typing."
    projects:
      type: 'array'
      default: []
      description: 'An array of the projects that will be restored'
      items:
        type: 'string'
    windowX:
      type: 'integer'
      default: -1
      description: 'The x position of the window to be restored'
    windowY:
      type: 'integer'
      default: -1
      description: 'The y position of the window to be restored'
    windowWidth:
      type: 'integer'
      default: -1
      description: 'The width of the window to be restored'
    windowHeight:
      type: 'integer'
      default: -1
      description: 'The height of the window to be restored'
    treeSize:
      type: 'integer'
      default: 200
      description: 'The width of the file tree to be restored'
    dataSaveFolder:
      type: 'string'
      default: ''
      description: 'The folder in which to save project states'

  activate: (state) ->
    # Default settings that couldn't be set up top.
    if not Config.saveFolder()?
      Config.saveFolderDefault()

    (localStorage.sessionRestore = true) if not localStorage.sessionRestore?
    sessionRestore = localStorage.sessionRestore

    # Activate everything
    Project.activate()
    Dimensions.activate()
    SavePrompt.activate()
    FirstBuffer.activate()
    Files.activate()

    @addListener()

  addListener: ->
    $(window).on 'focus', (event) =>
      localStorage.sessionRestore = false


  deactivate: ->
    localStorage.sessionRestore = true
