Config = require './config'

module.exports =

  activate: ->
    if Config.disableNewBufferOnOpen()
        @close()

  # Sets the default open function to a function that sets the default open
  # function to the default open function... Yay!
  close: ->
    atom.workspace.constructor.prototype.saveSessionOpenFunc = atom.workspace.constructor.prototype.open

    removeFunc = (path, options) =>
      atom.workspace.constructor.prototype.open = atom.workspace.constructor.prototype.saveSessionOpenFunc

    atom.workspace.constructor.prototype.open = removeFunc
