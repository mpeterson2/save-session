{$} = require 'atom'
fs = require 'fs'

module.exports =

  configDefaults:
    restoreProject: true
    restoreWindow: true
    restoreFileTreeSize: true
    restoreOpenFiles: true
    restoreOpenFileContents: true
    restoreCursor: true
    bufferSaveFile: atom.config.configDirPath + '/save-session-buffer.json'

  activate: (state) ->
    x = atom.config.get('save-session.x')
    y = atom.config.get('save-session.y')
    width = atom.config.get('save-session.width')
    height = atom.config.get('save-session.height')
    treeSize = atom.config.get('save-session.tree size')
    project = atom.config.get('save-session.project')

    if fs.existsSync(@getBufferSaveFile())
      buffersStr = fs.readFileSync(@getBufferSaveFile(), encoding: 'utf8')
    buffers = null
    if buffersStr?
      buffers = JSON.parse(buffersStr)

    if @getShouldRestoreWindow() and x? and y? and width? and height?
      @restoreDimensions(x, y, width, height)

    if @getShouldRestoreFileTreeSize() and treeSize?
      @restoreTreeSize(treeSize)

    if @getShouldRestoreOpenFiles() and buffers?
      @restoreBuffers(buffers)

    if @getShouldRestoreProject() and project? and not atom.project.getPath()?
      @restoreProject(project)

    @addListeners()

  getBufferSaveFile: ->
    atom.config.get 'save-session.bufferSaveFile'

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
      buffer.cursor = editor.getCursorBufferPosition()

      buffers.push buffer

    fs.writeFile(@getBufferSaveFile(), JSON.stringify(buffers))

  saveTimer: ->
    @saveProject()
    @saveBuffers()

  restoreBuffers: (buffers) ->
    for buffer in buffers
      @openBuffer(buffer)


  openBuffer: (buffer) ->
    # activatePane does not work yet :(
      editor = atom.workspace.open(buffer.path, activatePane: buffer.active)
      .then (editor) =>
        buf = editor.buffer

        if @getShouldRestoreCursor()
          editor.setCursorBufferPosition(buffer.cursor)

        # Replace the text if needed
        if @getShouldRestoreOpenFileContents() and
          buf.getText() is not buffer.text and buf.getText() is buffer.diskText
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

  addListeners: ->
    $(window).on 'resize', => @saveDimensions()

    atom.workspace.observeTextEditors (editor) =>
      editor.onDidStopChanging =>
        @saveProject()
        @saveBuffers()
