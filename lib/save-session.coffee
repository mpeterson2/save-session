{$} = require 'atom'
fs = require 'fs'
mkdirp = require 'mkdirp'
config = require './config'

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
    if not config.saveFolder()?
      config.saveFolderDefault()

    x = config.x()
    y = config.y()
    width = config.width()
    height = config.height()
    treeSize = config.treeSize()
    project = config.project()
    @defaultSavePrompt = atom.workspace.getActivePane().constructor.prototype.promptToSaveItem
    @onExit = false

    if config.restoreProject() and project? and not atom.project.getPath()?
      @restoreProject(project)

    if fs.existsSync(config.saveFile())
      buffersStr = fs.readFileSync(config.saveFile(), encoding: 'utf8')
    else
    buffers = null
    if buffersStr?
      buffers = JSON.parse(buffersStr)

    # Disable the buffer that opens by default.
    if config.disableNewBufferOnOpen() and
      (config.disableNewBufferOnOpenAlways() or
      (config.restoreOpenFiles() and
      buffers? and buffers.length > 0))
        @closeFirstBuffer()

    if config.restoreWindow() and x? and y? and width? and height?
      @restoreDimensions x, y, width, height

    if config.restoreFileTreeSize() and treeSize?
      @restoreTreeSize treeSize

    if config.restoreOpenFiles() and buffers?
      @restoreBuffers buffers

    @addListeners()

  getActivePath: ->
    for tab in $('.tab-bar').children('li')
      if $(tab).hasClass('active')
        return $(tab).children('.title').data('path')

  saveDimensions: ->
    window = atom.getWindowDimensions()
    treeSize = $('.tree-view-resizer').width()

    config.x window.x
    config.y window.y
    config.width window.width
    config.height window.height
    config.treeSize treeSize

  saveProject: ->
    config.project atom.project.getPath()

  saveBuffers: ->
    buffers = []
    activePath = @getActivePath()
    atom.workspace.eachEditor (editor) ->
      buffer = {}
      buffer.diskText = editor.buffer.cachedDiskContents
      buffer.text = editor.buffer.cachedText
      buffer.active = activePath is editor.getPath()
      buffer.path = editor.getPath()
      if editor.cursors.length > 0
        buffer.cursor = editor.getCursorBufferPosition()

      buffers.push buffer

    file = config.saveFile()
    folder = file.substring(0, file.lastIndexOf(config.pathSeparator()))
    mkdirp folder, (err) =>
      fs.writeFile(config.saveFile(), JSON.stringify(buffers))

  saveTimer: ->
    @saveProject()
    @saveBuffers()

  restoreBuffers: (buffers) ->
    for buffer in buffers
      @openBuffer(buffer)

  openBuffer: (buffer) ->
    if atom.workspace.saveSessionOpenFunc?
      promise = atom.workspace.saveSessionOpenFunc(buffer.path)
    else
      promise = atom.workspace.open(buffer.path)

    promise.then (editor) =>
      buf = editor.buffer

      if config.restoreCursor()
        editor.setCursorBufferPosition(buffer.cursor)

      # Replace the text if needed
      if config.restoreOpenFileContents() and
        buf.getText() isnt buffer.text and buf.getText() is buffer.diskText
          buf.setText(buffer.text)

  restoreDimensions: (x, y, width, height, treeSize) ->
    atom.setWindowDimensions
      'x': x
      'y': y
      'width': width
      'height': height

  restoreTreeSize: (size) ->
    $(window).on 'ready', ->
      $('.tree-view-resizer').width(size)

  restoreProject: (path) ->
    atom.project.setPath path

  disableSavePrompt: ->
    # Hack to override the promptToSaveItem method of Pane
    # There doesn't appear to be a direct way to get to the Pane object
    # with require(), unfortunately, so I have to result to this hack.
    atom.workspace.getActivePane().constructor.prototype.promptToSaveItem = (item) ->
      return true

  enableSavePrompt: ->
    atom.workspace.getActivePane().constructor.prototype.promptToSaveItem = (item) =>
      @defaultSavePrompt(item)

  enableSavePromptTemp: ->
    atom.workspace.getActivePane().constructor.prototype.promptToSaveItem = (item) =>
      save = @defaultSavePrompt item
      @disableSavePrompt()
      save

  # Sets the default open function to a function that sets the default open
  # function to the default open function... Yay!
  closeFirstBuffer: ->
    atom.workspace.constructor.prototype.saveSessionOpenFunc = atom.workspace.constructor.prototype.open
    removeFunc = (path) =>
      atom.workspace.constructor.prototype.open = atom.workspace.constructor.prototype.saveSessionOpenFunc
    atom.workspace.constructor.prototype.open = removeFunc

  addListeners: ->
    # When the window resizes
    $(window).on 'resize', => @saveDimensions()

    # When files are edited
    atom.workspace.observeTextEditors (editor) =>
      editor.onDidStopChanging =>
        @saveBuffers()

    $(window).on 'focus', (event) =>
      @saveProject()

    atom.workspace.observePanes (pane) =>
      # When closing an editor
      pane.onDidRemoveItem =>
        if not @onExit
          @saveBuffers()

      # Before closing an editor
      pane.onWillDestroyItem (event) =>
        if config.skipSavePrompt()
          @enableSavePromptTemp()

    # When changing Skip Save Prompt
    atom.config.observe 'save-session.skipSavePrompt', (val) =>
      if val
        @disableSavePrompt()
      else
        @enableSavePrompt()

    # Before exit
    $(window).on 'beforeunload', =>
      @onExit = true
