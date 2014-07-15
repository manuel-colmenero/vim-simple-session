"
" Buffer handling helping functions.
"
" Author: Manuel Colmenero <http://colmenero.es/>
" License: Same terms as Vim itself (see :h license)
"
if exists("g:loaded_lib_buffer")
	finish
endif
let g:loaded_lib_buffer = 1

" 
" Buffer selection function: selects all.
"
function! s:wipeout_all(buffer)
	return 1
endfunction

" 
" Buffer selection function: select drawer buffers.
"
function! s:wipeout_drawers(buffer)
	return match(buffer_name(a:buffer), "NERD_tree_[0-9]\\+") > -1 || match(buffer_name(a:buffer), "__Tagbar__") > -1
endfunction

" 
" Buffer selection function: select empty buffers.
"
function! s:wipeout_empty(buffer)
	return buflisted(a:buffer) && empty(bufname(a:buffer)) && bufwinnr(a:buffer) < 0
endfunction

" 
" Wipeout all selector buffers (the parameter must be a selector function name)
"
function! buffer#wipeout(type)
	let l:buffers = []
	for l:buffer in range(1, bufnr("$"))
		if bufexists(l:buffer) && s:wipeout_{a:type}(l:buffer)
			let l:buffers = add(l:buffers, l:buffer)
		endif
	endfor

	if !empty(buffers)
		silent! execute "bwipeout ".join(buffers, " ")
	endif
endf
