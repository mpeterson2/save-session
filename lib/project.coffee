{$} = require 'atom'
Config = require './config'

module.exports =

  activate: ->
    @resetProject = true
    project = Config.project()

    if Config.restoreProject() and project? and
      atom.project.getPaths().length == 0 and
      localStorage.sessionRestore == 'true'
        localStorage.sessionRestore = false
        @restore(project)

    @addListeners()

  save: ->
    Config.project atom.project.getPath()

  restore: (path) ->
    if path isnt '0'
      atom.project.setPath path

  onReopenProject: ->
    localStorage.sessionRestore = true
    atom.workspaceView.trigger 'application:new-window'

  addListeners: ->
    $(window).on 'focus', (event) =>
      @save()

    atom.commands.add 'atom-workspace', 'save-session:reopen-project', =>
      @onReopenProject()
