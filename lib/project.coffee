{$} = require 'atom'
Config = require './config'

module.exports =

  activate: ->
    project = Config.project()
    if Config.restoreProject() and project? and not atom.project.getPath()?
      @restore(project)

    atom.workspaceView.preempt 'application:new-window', =>
      Config.project(undefined, true)

    @addListeners()

  save: ->
    Config.project atom.project.getPath()

  restore: (path) ->
    atom.project.setPath path

  addListeners: ->
    $(window).on 'focus', (event) =>
      @save()
