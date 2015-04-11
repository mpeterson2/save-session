Os = require 'os'
Crypto = require('crypto')

module.exports =

  # User configs
  disableNewBufferOnOpen: (val, force) ->
    @config 'disableNewFileOnOpen', val, force

  disableNewBufferOnOpenAlways: (val, force) ->
    @config 'disableNewFileOnOpenAlways', val, force

  saveFolder: (val, force) ->
    saveFolderPath = @config 'dataSaveFolder', val, force
    if not saveFolderPath?
      @saveFolderDefault()
      saveFolderPath = @saveFolder()
    return saveFolderPath

  restoreProjects: (val, force) ->
    @config 'restoreProjects', val, force

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
  projects: (val, force) ->
    @config 'projects', val, force

  windowX: (val, force) ->
    @config 'windowX', val, force

  windowY: (val, force) ->
    @config 'windowY', val, force

  windowWidth: (val, force) ->
    @config 'windowWidth', val, force

  windowHeight: (val, force) ->
    @config 'windowHeight', val, force

  fullScreen: (val, force) ->
    @config 'fullScreen', val, force

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

  isArray: (value) ->
    value and
      typeof value is 'object' and
        value instanceof Array and
        typeof value.length is 'number' and
        typeof value.splice is 'function' and
        not (value.propertyIsEnumerable 'length')

  saveFile: ->
    saveFolderPath = @saveFolder()

    return saveFolderPath + @pathSeparator() + 'project.json'

  transformProjectPath: (path) ->
    if @isWindows
      colon = path.indexOf(':')
      if colon isnt -1
        return path.substring(0, colon) + path.substring(colon + 1, path.length)

    return path

  hashMyStr: (str) ->
    hash = "" #return empty hash for empy string
    if str? and str isnt ""
      hash = Crypto.createHash('md5').update(str).digest("hex")

    return hash

  config: (key, val, force) ->
    if val? or (force? and force)
      atom.config.set 'save-session.' + key, val
    else
      atom.config.get 'save-session.' + key
