{$} = require 'atom'

module.exports =

  activate: (state) ->
    x = atom.config.get('save-session.x')
    y = atom.config.get('save-session.y')
    width = atom.config.get('save-session.width')
    height = atom.config.get('save-session.height')
    treeSize = atom.config.get('save-session.treeSize')
    project = atom.config.get('save-session.project')
    buffersStr = atom.config.get('save-session.buffers')
    buffers = JSON.parse(buffersStr)

    atom.workspaceView.command 'save-session:save', => @saveBuffers()

    if x? and y? and width? and height?
      @restoreDimensions(x, y, width, height)

    if treeSize?
      @restoreTreeSize(treeSize)

    if project?
      @restoreProject(project)

    if buffers?
      @restoreBuffers(buffers)

    @addListeners()

  saveDimensions: ->
    window = atom.getWindowDimensions()
    treeSize = $('.tree-view-resizer').width()

    atom.config.set('save-session.x', window.x)
    atom.config.set('save-session.y', window.y)
    atom.config.set('save-session.width', window.width)
    atom.config.set('save-session.height', window.height)
    atom.config.set('save-session.tree-size', treeSize)
    atom.config.set('save-session.project', atom.project.getPath())

  saveBuffers: ->
    buffers = []
    atom.workspace.eachEditor (editor) ->
      buffer = {}
      buffer.diskText = editor.buffer.cachedDiskContents
      buffer.text = editor.buffer.cachedText
      buffer.active = $(editor).hasClass('active')
      buffer.path = editor.getPath()

      buffers.push buffer

    atom.config.set('save-session.buffers', JSON.stringify(buffers))

  restoreBuffers: (buffers) ->
    panes = atom.workspace.getPaneItems()
    console.log(buffers)

    for buffer in buffers
      @openBuffer(buffer)

  openBuffer: (buffer) ->
    console.log(buffer)
    atom.workspace.open(buffer.path)
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
    if path?
      atom.project.setPath(path)

  addListeners: ->
    $(window).on 'resize', => @saveDimensions()
    $('.tree-view.resizer').on 'resize', => @saveTreeSize()
