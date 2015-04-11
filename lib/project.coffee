{$} = require 'atom-space-pen-views'
Config = require './config'

module.exports =

  activate: ->
    @resetProject = true
    projects = Config.projects()

    if (Config.restoreProjects() and projects?)
        @restore(projects)

    @addListeners()

  save: ->
    Config.projects atom.project.getPaths()

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
