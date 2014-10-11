{$} = require 'atom'
Config = require './config'

module.exports =

  activate: ->
    x = Config.x()
    y = Config.y()
    width = Config.width()
    height = Config.height()
    treeSize = Config.treeSize()

    if Config.restoreWindow() and x? and y? and width? and height?
      @restore x, y, width, height

    if Config.restoreFileTreeSize() and treeSize?
      @restoreTree treeSize

    @addListeners()

  save: ->
    window = atom.getWindowDimensions()
    treeSize = $('.tree-view-resizer').width()

    Config.x window.x
    Config.y window.y
    Config.width window.width
    Config.height window.height
    Config.treeSize treeSize

  restore: (x, y, width, height, treeSize) ->
    atom.setWindowDimensions
      'x': x
      'y': y
      'width': width
      'height': height

  restoreTree: (size) ->
    $(window).on 'ready', ->
      $('.tree-view-resizer').width(size)

  addListeners: ->
    $(window).on 'resize', => @save()
