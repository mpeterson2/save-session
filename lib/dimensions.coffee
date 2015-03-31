{$} = require 'atom'
Config = require './config'

module.exports =

  activate: ->

    if Config.restoreWindow()
      x = Config.windowX()
      y = Config.windowY()
      width = Config.windowWidth()
      height = Config.windowHeight()
      fullScreen = Config.fullScreen()
      @restore x, y, width, height, fullScreen

    if Config.restoreFileTreeSize()
      treeSize = Config.treeSize()
      @restoreTree treeSize

    @addListeners()

  save: ->
    localStorage.sessionRestore = false
    window = atom.getWindowDimensions()
    treeSize = $('.tree-view-resizer').width()
    fullScreen = atom.isFullScreen()

    Config.windowX window.x
    Config.windowY window.y
    Config.windowWidth window.width
    Config.windowHeight window.height
    Config.treeSize treeSize
    Config.fullScreen fullScreen

  restore: (x, y, width, height, fullScreen) ->
    if x > 0 and y > 0
      atom.setPosition x, y

    if width > 0 and height > 0
      atom.setSize width, height

    atom.setFullScreen fullScreen

  restoreTree: (size) ->
    if size > 0
      $(window).on 'ready', ->
        $('.tree-view-resizer').width(size)

  addListeners: ->
    $(window).on 'resize', => @save()
