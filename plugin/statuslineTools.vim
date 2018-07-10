
function! CountTodo()
	let l:lp = qfixhowmutils#listProgress(getline(0,"$"))
	return qfixhowmutils#countTodo(l:lp)
endfunction

function! PercentageTodo()
	let l:lp = qfixhowmutils#listProgress(getline(0,"$"))
	return qfixhowmutils#percentageTodo(l:lp)
endfunction

let g:qfixhowmstylelistcount_bar_complete = "="
let g:qfixhowmstylelistcount_bar_todo = "-"
function! BarTodo(length)
	let l:left = g:qfixhowmstylelistcount_bar_complete
	let l:right = g:qfixhowmstylelistcount_bar_todo
	let l:lp = qfixhowmutils#listProgress(getline(0,"$"))
	let l:done_ratio =(l:lp[0] * 1.0 ) / (l:lp[1] * 1.0 )
	let l:bar = repeat(l:left , float2nr(a:length * l:done_ratio))
	let l:bar = l:bar . repeat(l:right,a:length-len(l:bar))
	return l:bar
endfunction

