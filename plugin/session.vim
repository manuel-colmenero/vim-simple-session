"
" Simple Session - straightforward, no hassle VIM named sessions.
"
" Author: Manuel Colmenero <http://colmenero.es/>
" License: Same terms as Vim itself (see :h license)
"
if exists("g:loaded_session")
	finish
endif
let g:loaded_session = 1

"
" Session name completion function for commands.
"
function! s:CompleteSession(A, L, P)
	return filter(session#list(), "match(v:val, a:A) == 0")
endfunction

"
" Removes a session file from the disk and closes if its the active one.
"
" With no arguments the current session is deleted.
"
function! s:DeleteSession(...) 
	if a:1 == ""
		if session#active()
			let l:session = session#current()
			call session#delete(l:session)

			echomsg "Deleted active session: "
			echohl Keyword
			echon l:session
			echohl None
		else
			echohl WarningMsg
			echomsg "No active session found."
			echohl None
		endif
		return
	endif

	for l:session in split(a:1)
		if session#delete(l:session) == 0
			echomsg "Deleted session: "
			echohl Keyword
			echon l:session
			echohl None
		else
			echohl WarningMsg
			echomsg "Session not found: " . l:session
			echohl None
		endif
	endfor
endfunction

"
" Without an argument, it displays the current session (if any) to the user.
"
" With an argument, it creates a new session with that name if it didn't exist,
" otherwise switch to it.
"
function! s:SwitchSession(...)
	if a:1 == ""
		if session#active()
			echomsg "Current session: "

			echohl Keyword
			echon session#current()
			echohl None
		else
			echomsg "No current session"
		endif
	else
		if session#switch(a:1)
			echomsg "Loaded session: "
		else
			echomsg "New session: "
		endif

		echohl Keyword
		echon a:1
		echohl None
	endif
endfunction

"
" Displays all sessions to the user, the current one (if any) marked with an
" asterisk.
"
function! s:ListSessions()
	let l:current = session#current()
	for l:session in session#list()
		echohl Operator
		echo l:session == l:current ? " * " : "   "
		echohl None

		echon l:session
	endfor
endfunction

"
" Load a session named like the current branch.
"
function! s:GitSession()
	if !exists("*fugitive#head")
        echohl WarningMsg
		echomsg "Error: vim-fugitive not installed."
        echohl None
		return
	endif
	call s:SwitchSession(fugitive#head())
endfunction

"
" Shows up CtrlP with the list of open sessions (current is not shown)
"
function! s:CtrlPSession()
	if !exists("*ctrlp#init")
        echohl WarningMsg
		echomsg "Error: CtrlP not installed."
        echohl None
		return
	endif
    call ctrlp#init(ctrlp#session#id())
endfunction

"
" User exposed commands.
"
command! -nargs=? -complete=customlist,s:CompleteSession Session call s:SwitchSession("<args>")
command! -nargs=? -complete=customlist,s:CompleteSession SDelete call s:DeleteSession("<args>")
command! -nargs=* SList call s:ListSessions()
command! -nargs=0 SQuit call session#quit()
command! -nargs=0 SGit call s:GitSession()
command! -nargs=0 CtrlPSession call s:CtrlPSession()

"
" Save session on quit.
"
augroup SimpleSession
	autocmd VimLeave * call session#save()
augroup END
