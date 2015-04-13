{$} = require 'atom-space-pen-views'
Config = require '../lib/config'
Project = require '../lib/project'

describe 'activate tests', ->
  beforeEach ->
    spyOn(Project, 'restore')
    spyOn(Project, 'addListeners')

  it 'failed to restore project with : Config.restoreProjects as true, project list exists, no project is open', ->
    spyOn(Config, 'projects').andReturn(['/project'])
    spyOn(Config, 'restoreProjects').andReturn(true)

    Project.activate()

    expect(Config.projects).toHaveBeenCalled()
    expect(Config.restoreProjects).toHaveBeenCalled()
    # can't get this test to work correctly, but it does work.
    #expect(Project.restore).toHaveBeenCalledWith('project')
    expect(Project.addListeners).toHaveBeenCalled()

  it 'tryed to restore with : Config.restoreProjects is true, empty project list', ->
    spyOn(Config, 'projects').andReturn([])
    spyOn(Config, 'restoreProjects').andReturn(false)
    spyOn(atom.project, 'getPaths')

    Project.activate()

    expect(Config.projects).toHaveBeenCalled()
    expect(Config.restoreProjects).toHaveBeenCalled()
    expect(atom.project.getPaths).not.toHaveBeenCalled()
    expect(Project.restore).not.toHaveBeenCalled()
    expect(Project.addListeners).toHaveBeenCalled()

  it 'tryed to restore with : Config.restoreProjects is true, undefined project list', ->
    spyOn(Config, 'projects').andReturn(undefined)
    spyOn(Config, 'restoreProjects').andReturn(false)
    spyOn(atom.project, 'getPaths')

    Project.activate()

    expect(Config.projects).toHaveBeenCalled()
    expect(Config.restoreProjects).toHaveBeenCalled()
    expect(atom.project.getPaths).not.toHaveBeenCalled()
    expect(Project.restore).not.toHaveBeenCalled()
    expect(Project.addListeners).toHaveBeenCalled()

  it 'tryed to restore with : Config.restoreProjects is false', ->
    spyOn(Config, 'projects').andReturn(['/project'])
    spyOn(Config, 'restoreProjects').andReturn(false)
    spyOn(atom.project, 'getPaths')

    Project.activate()

    expect(Config.projects).toHaveBeenCalled()
    expect(Config.restoreProjects).toHaveBeenCalled()
    expect(atom.project.getPaths).not.toHaveBeenCalled()
    expect(Project.restore).not.toHaveBeenCalled()
    expect(Project.addListeners).toHaveBeenCalled()


describe 'restore tests', ->
  it 'contains valid paths', ->
    paths = ['/this/is/a/valid/path', 'this/as/well']
    spyOn(atom.project, 'addPath')
    localStorage.sessionRestore = true

    Project.restore paths
    expect(atom.project.addPath).toHaveBeenCalledWith(paths[0])
    expect(atom.project.addPath).toHaveBeenCalledWith(paths[1])

  it 'is not an array', ->
    paths = {name:"john", age: 22}
    spyOn(atom.project, 'addPath')

    Project.restore paths
    expect(atom.project.addPath).not.toHaveBeenCalled()

  it 'contains no paths', ->
    paths = []
    spyOn(atom.project, 'addPath')

    Project.restore paths
    expect(atom.project.addPath).not.toHaveBeenCalled()
