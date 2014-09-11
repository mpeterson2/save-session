{$} = require 'atom'

module.exports =

  activate: (state) ->
    console.log(state)
    x = state.x
    y = state.y
    width = state.width
    height = state.height
    treeSize = state.treeSize

    @restoreBuffers();
    $(window).on 'ready', =>
      @restoreDimensions(x, y, width, height, treeSize)

    atom.workspaceView.command 'save-session:add-listeners', => @addListeners()
    atom.workspaceView.command 'save-session:save-buffers', => @saveBuffers()
    atom.workspaceView.command 'save-session:save-dimensions', => @saveDimensions()
    atom.workspaceView.command 'save-session:restore-dimensions', => @restoreDimensions()
    atom.workspaceView.command 'save-session:save-session', => @saveSession()

  serialize: ->
    window = atom.getWindowDimensions()
    treeSize = $('.tree-view-resizer').width()

    ret = {
      'x': window.x,
      'y': window.y,
      'width': window.width,
      'height': window.height,
      'treeSize': treeSize
    }
    console.log(ret)
    ret

  saveTabs: ->
    #atom.config.set('save-session.tabs')
    tabs = ''
    atom.workspace.eachEditor((editor) ->
      if editor.getPath?
        tabs += '&&' + editor.getPath()
    )

    selectedTab = 0

    atom.workspace.eachEditor((editor) ->
      if(not editor.hasClass('active'))
        selectedTab++
    )

    console.log(tabs)
    console.log(selectedTab)

  saveBuffers: ->
    texts = []
    atom.workspace.eachEditor((editor) ->
      if editor.getPath()?
        texts.push editor.buffer.cachedText
    )

  saveDimensions: ->
    window = atom.getWindowDimensions()
    treeSize = $('.tree-view-resizer').width()
    @x = window.x
    @y = window.y
    @width = window.width
    @height = window.height

  restoreBuffers: ->
    console.log 'Restore buffers'

  restoreDimensions: (x, y, width, height, treeSize) ->
    atom.setWindowDimensions
      'x': x
      'y': y
      'width': width
      'height': height
    $('.tree-view-resizer').width(treeSize)

  saveSession: ->
    @saveBuffers()
    @saveDimensions()

  addListeners: ->
    $(window).on 'resize', => @saveDimensions()
