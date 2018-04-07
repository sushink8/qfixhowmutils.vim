
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
	let l:filepath = substitute(expand(a:filepath.":p"),'\\','/','g')
	let l:expanded_howm_dir = substitute(expand(g:howm_dir),'\\','/','g')
	return substitute(l:filepath,l:expanded_howm_dir,"howm://",'g')
endfunction

function! qfixhowmutils#buildTimeFromFileName(filename)
	try
		let [l:year,l:month,l:date,_] = split(expand(a:filename.":t:r"),"-")
	catch //
		return ""
	endtry
	if l:date == "00"
		let l:date = "01"
	endif
	return datelib#StrftimeCnvDoWShift(l:year,l:month,l:date,"",0)
endfunction

function! qfixhowmutils#buildMonthlyFilePath(time)
	return strftime(g:howm_dir . "/%Y/%m/%Y-%m-00-000000.txt",a:time)
endfunction

function! qfixhowmutils#shiftDate(t,n)
	return a:t + a:n * 86400	
endfunction
