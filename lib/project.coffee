{$} = require 'atom'
Config = require './config'

module.exports =

  activate: ->
    project = Config.project()
    if Config.restoreProject() and project? and not atom.project.getPath()?
      @restore(project)

    @addListeners()

  save: ->
    Config.project atom.project.getPath()

  restore: (path) ->
    if path isnt '0'
      atom.project.setPath path

  addListeners: ->
    $(window).on 'focus', (event) =>
      @save()

    atom.workspaceView.preempt 'application:new-window', =>
      if not @openLast
        Config.project(undefined, true)

    atom.workspaceView.command 'save-session:reopen-project', =>
      @openLast = true
      atom.workspaceView.trigger 'application:new-window'
