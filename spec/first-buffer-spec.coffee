Config = require '../lib/config'
FirstBuffer = require '../lib/first-buffer'

describe 'activate tests', ->
  it 'Config.disableNewBufferOnOpen is true', ->
    spyOn(Config, 'disableNewBufferOnOpen').andReturn(true)
    spyOn(FirstBuffer, 'close')

    FirstBuffer.activate()
    expect(FirstBuffer.close).toHaveBeenCalled()

  it 'Config.disableNewBufferOnOpen is false', ->
    spyOn(Config, 'disableNewBufferOnOpen').andReturn(false)
    spyOn(FirstBuffer, 'close')

    FirstBuffer.activate()
    expect(FirstBuffer.close).not.toHaveBeenCalled()


describe 'close tests', ->
  it 'closes the buffer', ->
    closeFunc = atom.workspace.constructor.prototype.open
    FirstBuffer.close()
    expect(atom.workspace.constructor.prototype.open).not.toBe(closeFunc)
    atom.workspace.open()
    expect(atom.workspace.constructor.prototype.open).toBe(closeFunc)
