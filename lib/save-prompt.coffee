Config = require './config'

module.exports =

  activate: ->
    @addListeners()

  enableTemp: (pane) ->
    pane.promptToSaveItem = (item) ->
      save = pane.promptToSaveItem2 item
      pane.promptToSaveItem = (item) ->
        true
      save

  addListeners: ->

    Config.observe 'skipSavePrompt', (val) ->
      atom.workspace.getPanes().map (pane) ->
        if val
          pane.promptToSaveItem = (item) ->
            true
        else if pane.promptToSaveItem2
          pane.promptToSaveItem = (item) ->
            pane.promptToSaveItem2 item


    atom.workspace.observePanes (pane) =>
      pane.promptToSaveItem2 = pane.promptToSaveItem

      if Config.skipSavePrompt()
        pane.promptToSaveItem = (item) ->
          true

      pane.onWillDestroyItem (event) =>
        if Config.skipSavePrompt()
          @enableTemp pane
        else
          pane.promptToSaveItem = (item) ->
            pane.promptToSaveItem2 item
