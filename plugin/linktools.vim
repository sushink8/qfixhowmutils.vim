
function! YankCurrentHowmFileLink(...)
	let s:prefix = ""
	if a:0 > 0
		let s:prefix = a:1 . " "
	endif
	let @" = s:prefix . qfixhowmutils#howmFilePath("%") . "\n"
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

function! DiaryLinkByDate( date )
	let l:time = qfixhowmutils#buildTimeFromDate(a:date)
	if l:time == ""
		echoerr "invalid date."
	endif
	let l:link = BuildHowmDiaryFileLink( l:time )
	echo l:link
	let @" = l:link
endfunction

function! BuildMonthlyLinks()
	let l:time = TimeFromCurrentFileName()
	if l:time == ""
		return ""
	endif
	return qfixhowmutils#buildHowmMonthlyFilePath(l:time)
endfunction

function! BuildHowmDiaryFileLink(time)
	return qfixhowmutils#buildHowmDiaryFilePath(a:time)
endfunction

function! AppendMonthlyIndexes()
	let l:time = TimeFromCurrentFileName()
	if l:time == ""
		return ""
	endif
	let [ l:y , l:m ,l:_d ] = qfixhowmutils#Int2Date( l:time )
	let l:links = [ BuildMonthlyLinks() ]
	for l:d in range(1,31)
		let l:d_int = datelib#Date2IntStrftime( l:y , l:m , l:d ) * 24 * 60 * 60
		let [l:y2 , l:m2 , l:d2 ] = qfixhowmutils#Int2Date( l:d_int )
		if l:y != l:y2 || l:m != l:m2
			break
		endif
		call add(l:links, BuildHowmDiaryFileLink( l:d_int ))
	endfor
	call append(".", l:links)
endfunction
