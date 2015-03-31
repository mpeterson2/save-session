{$} = require 'atom'
Fs = require 'fs'
mkdirp = require 'mkdirp'
Config = require './config'

module.exports =

  activate: (buffers) ->
    Fs.exists Config.saveFile(), (exists) =>
      if exists
        Fs.readFile Config.saveFile(), encoding: 'utf8', (err, str) =>
          buffers = JSON.parse(str)
          if Config.restoreOpenFiles()
            @restore buffers

    @addListeners()

  save: ->
    localStorage.sessionRestore = false
    buffers = []
    activePath = @getActivePath()
    atom.workspace.eachEditor (editor) ->
      buffer = {}
      buffer.diskText = editor.buffer.cachedDiskContents
      buffer.text = editor.buffer.cachedText
      buffer.active = activePath is editor.getPath()
      buffer.path = editor.getPath()
      buffer.scroll = (($('.list-inline.tab-bar.inset-panel').height()) +
        editor.getScrollTop()) / editor.getScrollHeight() * editor.getLineCount()
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
    if buffer.cursor?
      row = buffer.cursor.row
      col = buffer.cursor.column
    else
      row = 0
      col = 0

    if atom.workspace.saveSessionOpenFunc?
      promise = atom.workspace.saveSessionOpenFunc(buffer.path, initialLine: row, initialColumn: col)
    else
      promise = atom.workspace.open(buffer.path, initialLine: row, initialColumn: col)

    promise.then (editor) =>
      buf = editor.buffer

      #if Config.restoreCursor()
      #  editor.setCursorBufferPosition(buffer.cursor)

      if buffer.scroll? and Config.restoreScrollPos()
        scroll = buffer.scroll | 0
        editor.scrollToBufferPosition([scroll], center: true)

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
        setTimeout (=>@save()), Config.extraDelay()

      editor.onDidDestroy =>
        @save()

      #editor.on 'scroll-top-changed', => @SaveScrollPos()
