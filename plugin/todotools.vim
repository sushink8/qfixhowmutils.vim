
function! Progress(...)
	let s:file = get(a:,1,"**/")
	return qfixhowmutils#showProgress(g:howm_dir,function("qfixhowmutils#countTodo"),s:file,0)
endfunction


function! ProgressHidden(...)
	let s:file = get(a:,1,"**/")
	return qfixhowmutils#showProgress(g:howm_dir,function("qfixhowmutils#countTodo"),s:file,1)
endfunction

