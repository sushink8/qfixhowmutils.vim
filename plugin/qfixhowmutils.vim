

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
	let l:left = g:qfixhowmstylelistcount_bar_done
	let l:right = g:qfixhowmstylelistcount_bar_todo
	let l:lp = s:listProgress()
	let l:done_ratio =(l:lp[0] * 1.0 ) / (l:lp[1] * 1.0 )
	let l:bar = repeat(l:left , float2nr(a:length * l:done_ratio))
	let l:bar = l:bar . repeat(l:right,a:length-len(l:bar))
	return l:bar
endfunction

function! YankCurrentHowmFileLink()
	let @" = ">>> " . qfixhowmutils#howmFilePath("%") . "\n"
endfunction

function! AppendDiaryLinks()
	let l:time = TimeFromCurrentFileName()
	if l:time == ""
		return ""
	endif
	call append(".",
		\[BuildHowmDiaryFileLink( qfixhowmutils#shiftDate(l:time,-1) ),
		\ BuildHowmDiaryFileLink( qfixhowmutils#shiftDate(l:time, 1) )
		\])
	return ""
endfunction

function! AppendMonthlyLinks()
	let l:time = TimeFromCurrentFileName()
	" TODO
endfunction

function! BuildHowmDiaryFileLink(time)
	return ">>> " . qfixhowmutils#buildHowmDiaryFilePath(a:time)
endfunction

function! TimeFromCurrentFileName()
	return qfixhowmutils#buildTimeFromFileName("%")
endfunction

function! MonthlyFile()
	execute "edit " . qfixhowmutils#buildMonthlyFilePath(localtime())
endfunction
