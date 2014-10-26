Dimensions = require '../lib/dimensions'
{$} = require 'atom'
Config = require '../lib/config'

describe 'activate tests', ->
  beforeEach ->
    @x = Math.random()
    @y = Math.random()
    @width = Math.random()
    @height = Math.random()
    @treeSize = Math.random()
    spyOn(Config, 'windowX').andReturn(@x)
    spyOn(Config, 'windowY').andReturn(@y)
    spyOn(Config, 'windowWidth').andReturn(@width)
    spyOn(Config, 'windowHeight').andReturn(@height)
    spyOn(Config, 'treeSize').andReturn(@treeSize)
    spyOn(Dimensions, 'restoreTree')
    spyOn(Dimensions, 'restore')
    spyOn(Dimensions, 'addListeners')

  it 'Config.restoreWindow is true and .restoreFileTreeSize is false', ->
    spyOn(Config, 'restoreWindow').andReturn(true)
    spyOn(Config, 'restoreFileTreeSize').andReturn(false)

    Dimensions.activate()

    expect(Config.windowX).toHaveBeenCalled()
    expect(Config.windowY).toHaveBeenCalled()
    expect(Config.windowWidth).toHaveBeenCalled()
    expect(Config.windowHeight).toHaveBeenCalled()
    expect(Config.treeSize).not.toHaveBeenCalled()
    expect(Config.restoreWindow).toHaveBeenCalled()
    expect(Dimensions.restore).toHaveBeenCalled()
    expect(Dimensions.restoreTree).not.toHaveBeenCalled()
    expect(Dimensions.addListeners).toHaveBeenCalled()

  it 'Config.restoreWindow and .restoreFileTreeSize is false', ->
    spyOn(Config, 'restoreWindow').andReturn(false)
    spyOn(Config, 'restoreFileTreeSize').andReturn(false)

    Dimensions.activate()

    expect(Config.windowX).not.toHaveBeenCalled()
    expect(Config.windowY).not.toHaveBeenCalled()
    expect(Config.windowWidth).not.toHaveBeenCalled()
    expect(Config.windowHeight).not.toHaveBeenCalled()
    expect(Config.treeSize).not.toHaveBeenCalled()
    expect(Config.restoreWindow).toHaveBeenCalled()
    expect(Dimensions.restore).not.toHaveBeenCalled()
    expect(Dimensions.restoreTree).not.toHaveBeenCalled()
    expect(Dimensions.addListeners).toHaveBeenCalled()

  it 'Config.restoreWindow is true and Config.restoreFileTreeSize is true', ->
    spyOn(Config, 'restoreWindow').andReturn(true)
    spyOn(Config, 'restoreFileTreeSize').andReturn(true)

    Dimensions.activate()

    expect(Config.windowX).toHaveBeenCalled()
    expect(Config.windowY).toHaveBeenCalled()
    expect(Config.windowWidth).toHaveBeenCalled()
    expect(Config.windowHeight).toHaveBeenCalled()
    expect(Config.treeSize).toHaveBeenCalled()
    expect(Config.restoreWindow).toHaveBeenCalled()
    expect(Dimensions.restore).toHaveBeenCalled()
    expect(Dimensions.restoreTree).toHaveBeenCalled()
    expect(Dimensions.addListeners).toHaveBeenCalled()

  it 'Config.restoreWindow is false and Config.restoreFileTreeSize is true', ->
      spyOn(Config, 'restoreWindow').andReturn(false)
      spyOn(Config, 'restoreFileTreeSize').andReturn(true)

      Dimensions.activate()

      expect(Config.windowX).not.toHaveBeenCalled()
      expect(Config.windowY).not.toHaveBeenCalled()
      expect(Config.windowWidth).not.toHaveBeenCalled()
      expect(Config.windowHeight).not.toHaveBeenCalled()
      expect(Config.treeSize).toHaveBeenCalled()
      expect(Config.restoreWindow).toHaveBeenCalled()
      expect(Dimensions.restore).not.toHaveBeenCalled()
      expect(Dimensions.restoreTree).toHaveBeenCalled()
      expect(Dimensions.addListeners).toHaveBeenCalled()


describe 'save tests', ->
  it 'saves correctly', ->
    dim =
      x: Math.random(), y: Math.random(),
      width: Math.random(), height: Math.random()
    treeSize = Math.random()
    spyOn(atom, 'getWindowDimensions').andReturn(dim)
    spyOn(Config, 'windowX')
    spyOn(Config, 'windowY')
    spyOn(Config, 'windowWidth')
    spyOn(Config, 'windowHeight')
    spyOn(Config, 'treeSize')
    spyOn($.fn, 'width').andReturn(treeSize)

    Dimensions.save()

    expect(atom.getWindowDimensions).toHaveBeenCalled()
    expect(Config.windowX).toHaveBeenCalledWith(dim.x)
    expect(Config.windowY).toHaveBeenCalledWith(dim.y)
    expect(Config.windowWidth).toHaveBeenCalledWith(dim.width)
    expect(Config.windowHeight).toHaveBeenCalledWith(dim.height)
    expect(Config.treeSize).toHaveBeenCalledWith(treeSize)


describe 'restore tests', ->
  beforeEach ->
    spyOn(atom, 'setPosition')
    spyOn(atom, 'setSize')

  it 'has valid params for x, y, width, height', ->
    x = Math.random() + 1
    y = Math.random() + 1
    width = Math.random() + 1
    height = Math.random() + 1

    Dimensions.restore(x, y, width, height)

    expect(atom.setPosition).toHaveBeenCalledWith(x, y)
    expect(atom.setSize).toHaveBeenCalledWith(width, height)

  it 'has valid params for x, y; invalid for width, height', ->
    x = Math.random() + 1
    y = Math.random() + 1

    Dimensions.restore(x, y, -1, -1)

    expect(atom.setPosition).toHaveBeenCalledWith(x, y)
    expect(atom.setSize).not.toHaveBeenCalled()

  it 'has invalid params for x, y; valid for width, height', ->
    width = Math.random() + 1
    height = Math.random() + 1

    Dimensions.restore(-1, -1, width, height)

    expect(atom.setPosition).not.toHaveBeenCalled()
    expect(atom.setSize).toHaveBeenCalledWith(width, height)

  it 'has invalid params for x, y, width, height', ->
    Dimensions.restore(-1, -1, -1, -1)
    expect(atom.setPosition).not.toHaveBeenCalled()
    expect(atom.setSize).not.toHaveBeenCalled()

describe 'restore tree tests', ->
  beforeEach ->
    spyOn($.fn, 'on').andCallThrough()
    spyOn($.fn, 'width')

  it 'has valid params', ->
    size = Math.random() + 1

    waitsFor ->
      r = Dimensions.restoreTree(size)
      evt = document.createEvent('Event')
      evt.initEvent('ready', true, true)
      window.dispatchEvent(evt)
      r

    runs ->
      expect($.fn.on).toHaveBeenCalled()
      expect($.fn.width).toHaveBeenCalledWith(size)

  it 'has invalid params', ->
    Dimensions.restoreTree(-1)
    expect($.fn.on).not.toHaveBeenCalled()
    expect($.fn.width).not.toHaveBeenCalled()

describe 'addListeners', ->
  it 'will work', ->
    spyOn($.fn, 'on')
    Dimensions.addListeners()
    expect($.fn.on).toHaveBeenCalled()
