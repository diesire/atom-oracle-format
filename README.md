# atom-oracle-format

Quick and dirty SQL formatter using Oracle SQL Developer

## Usage

### Format editor content `alt-ctrl-l`/`alt-cmd-l`

**Format SQL** in package menu or context menu. Only runs in files using SQL grammar

:warning: File will be saved before being formatted

:snail: This option has the worst performance. It takes a while... so be patient

### Format file

**Format SQL File** in tree view context menu. Option visible on `*.sql` files only

### Format folder

**Format SQL Folder** in tree view context menu. Option available on folders only

:warning: Formats all the files in the folder, not only `*.sql` files

:rabbit2: This is the most performant option

## Configuration

In the package configuration section, add the path to **sdcli.exe** or **sdcli64.exe**
![image](https://cloud.githubusercontent.com/assets/1185591/11654841/0a1e77a0-9da9-11e5-8102-f6a47a438e3b.png)

## Why

* No hidden dependencies (only Oracle Developer for obvious reasons :wink:)
  * Under corporate proxy installing packages may be difficult due to network limitations
  * Need of Python and Visual Studio to install packages (node-gyp errors) its a big restriction in some circumstances
* Maintain same formatting options throughout the entire code base

## Contributions

Pull requests are welcome, big and small!

## License

MIT © Pablo Escalada
