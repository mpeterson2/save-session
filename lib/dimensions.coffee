{$} = require 'atom'
Config = require './config'

module.exports =

  activate: ->

    if Config.restoreWindow()
      x = Config.windowX()
      y = Config.windowY()
      width = Config.windowWidth()
      height = Config.windowHeight()
      @restore x, y, width, height

    if Config.restoreFileTreeSize()
      treeSize = Config.treeSize()
      @restoreTree treeSize

    @addListeners()

  save: ->
    window = atom.getWindowDimensions()
    treeSize = $('.tree-view-resizer').width()

    Config.windowX window.x
    Config.windowY window.y
    Config.windowWidth window.width
    Config.windowHeight window.height
    Config.treeSize treeSize

  restore: (x, y, width, height, treeSize) ->
    if x > 0 and y > 0
      atom.setPosition x, y

    if width > 0 and height > 0
      atom.setSize width, height

  restoreTree: (size) ->
    if size > 0
      $(window).on 'ready', ->
        $('.tree-view-resizer').width(size)

  addListeners: ->
    $(window).on 'resize', => @save()
