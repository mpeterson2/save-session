Os = require 'os'
Crypto = require('crypto')

module.exports =

  # User configs
  disableNewBufferOnOpen: (val, force) ->
    @config 'disableNewFileOnOpen', val, force

  disableNewBufferOnOpenAlways: (val, force) ->
    @config 'disableNewFileOnOpenAlways', val, force

  restoreOpenFilesPerProject: (val, force) ->
    @config 'restoreOpenFilesPerProject', val, force

  saveFolder: (val, force) ->
    saveFolderPath = @config 'dataSaveFolder', val, force
    if not saveFolderPath?
      @setSaveFolderDefault()
      saveFolderPath = @saveFolder()
    return saveFolderPath

  restoreOpenFileContents: (val, force) ->
    @config 'restoreOpenFileContents', val, force

  skipSavePrompt: (val, force) ->
    @config 'skipSavePrompt', val, force

  extraDelay: (val, force) ->
    @config 'extraDelay', val, force

  #Helpers
  setSaveFolderDefault: ->
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

    if atom.project.getPaths().length > 0
      projects = atom.project.getPaths()
      projectPath = projects[0] if (projects? and projects.length > 0)

      if projectPath?
        path = @transformProjectPath(projectPath)
        return saveFolderPath + @pathSeparator() + path + @pathSeparator() + 'project.json'

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
