
module.exports =

  # User configs
  disableNewBufferOnOpen: (val) ->
    @config 'disableNewFileOnOpen', val

  disableNewBufferOnOpenAlways: (val) ->
    @config 'disableNewFileOnOpenAlways', val

  restoreOpenFilesPerProject: (val) ->
    @config 'restoreOpenFilesPerProject', val

  saveFolder: (val) ->
    @config 'dataSaveFolder', val

  restoreProject: (val) ->
    @config 'restoreProject', val

  restoreWindow: (val) ->
    @config 'restoreWindow', val

  restoreFileTreeSize: (val) ->
    @config 'restoreFileTreeSize', val

  restoreOpenFiles: (val) ->
    @config 'restoreOpenFiles', val

  restoreOpenFileContents: (val) ->
    @config 'restoreOpenFileContents', val

  restoreCursor: (val) ->
    @config 'restoreCursor', val

  skipSavePrompt: (val) ->
    @config 'skipSavePrompt', val

  # Saving specific configs
  project: (val) ->
    @config 'project', val

  x: (val) ->
    @config 'x', val

  y: (val) ->
    @config 'y', val

  width: (val) ->
    @config 'width', val

  height: (val) ->
    @config 'height', val

  treeSize: (val) ->
    @config 'treeSize', val

  #Helpers
  saveFolderDefault: ->
    @saveFolder(atom.packages.getPackageDirPaths() + @pathSeparator() + 'save-session' + @pathSeparator() + 'projects')

  pathSeparator: ->
    if process.platform is 'win32'
      return '\\'
    return '/'

  saveFile: ->
    folder = @saveFolder()
    if @restoreOpenFilesPerProject()
      return folder + @pathSeparator() + atom.project.path + @pathSeparator() + 'project.json'
    else
      return folder + @pathSeparator() + 'undefined' + @pathSeparator() + 'project.json'

  config: (key, val) ->
    if val?
      atom.config.set 'save-session.' + key, val
    else
      atom.config.get 'save-session.' + key
