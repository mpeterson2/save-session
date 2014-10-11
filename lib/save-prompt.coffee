Config = require './config'

module.exports =

  activate: ->
    @defaultSavePrompt = atom.workspace.getActivePane().constructor.prototype.promptToSaveItem
    @addListeners()

  # Hack to override the promptToSaveItem method of Pane
  # There doesn't appear to be a direct way to get to the Pane object
  # with require(), unfortunately, so I have to result to this hack.
  disable: ->
    atom.workspace.getActivePane().constructor.prototype.promptToSaveItem = (item) ->
      return true

  enable: ->
    atom.workspace.getActivePane().constructor.prototype.promptToSaveItem = @defaultSavePrompt

  enableTemp: ->
    atom.workspace.getActivePane().constructor.prototype.promptToSaveItem = (item) =>
      save = @defaultSavePrompt item
      @disable()
      save

  addListeners: ->
    atom.config.observe 'save-session.skipSavePrompt', (val) =>
      if val
        @disable()
      else
        @enable()

    # Before closing an editor
    atom.workspace.observePanes (pane) =>
      pane.onWillDestroyItem (event) =>
        if Config.skipSavePrompt()
          @enableTemp()
