
function! Progress()
	" return qfixhowmutils#countInDir(".",function("qfixhowmutils#countTodo"))
	return qfixhowmutils#showProgress(g:howm_dir,function("qfixhowmutils#countTodo"),0)
endfunction


function! ProgressHidden()
	" return qfixhowmutils#countInDir(".",function("qfixhowmutils#countTodo"))
	return qfixhowmutils#showProgress(g:howm_dir,function("qfixhowmutils#countTodo"),1)
endfunction
