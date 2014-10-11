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
    atom.project.setPath path

  addListeners: ->
    $(window).on 'focus', (event) =>
      @save()
