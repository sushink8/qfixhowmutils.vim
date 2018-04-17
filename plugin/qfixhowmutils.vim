


function! CountTodo()
	let l:lp = qfixhowmutils#listProgress(getline(0,"$"))
	return l:lp[0] . "/" . l:lp[1]
endfunction

function! PercentageTodo()
	let l:lp = qfixhowmutils#listProgress(getline(0,"$"))
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
	let l:lp = qfixhowmutils#listProgress(getline(0,"$"))
	let l:done_ratio =(l:lp[0] * 1.0 ) / (l:lp[1] * 1.0 )
	let l:bar = repeat(l:left , float2nr(a:length * l:done_ratio))
	let l:bar = l:bar . repeat(l:right,a:length-len(l:bar))
	return l:bar
endfunction

function! CountInCurDir()
	let files = split(glob("./*"),"\n")
	for l:filepath in l:files
		if !filereadable(l:filepath)
			continue	
		endif
		echo l:filepath qfixhowmutils#listProgress(readfile(l:filepath))
	endfor

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
