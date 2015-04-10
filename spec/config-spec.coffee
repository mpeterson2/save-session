Config = require '../lib/config'
Os = require 'os'

describe 'pathSeparator tests', ->
  beforeEach: ->

  it 'Not Windows', ->
    spyOn(Os, 'platform').andReturn(Math.random())
    expect(Config.pathSeparator()).toBe('/')
    expect(Os.platform).toHaveBeenCalled()

  it 'Windows', ->
    spyOn(Os, 'platform').andReturn('win32')
    expect(Config.pathSeparator()).toBe('\\')
    expect(Os.platform).toHaveBeenCalled()


describe 'saveFile tests', ->
  beforeEach ->
    spyOn(Config, 'saveFolder').andReturn('folder')
    spyOn(Config, 'pathSeparator').andReturn('/')

  describe 'projects restoring', ->
    it 'is a project to be restored', ->
      atom.project.path || atom.project.rootDirectories[0].path = '/'

      expect(Config.saveFile()).toBe('folder/project.json')
      expect(Config.saveFolder).toHaveBeenCalled()
      expect(Config.pathSeparator).toHaveBeenCalled()


describe 'transformProjectPath tests', ->
  it 'is Windows with :', ->
    spyOn(Config, 'isWindows').andReturn(true)
    path = Config.transformProjectPath('c:\\path')
    expect(path).toBe('c\\path')

  it 'is Windows without :', ->
    spyOn(Config, 'isWindows').andReturn(true)
    path = Config.transformProjectPath('path\\more')
    expect(path).toBe('path\\more')

  it 'is not windows', ->
    spyOn(Config, 'isWindows').andReturn(false)
    path = Config.transformProjectPath('path/more')
    expect(path).toBe('path/more')


describe 'config tests', ->
  beforeEach ->
    spyOn(atom.config, 'set')
    spyOn(atom.config, 'get')

  it 'Contains key and value', ->
    Config.config 'key', 'val'
    expect(atom.config.set).toHaveBeenCalled()
    expect(atom.config.get).not.toHaveBeenCalled()

  it 'Contains key and forced', ->
    Config.config 'key', undefined, true
    expect(atom.config.set).toHaveBeenCalled()
    expect(atom.config.get).not.toHaveBeenCalled()

  it 'Contains key only', ->
    Config.config 'key'
    expect(atom.config.set).not.toHaveBeenCalled()
    expect(atom.config.get).toHaveBeenCalled()
