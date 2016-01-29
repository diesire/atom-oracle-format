{CompositeDisposable, BufferedProcess} = require 'atom'

module.exports =
  subscriptions: null

  config:
    sdcliPath:
      title: 'Path to sdcli'
      description: 'Full path to sdcli.exe or sdcli64.exe'
      type: 'string'
      default: 'C:\\Program Files (x86)\\Oracle\\Product\\SQLDeveloper\\4.0\\sqldeveloper\\sqldeveloper\\bin\\sdcli.exe'

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'oracle-format:formatEditor': => @formatEditor()
    @subscriptions.add atom.commands.add '.tree-view .file .name[data-name$=\\.sql]', 'oracle-format:formatFile': ({target}) => @formatPath(target)
    @subscriptions.add atom.commands.add '.tree-view .directory .icon-file-directory', 'oracle-format:formatDir': ({target}) => @formatPath(target)

  deactivate: ->
    @subscriptions.dispose()

  # Format the content of the editor
  formatEditor: ->
    editor = atom.workspace.getActiveTextEditor()
    buffer = editor?.getBuffer()
    file = buffer?.getPath()
    title = editor?.getTitle()

    # Check file is saved
    if title is 'untitled'
      atom.notifications.addWarning("Save the file before format it")
      return

    # Check supported grammar
    if editor.getGrammar().scopeName not in ['source.sql', 'source.plsql.oracle']
      atom.notifications.addWarning("#{title} does not look like an SQL file", {detail: "Select a valid grammar"})
      return

    # Save modifications and format
    atom.notifications.addInfo("Formatting active editor...")
    buffer.save() if buffer.isModified()
    @_format(file, file)

  # Format a file or folder from the tree view
  formatPath: (target) ->
    file = target.dataset.path
    atom.notifications.addInfo("Formatting #{target.dataset.name}")
    @_format(file, file)

  # Call sdcli to format given path
  _format: (inputFile, outputFile) ->
    command = atom.config.get('oracle-format.sdcliPath')
    args = ['format', "input=#{inputFile}", "output=#{outputFile}"]
    stdout = (output) ->
      atom.notifications.addSuccess("Format done", {detail: "#{output}"})
    stderr = (output) ->
      metadata = {command: command, args: args, output: output}
      atom.notifications.addError("Format failed", {detail: "#{output}\n💡 More details in Developer Tools console", dismissable: true})
      console.error("Format failed", metadata)
    exit = (code) ->
      console.debug("Format exit with #{code}") unless code is 0
    handleError = (errorObject) ->
      metadata = {command: command, args: args, error: errorObject.error}
      atom.notifications.addFatalError("Format died in agony", {detail: "💡 More details in Developer Tools console", dismissable: true})
      console.error("Format died in agony", metadata)
      #errorObject.handle #Keep this commented until be sure...

    process = new BufferedProcess({command, args, stdout, stderr})
    process.onWillThrowError(handleError)
