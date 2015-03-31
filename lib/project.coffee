{$} = require 'atom'
Config = require './config'

module.exports =

  activate: ->
    previousRestoreState = localStorage.sessions_restore
    localStorage.sessions_restore = "no" # Disable files restore for now
    setTimeout ->
      project = Config.project()
      if Config.restoreProject() and project? and atom.project.getPaths().length == 0
        if previousRestoreState == "yes"
          localStorage.sessions_restore = "yes"
          module.exports.restore(project)
          setTimeout -> # Give time to the files module before changing state
            localStorage.sessions_restore = "no"
          , 700
    , 300
    @addListeners()

  deactivate: ->
    localStorage.sessions_restore = "yes"

  save: ->
    Config.project atom.project.getPaths()[0]

  restore: (path) ->
    if path isnt '0'
      atom.project.setPaths [path]

  onReopenProject: ->
    localStorage.sessions_restore = "yes"
    atom.workspaceView.trigger 'application:new-window'

  addListeners: ->
    $(window).on 'focus', (event) =>
      @save()

    $(window).on 'unload', (event) =>
      @deactivate()

    atom.commands.add 'atom-workspace', 'save-session:reopen-project', =>
      @onReopenProject()
