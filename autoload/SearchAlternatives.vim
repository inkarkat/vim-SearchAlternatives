" SearchAlternatives.vim: Add / subtract alternatives from the search pattern.
"
" DEPENDENCIES:
"   - ingo-library.vim plugin
"
" Copyright: (C) 2011-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! SearchAlternatives#AddPattern( searchPattern )
    if empty(@/)
	let l:newSearchPattern = a:searchPattern
    else
	let l:newSearchPattern = join(
	\   ingo#regexp#split#AddPatternByProjectedMatchLength(
	\       s:SplitIntoAlternatives(@/),
	\       ingo#regexp#magic#Normalize(a:searchPattern)
	\   ), '\|'
	\)
	" s:SplitIntoAlternatives() already normalizes the existing search
	" pattern; do the same for a:searchPattern here.
	" The case-sensitivity atoms \c and \C apply to the entire pattern;
	" they cannot be neutralized. However, this can be used to do a
	" case-insensitive search for alternatives by initializing the search
	" with a pattern like /\cxyz/.
    endif

    " Make global flags unique and put them to the front of the search pattern
    " by splitting and re-joining.
    let @/ = join(ingo#regexp#split#GlobalFlags(l:newSearchPattern), '')

    " The search pattern is added to the search history, as '/' or '*' would do.
    call histadd('/', @/)
endfunction
function! s:SplitIntoAlternatives( pattern )
    let l:pattern = a:pattern
    if ingo#regexp#magic#HasMagicAtoms(l:pattern)
	" Also account for different representations of the same pattern, e.g.
	" \V vs. individual escaping.
	let l:pattern = ingo#regexp#magic#Normalize(l:pattern)
    endif

    return ingo#regexp#split#TopLevelBranches(l:pattern)
endfunction
function! SearchAlternatives#RemPattern( searchPattern )
    let [l:engineTypeFlag, l:caseSensitivityFlag, l:purePattern] = ingo#regexp#split#GlobalFlags(@/)
    let l:alternatives = s:SplitIntoAlternatives(l:purePattern)
    let l:alternativesNum = len(l:alternatives)

    call filter(l:alternatives, 'v:val !=# ' . string(ingo#regexp#split#GlobalFlags(ingo#regexp#magic#Normalize(a:searchPattern))[-1]))
    if len(l:alternatives) == l:alternativesNum
	" The text wasn't found in the search pattern.
	return 0
    endif

    let @/ = l:engineTypeFlag . l:caseSensitivityFlag . join(l:alternatives, '\|')

    " The search pattern is added to the search history, as '/' or '*' would do.
    call histadd('/', @/)

    return 1
endfunction

function! s:TrimmedLines( text )
    return ingo#collections#UniqueStable(
    \   filter(
    \       map(split(a:text, '\n'), 'ingo#str#Trim(v:val)'),
    \       '! empty(v:val)'
    \   )
    \)
endfunction
function! s:IsFirstSelectedLineSurroundedByNonKeywords()
    return search('\%' . line("'<") . 'l\%(^\|\%(\k\@!.\)\)\s*\%' . col("'<") . 'c.*\%V.\%($\|\%V\@!\%(\k\@!.\)\)', 'bcnW')
endfunction
function! SearchAlternatives#AddLiteralText( text, mode, isWholeWordSearch )
    if a:mode ==# "\<C-v>"
	if a:text =~# '\n'
	    for l:line in s:TrimmedLines(a:text)
		call SearchAlternatives#AddPattern(ingo#regexp#FromLiteralText(l:line, s:IsFirstSelectedLineSurroundedByNonKeywords(), '/'))
	    endfor
	else
	    for l:word in split(a:text, '\s\+')
		call SearchAlternatives#AddPattern(ingo#regexp#FromLiteralText(l:word, 1, '/'))
	    endfor
	endif
    else
	call SearchAlternatives#AddPattern(ingo#regexp#FromLiteralText(a:text, a:isWholeWordSearch, '/'))
    endif
endfunction
function! SearchAlternatives#RemLiteralText( text, mode, isWholeWordSearch )
    if a:mode ==# "\<C-v>"
	let l:success = 0
	if a:text =~# '\n'
	    for l:line in s:TrimmedLines(a:text)
		if SearchAlternatives#RemPattern(ingo#regexp#FromLiteralText(l:line, s:IsFirstSelectedLineSurroundedByNonKeywords(), '/'))
		    let l:success = 1
		endif
	    endfor
	else
	    for l:word in split(a:text, '\s\+')
		if SearchAlternatives#RemPattern(ingo#regexp#FromLiteralText(l:word, 1, '/'))
		    let l:success = 1
		endif
	    endfor
	endif
    else
	let l:success = SearchAlternatives#RemPattern(ingo#regexp#FromLiteralText(a:text, a:isWholeWordSearch, '/'))
    endif

    if ! l:success
	" The text wasn't found in the search pattern; inform the user via a
	" bell.
	execute "normal! \<C-\>\<C-n>\<Esc>"
    endif
endfunction

function! s:GetPattern( patternIndex )
    return get(s:SplitIntoAlternatives(@/), a:patternIndex, '')
endfunction
function! s:EchoSearchPattern()
    " Note: We do not use the ingo#avoidprompt#Echo function, because for an Ex
    " command, it makes more sense to show the entire pattern, even if it causes
    " the hit-enter prompt. (The user has just acknowledged the command-line via
    " <CR> anyhow.)
    echo '/'.@/
endfunction
function! SearchAlternatives#AddCommand( searchPattern )
    call SearchAlternatives#AddPattern(a:searchPattern)
    call s:EchoSearchPattern()
endfunction
function! SearchAlternatives#RemCommand( patternCount, searchPattern )
    if a:patternCount > 1
	let l:searchPattern = s:GetPattern(a:patternCount - 1)
	if empty(l:searchPattern)
	    call ingo#err#Set(printf('No %d pattern found in /%s', a:patternCount, @/))
	    return 0
	endif
    elseif empty(a:searchPattern)
	let l:searchPattern = s:GetPattern(-1)
	if empty(l:searchPattern)
	    call ingo#err#Set('No search pattern')
	    return 0
	endif
    else
	let l:searchPattern = (ingo#regexp#magic#HasMagicAtoms(a:searchPattern) ? ingo#regexp#magic#Normalize(a:searchPattern) : a:searchPattern)
    endif

    if SearchAlternatives#RemPattern(l:searchPattern)
	call s:EchoSearchPattern()
    else

	call ingo#err#Set('Pattern not found in /' . @/)
	return 0
    endif

    return 1
endfunction


function! SearchAlternatives#Complete( ArgLead, CmdLine, CursorPos )
    " Filter the individual alternatives according to the argument lead. Allow
    " to omit the frequent initial \< atom in the lead.
    return filter(
    \	ingo#collections#UniqueStable(s:SplitIntoAlternatives(@/)),
    \	"v:val =~ '^\\%(\\\\<\\)\\?\\V' . " . string(escape(a:ArgLead, '\'))
    \)
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
