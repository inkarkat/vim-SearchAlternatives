" SearchAlternatives/All.vim: Add all lines from a range or register.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

function! SearchAlternatives#All#Add( Escaper, hasRange, startLnum, endLnum, arguments ) abort
    if a:hasRange
	let [l:startLnum, l:endLnum] = [ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum)]
	let l:patterns = getline(l:startLnum, l:endLnum)
    else
	let l:patterns = split(getreg(a:arguments), '\n')
    endif

    let l:patterns = ingo#list#NonEmpty(l:patterns)
    if empty(l:patterns)
	call ingo#err#Set('Nothing added')
	return 0
    endif

    for l:pattern in l:patterns
	call SearchAlternatives#AddPattern(l:pattern)
    endfor
    return 1
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
