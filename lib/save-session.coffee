{$} = require 'atom'
fs = require 'fs'

module.exports =

  activate: (state) ->
    @bufferSaveFile = atom.config.configDirPath + '/save-session-buffer.json'
    x = atom.config.get('save-session.x')
    y = atom.config.get('save-session.y')
    width = atom.config.get('save-session.width')
    height = atom.config.get('save-session.height')
    treeSize = atom.config.get('save-session.tree size')
    project = atom.config.get('save-session.project')

    if fs.existsSync(@bufferSaveFile)
      buffersStr = fs.readFileSync(@bufferSaveFile, encoding: 'utf8')
    buffers = null
    if buffersStr?
      buffers = JSON.parse(buffersStr)

    if x? and y? and width? and height?
      @restoreDimensions(x, y, width, height)

    if treeSize?
      @restoreTreeSize(treeSize)

    if buffers?
      @restoreBuffers(buffers)

    if project? and not atom.project.getPath()?
      @restoreProject(project)

    @addListeners()

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
      buffer.active = activePath == editor.getPath()
      buffer.path = editor.getPath()

      buffers.push buffer

    fs.writeFile(@bufferSaveFile, JSON.stringify(buffers))

  saveTimer: ->
    @saveProject()
    @saveBuffers()

  restoreBuffers: (buffers) ->
    for buffer in buffers
      @openBuffer(buffer)


  openBuffer: (buffer) ->
    # activatePane does not work yet :(
      editor = atom.workspace.open(buffer.path, activatePane: buffer.active)
        .then (editor) ->
          buf = editor.buffer

          # Replace the text if needed
          if buf.getText() != buffer.text and buf.getText() == buffer.diskText
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
