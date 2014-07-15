" =============================================================================
" File:          autoload/ctrlp/session.vim
" Description:   Load sessions directly from CtrlP
" =============================================================================

" NOTE: This file was shamelessly copied from CtrlP.
" https://github.com/kien/ctrlp.vim/blob/extensions/autoload/ctrlp/sample.vim

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['session']
"
" Where 'session' is the name of the file 'session.vim'
"
" For multiple extensions:
"
"     let g:ctrlp_extensions = [
"         \ 'my_extension',
"         \ 'my_other_extension',
"         \ ]

" Load guard
if ( exists('g:loaded_ctrlp_session') && g:loaded_ctrlp_session )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_session = 1


" Add this extension's settings to g:ctrlp_ext_vars
"
" Required:
"
" + init: the name of the input function including the brackets and any
"         arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
" + specinput: enable special inputs '..' and '@cd' (disabled by default)
"
call add(g:ctrlp_ext_vars, {
	\ 'init': 'ctrlp#session#init()',
	\ 'accept': 'ctrlp#session#accept',
	\ 'lname': 'sessions',
	\ 'sname': 'sessions',
	\ 'type': 'line',
	\ })

	" \ 'enter': 'ctrlp#session#enter()',
	" \ 'exit': 'ctrlp#session#exit()',
	" \ 'opts': 'ctrlp#session#opts()',
	" \ 'sort': 0,
	" \ 'specinput': 0,

" Provide a list of strings to search in
"
" Return: a Vim's List
"
function! ctrlp#session#init()
	let l:sessions = session#list()
	if exists("v:this_session")
		let l:sessions = filter(l:sessions, "v:val != '".v:this_session."'")
	endif
	return l:sessions
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#session#accept(mode, str)
	call ctrlp#exit()
	call session#switch(a:str)
endfunction


" (optional) Do something before enterting ctrlp
function! ctrlp#session#enter()
endfunction


" (optional) Do something after exiting ctrlp
function! ctrlp#session#exit()
endfunction


" (optional) Set or check for user options specific to this extension
function! ctrlp#session#opts()
endfunction


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#session#id()
	return s:id
endfunction


" Create a command to directly call the new search type
"
" Put this in vimrc or plugin/session.vim
" command! CtrlPSession call ctrlp#init(ctrlp#session#id())


" vim:nofen:fdl=0:ts=2:sw=2:sts=2
