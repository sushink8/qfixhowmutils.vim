

function! EditPrevDiary()
	let l:time = qfixhowmutils#shiftDate( qfixhowmutils#buildTimeFromFileName("%") , -1 )
	let l:filename = qfixhowmutils#buildHowmDiaryFilePathFromRoot(l:time)
	echo l:filename
	call qfixmemo#EditDiary( l:filename )
endfunction

function! EditNextDiary()
	let l:time = qfixhowmutils#shiftDate( qfixhowmutils#buildTimeFromFileName("%") , 1 )
	let l:filename = qfixhowmutils#buildHowmDiaryFilePathFromRoot(l:time)
	echo l:filename
	call qfixmemo#EditDiary( l:filename )
endfunction


function! TimeFromCurrentFileName()
	return qfixhowmutils#buildTimeFromFileName("%")
endfunction

function! MonthlyFile()
	execute "edit " . qfixhowmutils#buildMonthlyFilePath(localtime())
endfunction

function! QFixMRUAltOpen(sq,basedir)
	let sq = a:sq
	if g:QFixMRU_MultiEntryPerFile
		let fdict = {}
		for d in sq
			let fdict[d.filename] = d
		endfor
		let qflist = []
		for f in keys(fdict)
			call add(qflist,fdict[f])
		endfor
		call QFixMRUOpen(qflist,a:basedir)
	else
		call QFixMRUOpen(sq,a:basedir)
	endif
	if len(sq) == 0
		redraw|echo 'QFixMRUAltOpen: No mur list'
	endif
endfunction
