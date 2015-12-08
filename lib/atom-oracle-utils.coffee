{CompositeDisposable, BufferedProcess} = require 'atom'

module.exports = AtomOracleUtils =
  subscriptions: null

  config:
    sdcliPath:
      title: 'Path to sdcli'
      description: 'Full path to sdcli.exe or sdcli64.exe'
      type: 'string'
      default: 'C:\\Program Files (x86)\\Oracle\\Product\\SQLDeveloper\\4.0\\sqldeveloper\\sqldeveloper\\bin\\sdcli.exe'

  activate: (state) ->
    console.log 'Activate AtomOracleUtils'

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-oracle-utils:formatEditor': => @formatEditor()
    @subscriptions.add atom.commands.add '.tree-view .file .name[data-name$=\\.sql]', 'atom-oracle-utils:formatFile': ({target}) => @formatPath(target)
    @subscriptions.add atom.commands.add '.tree-view .directory .icon-file-directory', 'atom-oracle-utils:formatDir': ({target}) => @formatPath(target)

  deactivate: ->
    @subscriptions.dispose()

  formatEditor: ->
    console.log 'AtomOracleUtils.formatEditor was called!'
    editor = atom.workspace.getActiveTextEditor()
    if editor.getGrammar().scopeName isnt 'source.sql'
      console.log 'This is not an SQL file'
      return

    file = editor?.getBuffer()?.getPath()
    console.log "file #{file}"
    editor?.getBuffer()?.save()
    @_format(file, file)

  formatPath: (target)->
    console.log 'AtomOracleUtils.formatPath was called!', target
    file = target.dataset.path
    console.log 'Path: ', file # Logs the path of the selected item
    @_format(file, file)

  _format: (inputFile, outputFile)->
    command = atom.config.get('atom-oracle-utils.sdcliPath')
    console.log command
    args = ['format', "input=#{inputFile}", "output=#{outputFile}"]
    stdout = (output) -> console.log(output)
    exit = (code) -> console.log("sdcli  with #{code}")
    process = new BufferedProcess({command, args, stdout, exit})
