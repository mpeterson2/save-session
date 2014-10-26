{$} = require 'atom'
Config = require './config'

module.exports =

  activate: ->
    @resetProject = true
    project = Config.project()
    if Config.restoreProject() and project? and not atom.project.getPath()?
      @restore(project)

    @addListeners()

  save: ->
    Config.project atom.project.getPath()

  restore: (path) ->
    if path isnt '0'
      atom.project.setPath path

  onNewWindow: ->
    if @resetProject
      Config.project(undefined, true)
      @resetProject = true

  onReopenProject: ->
    @resetProject = false
    atom.workspaceView.trigger 'application:new-window'

  addListeners: ->
    $(window).on 'focus', (event) =>
      @save()

    atom.workspaceView.preempt 'application:new-window', =>
      @onNewWindow()

    atom.workspaceView.command 'save-session:reopen-project', =>
      @onReopenProject()
