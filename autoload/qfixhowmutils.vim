
function! qfixhowmutils#count(reg)
  let l:lines = getline(0,"$")
  let l:c = 0
	" echo a:reg
  for line in lines
    if match(line,a:reg) >= 0
      let l:c = l:c + 1
    endif 
  endfor
  return l:c
endfunction

function! qfixhowmutils#buildHowmDiaryFilePath(time)
	return strftime("howm://" . g:QFixHowm_DiaryFile ,a:time)
endfunction

function! qfixhowmutils#howmFilePath(filepath)
	let s:filepath = substitute(expand(a:filepath.":p"),'\\','/','g')
	let s:expanded_howm_dir = substitute(expand(g:howm_dir),'\\','/','g')
	return substitute(s:filepath,s:expanded_howm_dir,"howm://",'g')
endfunction

function! qfixhowmutils#getTimeFromFileName(filename)
	try
		let [s:year,s:month,s:date,_] = split(expand(a:filename.":t:r"),"-")
	catch //
		return ""
	endtry
	return datelib#StrftimeCnvDoWShift(s:year,s:month,s:date,"",0)
endfunction
