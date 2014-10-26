{$} = require 'atom'
Config = require '../lib/config'
Project = require '../lib/project'
{WorkspaceView} = require 'atom'

describe 'activate tests', ->
  beforeEach ->
    spyOn(Project, 'restore')
    spyOn(Project, 'addListeners')

  it 'Config.restoreProject is true, project exists, no project is open', ->
    spyOn(Config, 'project').andReturn('project')
    spyOn(Config, 'restoreProject').andReturn(true)
    spyOn(atom.project, 'getPath').andReturn(undefined)

    Project.activate()

    expect(Config.project).toHaveBeenCalled()
    expect(Config.restoreProject).toHaveBeenCalled()
    expect(atom.project.getPath).toHaveBeenCalled()
    expect(Project.restore).toHaveBeenCalledWith('project')
    expect(Project.addListeners).toHaveBeenCalled()

  it 'Config.restoreProject is true, project exists, project is open', ->
    spyOn(Config, 'project').andReturn('project')
    spyOn(Config, 'restoreProject').andReturn(true)
    spyOn(atom.project, 'getPath').andReturn('project')

    Project.activate()

    expect(Config.project).toHaveBeenCalled()
    expect(Config.restoreProject).toHaveBeenCalled()
    expect(atom.project.getPath).toHaveBeenCalled()
    expect(Project.restore).not.toHaveBeenCalled()
    expect(Project.addListeners).toHaveBeenCalled()

  it 'Config.restoreProject is true, no project exists', ->
    spyOn(Config, 'project').andReturn('project')
    spyOn(Config, 'restoreProject').andReturn(false)
    spyOn(atom.project, 'getPath')

    Project.activate()

    expect(Config.project).toHaveBeenCalled()
    expect(Config.restoreProject).toHaveBeenCalled()
    expect(atom.project.getPath).not.toHaveBeenCalled()
    expect(Project.restore).not.toHaveBeenCalled()
    expect(Project.addListeners).toHaveBeenCalled()

  it 'Config.restoreProject is false', ->
    spyOn(Config, 'project').andReturn('project')
    spyOn(Config, 'restoreProject').andReturn(false)
    spyOn(atom.project, 'getPath')

    Project.activate()

    expect(Config.project).toHaveBeenCalled()
    expect(Config.restoreProject).toHaveBeenCalled()
    expect(atom.project.getPath).not.toHaveBeenCalled()
    expect(Project.restore).not.toHaveBeenCalled()
    expect(Project.addListeners).toHaveBeenCalled()


describe 'restore tests', ->
  it 'contains a valid path', ->
    path = Math.random() + 1
    spyOn(atom.project, 'setPath')

    Project.restore path
    expect(atom.project.setPath).toHaveBeenCalledWith(path)

  it 'contains an invalid path', ->
    path = '0'
    spyOn(atom.project, 'setPath')

    Project.restore path
    expect(atom.project.setPath).not.toHaveBeenCalled()


describe 'onNewWindow tests', ->
  it 'opens a new window without a project', ->
    spyOn(Config, 'project')
    Project.resetProject = true
    Project.onNewWindow()

    expect(Config.project).toHaveBeenCalledWith(undefined, true)

  it 'opens a new window with the last project', ->
    spyOn(Config, 'project')
    Project.resetProject = false
    Project.onNewWindow()
    expect(Config.project).not.toHaveBeenCalled()
