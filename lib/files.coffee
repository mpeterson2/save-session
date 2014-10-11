{$} = require 'atom'
Fs = require 'fs'
mkdirp = require 'mkdirp'
Config = require './config'

module.exports =

  activate: (buffers) ->
    if Config.restoreOpenFiles() and buffers?
      @restore buffers

    @addListeners()

  save: ->
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

    file = Config.saveFile()
    folder = file.substring(0, file.lastIndexOf(Config.pathSeparator()))
    mkdirp folder, (err) =>
      Fs.writeFile(Config.saveFile(), JSON.stringify(buffers))

  restore: (buffers) ->
    for buffer in buffers
      @open(buffer)

  open: (buffer) ->
    if atom.workspace.saveSessionOpenFunc?
      promise = atom.workspace.saveSessionOpenFunc(buffer.path)
    else
      promise = atom.workspace.open(buffer.path)

    promise.then (editor) =>
      buf = editor.buffer

      if Config.restoreCursor()
        editor.setCursorBufferPosition(buffer.cursor)

      # Replace the text if needed
      if Config.restoreOpenFileContents() and
        buf.getText() isnt buffer.text and buf.getText() is buffer.diskText
          buf.setText(buffer.text)

  getActivePath: ->
    return $('.tab-bar').children('li.active').data('path')

  addListeners: ->
    # When files are edited
    atom.workspace.observeTextEditors (editor) =>
      editor.onDidStopChanging =>
        @save()

    # When closing an editor
    atom.workspace.observePanes (pane) =>
      pane.onDidRemoveItem =>
        if not @onExit
          @save()

    $(window).on 'beforeunload', =>
      @onExit = true
