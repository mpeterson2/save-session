{$} = require 'atom'
Config = require './config'

module.exports =

  activate: ->
    x = Config.windowX()
    y = Config.windowY()
    width = Config.windowWidth()
    height = Config.windowHeight()
    treeSize = Config.treeSize()

    if Config.restoreWindow() and x? and y? and width? and height?
      @restore x, y, width, height

    if Config.restoreFileTreeSize() and treeSize?
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
    $(window).on 'ready', ->
      $('.tree-view-resizer').width(size)

  addListeners: ->
    $(window).on 'resize', => @save()
