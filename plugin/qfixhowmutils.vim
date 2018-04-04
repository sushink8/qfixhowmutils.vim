

function! s:listProgress()
	let l:count_all_list = qfixhowmutils#count("^\\s*[-*]\\?\\s*{.}") + qfixhowmutils#count("{.}\\s*$")
	let l:count_done = qfixhowmutils#count("^\\s*[-*]\\?\\s*{[^ ]}") + qfixhowmutils#count("{[^ ]}\\s*$")
	return [l:count_done , l:count_all_list]
endfunction

function! CountTodo()
	let l:lp = s:listProgress()
	return l:lp[0] . "/" . l:lp[1]
endfunction

function! PercentageTodo()
	let l:lp = s:listProgress()
	if l:lp[1] <= 0
		return "0%"
	endif
	return printf("%.1f%%",(l:lp[0] * 1.0) / (l:lp[1] * 1.0) * 100 )
endfunction

let g:qfixhowmstylelistcount_bar_done = "="
let g:qfixhowmstylelistcount_bar_todo = "-"
function! BarTodo(length)
	let s:left = g:qfixhowmstylelistcount_bar_done
	let s:right = g:qfixhowmstylelistcount_bar_todo
	let l:lp = s:listProgress()
	let s:done_ratio =(l:lp[0] * 1.0 ) / (l:lp[1] * 1.0 )
	let s:bar = repeat(s:left , float2nr(a:length * s:done_ratio))
	let s:bar = s:bar . repeat(s:right,a:length-len(s:bar))
	return s:bar
endfunction

function! YankCurrentHowmFileLink()
	let @" = ">>> " . qfixhowmutils#howmFilePath("%") . "\n"
endfunction

function! AppendDiaryLinks()
	let s:time = TimeFromCurrentFileName()
	if s:time == ""
		return ""
	endif
	call append(".",BuildHowmDiaryFileLink( ShiftDate(s:time, 1) ))
	call append(".",BuildHowmDiaryFileLink( ShiftDate(s:time,-1) ))
	return ""
endfunction

function! BuildHowmDiaryFileLink(time)
	return ">>> " . qfixhowmutils#buildHowmDiaryFilePath(a:time)
endfunction

function! TimeFromCurrentFileName()
	return qfixhowmutils#getTimeFromFileName("%")
endfunction

function! ShiftDate(t,n)
	return a:t + a:n * 86400	
endfunction
