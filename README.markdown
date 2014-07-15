# vim-simple-session

Simple session is a straightforward, no hassle plugin for handling named
sessions in VIM.

Just type away `:Session {name}` for creating new sessions or switching to
old sessions. `:SList`, `:SDelete` and `:SQuit` pretty much do what they
promise. Commands that take an argument support autocompletion.

Sessions are automatically saved when VIM is closed or an old session is
opened up.

If present, this plugin also integrates with vim-fugitive (`:SGit` for going
to a sesion named like the current git branch), and also with CtrlP,
`:CtrlPSession` enables a mode to switch between sessions (you need to enable
the extension first, see documentation `:h simple-session-:CtrlPSession`).

This plugin is just a wrapper for `:mksession`, so check out `'sessionoptions'`
for choosing what VIM stores in the session. I suggest removing `blank`, which
is basically useless; and specially `options`, in order to prevent stale options
in sessions.

Including a statusline indicator is also possible adding
`%{session#statusline()}` to the `'statusline'` option.

## Installation

Just copy the files to your `~/.vim/` directory, or see alternatives below.

### Pathogen

Installation with [pathogen.vim](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone git://github.com/


### Vundle

With [Vundle](https://github.com/gmarik/Vundle.vim), add this to your .vimrc:

    Plugin 'tpope/vim-fugitive'

And then run in VIM:

    :PluginInstall

## Documentation

Once the plugin has been correctly installed, you can read the manual with
`:help simple-session`.

## License

Copyright © Manuel Colmenero. Distributed under the same terms as VIM itself.
See `:help license`.
