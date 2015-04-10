{$} = require 'atom-space-pen-views'
Config = require './config'

module.exports =

  activate: ->
    @resetProject = true
    projects = Config.projects()

    ###console.log(Config.restoreProjects() and projects?)
    console.log(atom.project.getPaths())
    console.log(localStorage.sessionRestore)
    console.log(Config.restoreProjects() and projects? and localStorage.sessionRestore)###

    if (Config.restoreProjects() and projects? and localStorage.sessionRestore)
        localStorage.sessionRestore = false
        @restore(projects)

    @addListeners()

  save: ->
    Config.projects atom.project.getPaths()

    ###console.log('config saved with :')
    console.log(atom.project.getPaths())###
    console.log('config saved is now :')
    console.log(Config.projects())

  restore: (paths) ->
    if Config.isArray(paths)
      for path in paths
        atom.project.addPath(path)

  onReopenProject: ->
    localStorage.sessionRestore = true
    atom.commands.dispatch(atom.views.getView(atom.workspace), 'application:new-window')

  addListeners: ->
    $(window).on 'focus', (event) =>
      @save()

    atom.commands.add 'atom-workspace', 'save-session:reopen-project', =>
      @onReopenProject()
