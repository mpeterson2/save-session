SavePrompt = require '../lib/save-prompt'

describe 'disable/enable tests', ->
  it 'activates, disables it then enables it', ->
    orig = atom.workspace.getActivePane().constructor.prototype.promptToSaveItem
    spyOn(SavePrompt, 'addListeners')
    SavePrompt.activate()

    SavePrompt.disable()
    expect(atom.workspace.getActivePane().constructor.prototype.promptToSaveItem)
      .not.toBe(orig)

    SavePrompt.enable()
    expect(atom.workspace.getActivePane().constructor.prototype.promptToSaveItem)
      .toBe(orig)


describe 'enableTemp tests', ->
  it 'enables it temporarily', ->
    orig = atom.workspace.getActivePane().constructor.prototype.promptToSaveItem
    spyOn(SavePrompt, 'addListeners')
    SavePrompt.activate()

    SavePrompt.enableTemp()
    expect(atom.workspace.getActivePane().constructor.prototype.promptToSaveItem)
      .not.toBe(orig)
