{$} = require 'atom'
fs = require 'fs'
mkdirp = require 'mkdirp'

module.exports =

  configDefaults:
    disableNewFileOnOpen: true
    disableNewFileOnOpenAlways: false
    restoreProject: true
    restoreWindow: true
    restoreFileTreeSize: true
    restoreOpenFilesPerProject: true
    restoreOpenFiles: true
    restoreOpenFileContents: true
    restoreCursor: true
    skipSavePrompt: true
    dataSaveFolder: atom.packages.getPackageDirPaths() + '/save-session/projects'

  activate: (state) ->
    x = atom.config.get('save-session.x')
    y = atom.config.get('save-session.y')
    width = atom.config.get('save-session.width')
    height = atom.config.get('save-session.height')
    treeSize = atom.config.get('save-session.tree size')
    project = atom.config.get('save-session.project')
    @defaultSavePrompt = atom.workspace.getActivePane().constructor.prototype.promptToSaveItem
    @onExit = false

    if @getShouldRestoreProject() and project? and not atom.project.getPath()?
      @restoreProject(project)

    if fs.existsSync(@getSaveFile())
      buffersStr = fs.readFileSync(@getSaveFile(), encoding: 'utf8')
    else
    buffers = null
    if buffersStr?
      buffers = JSON.parse(buffersStr)

    # Disable the buffer that opens by default.
    if @getShouldDisableNewBufferOnOpen() and
      (@getShouldDisableNewBufferOnOpenAlways() or
      (@getShouldRestoreOpenFiles() and
      buffers? and buffers.length > 0))
        @closeFirstBuffer()

    if @getShouldRestoreWindow() and x? and y? and width? and height?
      @restoreDimensions(x, y, width, height)

    if @getShouldRestoreFileTreeSize() and treeSize?
      @restoreTreeSize(treeSize)

    if @getShouldRestoreOpenFiles() and buffers?
      @restoreBuffers(buffers)

    @addListeners()

  getShouldDisableNewBufferOnOpen: ->
    atom.config.get 'save-session.disableNewFileOnOpen'

  getShouldDisableNewBufferOnOpenAlways: ->
    atom.config.get 'save-session.disableNewFileOnOpenAlways'

  getSaveFile: ->
    folder = @getSaveFolder()
    if @getShouldRestoreOpenFilesPerProject()
      return folder + '/' + atom.project.path + '/' + 'project.json'
    else
      return folder + '/undefined/project.json'

  getShouldRestoreOpenFilesPerProject: ->
    atom.config.get 'save-session.restoreOpenFilesPerProject'

  getSaveFolder: ->
    atom.config.get 'save-session.dataSaveFolder'

  getShouldRestoreProject: ->
    atom.config.get 'save-session.restoreProject'

  getShouldRestoreWindow: ->
    atom.config.get 'save-session.restoreWindow'

  getShouldRestoreFileTreeSize: ->
    atom.config.get 'save-session.restoreFileTreeSize'

  getShouldRestoreOpenFiles: ->
    atom.config.get 'save-session.restoreOpenFiles'

  getShouldRestoreOpenFileContents: ->
    atom.config.get 'save-session.restoreOpenFileContents'

  getShouldRestoreCursor: ->
    atom.config.get 'save-session.restoreCursor'

  getActivePath: ->
    for tab in $('.tab-bar').children('li')
      if $(tab).hasClass('active')
        return $(tab).children('.title').data('path')

  getShouldSkipSavePrompt: ->
    atom.config.get 'save-session.skipSavePrompt'

  saveDimensions: ->
    window = atom.getWindowDimensions()
    treeSize = $('.tree-view-resizer').width()

    atom.config.set('save-session.x', window.x)
    atom.config.set('save-session.y', window.y)
    atom.config.set('save-session.width', window.width)
    atom.config.set('save-session.height', window.height)
    atom.config.set('save-session.tree size', treeSize)

  saveProject: ->
    atom.config.set('save-session.project', atom.project.getPath())

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

    file = @getSaveFile()
    folder = file.substring(0, file.lastIndexOf('/'))
    mkdirp folder, (err) =>
      console.log folder
      fs.writeFile(@getSaveFile(), JSON.stringify(buffers))

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

      if @getShouldRestoreCursor()
        editor.setCursorBufferPosition(buffer.cursor)

      # Replace the text if needed
      if @getShouldRestoreOpenFileContents() and
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
    atom.project.setPath(path)

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
      save = @defaultSavePrompt(item)
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
        if @getShouldSkipSavePrompt()
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
