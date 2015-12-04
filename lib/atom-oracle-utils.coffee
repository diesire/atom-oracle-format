{CompositeDisposable} = require 'atom'

module.exports = AtomOracleUtils =
  subscriptions: null

  activate: (state) ->

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-oracle-utils:format': => @format()

  deactivate: ->
    @subscriptions.dispose()

  format: ->
    console.log 'AtomOracleUtils.format was called!'
    editor = atom.workspace.getActiveTextEditor()
    file = editor?.getBuffer()?.getPath()
    console.log "file #{file}"
    editor?.getBuffer()?.save()

    {BufferedProcess} = require 'atom'
    command = 'C:\\Users\\NG52D87\\bin\\sqldeveloper\\sqldeveloper\\bin\\sdcli.exe'
    args = ['format', "input=#{file}", "output=#{file}"]
    stdout = (output) -> console.log(output)
    exit = (code) -> console.log("sdcli  with #{code}")
    process = new BufferedProcess({command, args, stdout, exit})
