" SearchAlternatives/All.vim: Add all lines from a range or register.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! SearchAlternatives#All#Add( Escaper, hasRange, startLnum, endLnum, arguments ) abort
    let [l:register, l:rest] = ingo#cmdargs#register#ParsePrependedWritableRegister(a:arguments, [], 0)
    if a:hasRange
	if ! empty(l:register)
	    call ingo#err#Set('Cannot pass both range and register')
	    return 0
	endif

	let [l:startLnum, l:endLnum] = [ingo#range#NetStart(a:startLnum), ingo#range#NetEnd(a:endLnum)]
	let l:patterns = getline(l:startLnum, l:endLnum)
    else
	let l:patterns = split(getreg(l:register), '\n')
    endif

    if ! empty(l:rest)
	let [l:separator, l:pattern, l:replacement, l:flags] = ingo#cmdargs#substitute#Parse(l:rest, {
	\   'flagsExpr': '\(g\)\?', 'emptyReplacement': '', 'emptyFlags': '', 'isAllowLoneFlags': 0
	\})
	let l:pattern = ingo#escape#Unescape(l:pattern, l:separator)
	let l:hasReplacement = (! empty(l:replacement) || l:rest =~# '\V' . escape(l:separator . l:separator . l:flags, '\') . '\$')
	if l:hasReplacement
	    let l:replacement = ingo#escape#Unescape(l:replacement, l:separator)
	    call map(l:patterns, 'substitute(v:val, l:pattern, l:replacement, l:flags)')
	else
	    call map(l:patterns, 'matchstr(v:val, l:pattern)')
	endif
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

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
