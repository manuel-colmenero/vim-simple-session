"
" This file contains the "rudiments" of handling sessions.
"
" Author: Manuel Colmenero <http://colmenero.es/>
" License: Same terms as Vim itself (see :h license)
"
if exists("g:loaded_lib_session")
	finish
endif
let g:loaded_lib_session = 1

"
" Ensure session dir is there before the lib is loaded.
"
if !exists("g:session_dir")
	let g:session_dir = $HOME . "/.vim_sessions"
endif
if !isdirectory(expand(g:session_dir))
	call mkdir(expand(g:session_dir), "p")
endif

"
" Returns true if there is an active session at the moment.
"
function! session#active()
	return v:this_session != ""
endfunction

"
" Returns the name of the current session, if there's an active session.
"
function! session#current()
	if session#active()
		return session#get_name(v:this_session)
	endif
	return ""
endfunction

" 
" Returns the session file path given the name.
"
function! session#expand(name)
	let l:wildignore = &wildignore
	set wildignore=
	let l:result = expand(g:session_dir."/".a:name.".vim")
	let &wildignore = l:wildignore
	return l:result
endfunction

"
" Returns the session name given the session path.
"
function! session#get_name(path)
	let l:wildignore = &wildignore
	set wildignore=
	return fnamemodify(a:path, ":t:r")
	let &wildignore = l:wildignore
endfunction

"
" Returns all the sessions available
"
function! session#list()
	let l:wildignore = &wildignore
	set wildignore=
	let l:session_files = split(globpath(g:session_dir, "*.vim"))
	let l:result = map(l:session_files, "fnamemodify(expand(v:val), ':t:r')")
	let &wildignore = l:wildignore
	return l:result
endfunction

"
" Loads a session, returns true if it could be loaded.
"
function! session#load(name)
	let v:this_session = session#expand(a:name)
	if filereadable(v:this_session)
		execute "source" v:this_session
		return 1
	else
		call session#save()
	endif
	return 0
endfunction

"
" Saves a session.
"
function! session#save()
	if session#active()
		call buffer#wipeout("drawers")
		silent! execute "mksession!" v:this_session
	endif
endfunction

"
" Deletes a session and closes it if its the active one.
"
function! session#delete(name)
	let l:current = session#current()
	if a:name == l:current
		call session#quit()
	endif

	let l:session_file = session#expand(a:name)
	let l:deleted = delete(l:session_file)

	return l:deleted
endfunction

"
" Saves the current session and closes it (if any). Then loads the given
" session.
"
function! session#switch(name)
	if session#active()
		call session#save()
		call buffer#wipeout("all")
	endif
	return session#load(a:name)
endfunction

"
" Saves and quits a session.
"
function! session#quit()
	call session#save()
	call buffer#wipeout("all")
	let v:this_session = ""
endfunction

"
" Returns a status-line suitable string
"
function! session#statusline()
	if session#active()
		return ",SES(" . session#current() . ")"
	endif
	return ""
endfunction
