
function! qfixhowmutils#countInDir(dir,displayfunction)
	let files = split(glob(a:dir."/*"),"\n")
	let ret = []
	for l:filepath in l:files
		if !filereadable(l:filepath)
			continue
		endif
		echo l:filepath a:displayfunction(qfixhowmutils#listProgress(readfile(l:filepath)))
		let ret += [ l:filepath . " " . a:displayfunction(qfixhowmutils#listProgress(readfile(l:filepath))) ]
	endfor
	return ret
endfunction

function! qfixhowmutils#showProgress(dir,displayfunction,file,hiddencomplete)
	let l:qflist = qfixlist#grep("{.}",a:dir,a:file)
	let l:files = {}
	let l:qflist2 = []
	for i in l:qflist
		let files[i.filename] = ""
	endfor
	for fpath in keys(l:files)
		let l:path = fnamemodify(fpath,":p")
		if !filereadable(l:path)
			continue
		endif
		let [l:comp,l:all] = qfixhowmutils#listProgress(readfile(l:path))
		if a:hiddencomplete && l:comp == l:all
			continue	
		endif
		let result = a:displayfunction([l:comp,l:all])
		call add(l:qflist2,{'filename':fpath,'lnum':1,'text':result})
	endfor
	call qfixlist#copen(l:qflist2,g:qfixmemo_dir)
endfunction



function! qfixhowmutils#percentageTodo(progress)
	let l:comp = a:progress[0]
	let l:all = a:progress[1]
	if l:all <= 0
		return "0%"
	endif
	return printf("%.1f%%",(l:comp * 1.0) / (l:all * 1.0) * 100 )
endfunction

function! qfixhowmutils#countTodo(progress)
	let l:comp = a:progress[0]
	let l:all = a:progress[1]
	return printf("%d/%d",l:comp,l:all)
endfunction

function! qfixhowmutils#countRegexCurrentFile(regex)
	return qfixhowmutils#countRegex(getline(0,"$"),a:regex)
endfunction


function! qfixhowmutils#countRegex(lines,regex)
	let l:c = 0
	for line in a:lines
		if match(line,a:regex) >= 0
			let l:c = l:c + 1
		endif
	endfor
	return l:c
endfunction

function! qfixhowmutils#buildHowmDiaryFilePath(time)
	return strftime("howm://" . g:QFixHowm_DiaryFile ,a:time)
endfunction

function! qfixhowmutils#buildHowmMonthlyFilePath(time)
	if !exists('g:QFixHowm_MonthlyFile')
		let g:QFixHowm_MonthlyFile = substitute( g:QFixHowm_DiaryFile , "%d" , "00" , "g" )
	endif
	return strftime("howm://" . g:QFixHowm_MonthlyFile , a:time )
endfunction

function! qfixhowmutils#howmFilePath(filepath)
	let l:filepath = substitute(expand(a:filepath.":p"),'\\','/','g')
	let l:expanded_howm_dir = substitute(expand(g:howm_dir),'\\','/','g')
	return substitute(l:filepath,l:expanded_howm_dir,"howm:/",'g')
endfunction

function! qfixhowmutils#buildTimeFromDate(date)
	try
		let l:match = matchstr( a:date ,'\d\{4\}-\d\d-\d\d' ,0)
		if l:match == ""
			return ""
		endif
		let [ l:year , l:month , l:date ] = split( l:match , "-" )
	catch //
		echoerr v:exception
		return ""
	endtry
	return datelib#StrftimeCnvDoWShift(l:year,l:month,l:date,"",0)	
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

function! qfixhowmutils#dateByHowmFileName(path,sep)
	let l:basename = fnamemodify(a:path,":t")
	let [l:y , l:m , l:d , l:s ] = split(l:basename , "-")
	return printf("%s%s%s%s%s",l:y, a:sep, l:m, a:sep, l:d)
endfunction

function! qfixhowmutils#Int2Date(int)
	return split( strftime( "%Y-%m-%d" , a:int ) , "-" )
endfunction

function! qfixhowmutils#listProgress(lines)
	let lines = a:lines
	let l:count_all_list = qfixhowmutils#countRegex(lines,'^\s*[-*]\?\s*{.}\|{.}\s*$')
	let l:count_complete_list = qfixhowmutils#countRegex(lines,'^\s*[-*]\?\s*{[^ ]}\|{[^ ]}\s*$')
	return [l:count_complete_list , l:count_all_list]
endfunction

function! qfixhowmutils#bufopen(path)
	let path = a:path
	silent! execute ':args ' . path
endfunction

function! qfixhowmutils#globalRename()
    let l:from = substitute( fnamemodify(expand('%'), ':p' ), '\\','/','g')
    while 1
        let l:to = input('Rename to : ' , l:from )
        if l:to == ''
            return
        endif
        "let l:to = substitute(l:to, '[/:*?"<>|\\]', '_', 'g')
        let l:to = substitute(l:to, '[*?"<>|]', '_', 'g')
        let l:to = substitute(l:to, '^\s*\|\s*$', '', 'g')
        if l:to !~ '\.' . fnamemodify(l:from, ':e')
            let l:to = l:to .  '.' . fnamemodify(l:from, ':e')
        endif
        if  filereadable( l:to )
            let l:mes = printf( '"%s" already exists.' , l:to )
            let l:choice = confirm( l:mes , "&Input name\n&Overwrite\n&Cancel",1,"Q")
            if l:choice == 1
                let l:to = ''
                continue
            elseif choice != 2
                return
            else
                break
            endif
        else
            break
        endif
    endwhile
    update
    call rename(l:from,l:to)
    
    " @@@ ここから下
    " WIndowsのパスをhowmのパスに変換する関数が欲しい
    let qf = map( split( glob(howm_dir . "/**/*.txt") , "\n" ) , { key,val -> { "filename" : val , "lnum" : 1 , "text" : val , "col" : 1 } } )
    call setqfixlist(fq)
    let s:bufn = bufnr("%")
    execute "cfdo %s/" . l:from . "/" . l:to . "/ge | update"
    execute "buffer " . bufn

endfunction

