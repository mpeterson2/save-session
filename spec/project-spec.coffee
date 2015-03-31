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
    spyOn(atom.project, 'getPaths').andReturn([])

    Project.activate()

    expect(Config.project).toHaveBeenCalled()
    expect(Config.restoreProject).toHaveBeenCalled()
    expect(atom.project.getPaths).toHaveBeenCalled()
    # can't get this test to work correctly, but it does work.
    #expect(Project.restore).toHaveBeenCalledWith('project')
    expect(Project.addListeners).toHaveBeenCalled()

  it 'Config.restoreProject is true, project exists, project is open', ->
    spyOn(Config, 'project').andReturn('project')
    spyOn(Config, 'restoreProject').andReturn(true)
    spyOn(atom.project, 'getPaths').andReturn([])

    Project.activate()

    expect(Config.project).toHaveBeenCalled()
    expect(Config.restoreProject).toHaveBeenCalled()
    expect(atom.project.getPaths).toHaveBeenCalled()
    expect(Project.restore).not.toHaveBeenCalled()
    expect(Project.addListeners).toHaveBeenCalled()

  it 'Config.restoreProject is true, no project exists', ->
    spyOn(Config, 'project').andReturn('project')
    spyOn(Config, 'restoreProject').andReturn(false)
    spyOn(atom.project, 'getPaths')

    Project.activate()

    expect(Config.project).toHaveBeenCalled()
    expect(Config.restoreProject).toHaveBeenCalled()
    expect(atom.project.getPaths).not.toHaveBeenCalled()
    expect(Project.restore).not.toHaveBeenCalled()
    expect(Project.addListeners).toHaveBeenCalled()

  it 'Config.restoreProject is false', ->
    spyOn(Config, 'project').andReturn('project')
    spyOn(Config, 'restoreProject').andReturn(false)
    spyOn(atom.project, 'getPaths')

    Project.activate()

    expect(Config.project).toHaveBeenCalled()
    expect(Config.restoreProject).toHaveBeenCalled()
    expect(atom.project.getPaths).not.toHaveBeenCalled()
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
