{$} = require 'atom-space-pen-views'
Fs = require 'fs'
Mkdirp = require 'mkdirp'
Config = require './config'

module.exports =

  activate: (buffers) ->
    saveFilePath = Config.saveFile()

    Fs.exists saveFilePath, (exists) =>
      if exists
        Fs.readFile saveFilePath, encoding: 'utf8', (err, str) =>
          buffers = JSON.parse(str)
          if Config.restoreOpenFileContents()
            @restore buffers

    @addListeners()

  save: ->
    buffers = []

    atom.workspace.getTextEditors().map (editor) =>
      buffer = {}
      if editor.getBuffer().isModified()
        buffer.text = editor.getBuffer().cachedText
        buffer.diskText = Config.hashMyStr(editor.getBuffer().cachedDiskContents)
      buffer.path = editor.getPath()

      buffers.push buffer

    file = Config.saveFile()
    folder = file.substring(0, file.lastIndexOf(Config.pathSeparator()))
    Mkdirp folder, (err) =>
     Fs.writeFile(file, JSON.stringify(buffers))


  restore: (buffers) ->
    for buffer in buffers
      @restoreText(buffer)


  restoreText: (buffer) ->
    if buffer.path == undefined
      editors = atom.workspace.getTextEditors().filter (editor) =>
        editor.buffer.file == null and editor.buffer.cachedText == ''

      if editors.length > 0
        buf = editors[0].getBuffer()

    else
      editors = atom.workspace.getTextEditors().filter (editor) =>
        editor.buffer.file?.path == buffer.path

      if editors.length > 0
        buf = editors[0].getBuffer()

    # Replace the text if needed
    if Config.restoreOpenFileContents() and buffer.text? and buf? and
      buf.getText() isnt buffer.text and Config.hashMyStr(buf.getText()) is buffer.diskText
        buf.setText(buffer.text)

  addListeners: ->
    # When files are edited
    atom.workspace.observeTextEditors (editor) =>
      editor.onDidStopChanging =>
        setTimeout (=>@save()), Config.extraDelay()
      editor.onDidSave =>
        @save()

    window.onbeforeunload = () =>
      @save()
