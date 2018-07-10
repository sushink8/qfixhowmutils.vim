
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
