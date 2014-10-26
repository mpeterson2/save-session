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

  describe 'real projects', ->
    it 'With a project', ->
      spyOn(Config, 'restoreOpenFilesPerProject').andReturn(true)
      spyOn(Config, 'transformProjectPath').andReturn('project')
      atom.project.path = 'project'

      expect(Config.saveFile()).toBe('folder/project/project.json')
      expect(Config.saveFolder).toHaveBeenCalled()
      expect(Config.restoreOpenFilesPerProject).toHaveBeenCalled()
      expect(Config.transformProjectPath).toHaveBeenCalled()
      expect(Config.pathSeparator).toHaveBeenCalled()

  describe 'undefined projects', ->
    it 'With no project', ->
      spyOn(Config, 'restoreOpenFilesPerProject').andReturn(true)
      spyOn(Config, 'transformProjectPath')
      atom.project.path = undefined

    it 'Without restoring per project without project', ->
      spyOn(Config, 'restoreOpenFilesPerProject').andReturn(false)
      spyOn(Config, 'transformProjectPath')
      atom.project.path = undefined

    it 'Without restoring per project with project', ->
      spyOn(Config, 'restoreOpenFilesPerProject').andReturn(false)
      spyOn(Config, 'transformProjectPath')
      atom.project.path = 'path'

    it 'Without project or restoring per project', ->
      spyOn(Config, 'restoreOpenFilesPerProject').andReturn(false)
      spyOn(Config, 'transformProjectPath')
      atom.project.path = undefined

    afterEach ->
      expect(Config.saveFile()).toBe('folder/undefined/project.json')
      expect(Config.saveFolder).toHaveBeenCalled()
      expect(Config.restoreOpenFilesPerProject).toHaveBeenCalled()
      expect(Config.transformProjectPath).not.toHaveBeenCalled()
      expect(Config.pathSeparator).toHaveBeenCalled()


describe 'transformProjectPath tests', ->
  it 'Windows with :', ->
    spyOn(Config, 'isWindows').andReturn(true)
    path = Config.transformProjectPath('c:\\path')
    expect(path).toBe('c\\path')

  it 'Windows without :', ->
    spyOn(Config, 'isWindows').andReturn(true)
    path = Config.transformProjectPath('path\\more')
    expect(path).toBe('path\\more')

  it 'Not windows', ->
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
