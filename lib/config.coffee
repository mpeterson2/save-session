Os = require 'os'

module.exports =

  # User configs
  disableNewBufferOnOpen: (val, force) ->
    @config 'disableNewFileOnOpen', val, force

  disableNewBufferOnOpenAlways: (val, force) ->
    @config 'disableNewFileOnOpenAlways', val, force

  restoreOpenFilesPerProject: (val, force) ->
    @config 'restoreOpenFilesPerProject', val, force

  saveFolder: (val, force) ->
    @config 'dataSaveFolder', val, force

  restoreProject: (val, force) ->
    @config 'restoreProject', val, force

  restoreWindow: (val, force) ->
    @config 'restoreWindow', val, force

  restoreFileTreeSize: (val, force) ->
    @config 'restoreFileTreeSize', val, force

  restoreOpenFiles: (val, force) ->
    @config 'restoreOpenFiles', val, force

  restoreOpenFileContents: (val, force) ->
    @config 'restoreOpenFileContents', val, force

  restoreCursor: (val, force) ->
    @config 'restoreCursor', val, force

  restoreScrollPos: (val, force) ->
    @config 'restoreScrollPosition', val, force

  skipSavePrompt: (val, force) ->
    @config 'skipSavePrompt', val, force

  extraDelay: (val, force) ->
    @config 'extraDelay', val, force

  # Saving specific configs
  project: (val, force) ->
    @config 'project', val, force

  windowX: (val, force) ->
    @config 'windowX', val, force

  windowY: (val, force) ->
    @config 'windowY', val, force

  windowWidth: (val, force) ->
    @config 'windowWidth', val, force

  windowHeight: (val, force) ->
    @config 'windowHeight', val, force

  treeSize: (val, force) ->
    @config 'treeSize', val, force

  #Helpers
  saveFolderDefault: ->
    @saveFolder(atom.packages.getPackageDirPaths() + @pathSeparator() + 'save-session' + @pathSeparator() + 'projects')

  pathSeparator: ->
    if @isWindows()
      return '\\'
    return '/'

  isWindows: ->
    return Os.platform() is 'win32'

  saveFile: ->
    folder = @saveFolder()
    if @restoreOpenFilesPerProject() and atom.project.path?
      path = @transformProjectPath(atom.project.path)
      return folder + @pathSeparator() + path + @pathSeparator() + 'project.json'
    else
      return folder + @pathSeparator() + 'undefined' + @pathSeparator() + 'project.json'

  transformProjectPath: (path) ->
    if @isWindows
      colon = path.indexOf(':')
      if colon isnt -1
        return path.substring(0, colon) + path.substring(colon + 1, path.length)

    return path

  config: (key, val, force) ->
    if val? or (force? and force)
      atom.config.set 'save-session.' + key, val
    else
      atom.config.get 'save-session.' + key
