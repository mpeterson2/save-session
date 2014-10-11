Config = require './config'

module.exports =

  activate: (buffers) ->
    if Config.disableNewBufferOnOpen() and
      (Config.disableNewBufferOnOpenAlways() or
      (Config.restoreOpenFiles() and
      buffers? and buffers.length > 0))
        @close()

  # Sets the default open function to a function that sets the default open
  # function to the default open function... Yay!
  close: ->
    atom.workspace.constructor.prototype.saveSessionOpenFunc = atom.workspace.constructor.prototype.open

    removeFunc = (path) =>
      atom.workspace.constructor.prototype.open = atom.workspace.constructor.prototype.saveSessionOpenFunc

    atom.workspace.constructor.prototype.open = removeFunc
