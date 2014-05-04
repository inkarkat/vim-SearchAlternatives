" SearchAlternatives.vim: Add / subtract alternatives from the search pattern.
"
" DEPENDENCIES:
"   - ingo/collections.vim autoload script
"   - ingo/regexp/magic.vim autoload script
"   - ingo/str.vim autoload script
"
" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.10.009	20-Jun-2013	ENH: Implement command completion that offers
"				existing alternatives (to remove or
"				clone-and-modify them).
"   1.10.008	19-Jun-2013	ENH: Blockwise <Leader>+ / <Leader>- add /
"				remove each partial selected trimmed line as a
"				separate search alternative, or individual words
"				when a single line is blockwise-selected.
"   1.01.007	24-May-2013	Move ingosearch.vim to ingo-library.
"   1.00.006	22-Mar-2012	BUG: Missing closing parenthesis caused E116.
"				FIX: Must split only on \|, but not on \\|.
"	005	08-Mar-2012	ENH: Add :SearchAdd and :SearchRemove commands.
"	004	08-Mar-2012	Rename #Add() to #AddLiteralText() and factor
"				out #AddPattern(); same for #Rem().
"				Remove unused starCommand argument.
"	003	13-Jun-2011	FIX: Directly ring the bell to avoid problems
"				when running under :silent!.
"	002	11-Jun-2011	Also account for different representations of
"				the same pattern, e.g. \V vs. individual
"				escaping, when removing an alternative. This
"				way, it is ensured that the alternative really
"				doesn't match any more. For additions, we don't
"				care, since there is no penalty when multiple
"				branches match.
"	001	10-Jun-2011	file creation
let s:save_cpo = &cpo
set cpo&vim

function! SearchAlternatives#AddPattern( searchPattern )
    if empty(@/)
	let @/ = a:searchPattern
    else
	" Check for (no)magic atoms in the existing search pattern and
	" neutralize it before appending the alternative.
	" The case-sensitivity atoms \c and \C apply to the entire pattern;
	" they cannot be neutralized. However, this can be used to do a
	" case-insensitive search for alternatives by initializing the search
	" with a pattern like /\cxyz/.
	let @/ .= ingo#regexp#magic#GetNormalizeMagicnessAtom(@/) . '\|' . a:searchPattern
    endif

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

    " Split only on \|, but not on \\|.
    return split(l:pattern, '\%(\%(^\|[^\\]\)\%(\\\\\)*\\\)\@<!\\|')
endfunction
function! SearchAlternatives#RemPattern( searchPattern )
    let l:alternatives = s:SplitIntoAlternatives(@/)
    let l:alternativesNum = len(l:alternatives)

    " We know that a:searchPattern doesn't use any atoms that change the
    " magicness, so we must only normalize the original search pattern.
    call filter(l:alternatives, 'v:val !=# a:searchPattern')
    if len(l:alternatives) == l:alternativesNum
	" The text wasn't found in the search pattern.
	return 0
    endif

    let @/ = join(l:alternatives, '\|')

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
function! s:ErrorMsg( text )
    echohl ErrorMsg
    let v:errmsg = a:text
    echomsg v:errmsg
    echohl None
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
	    call s:ErrorMsg(printf('No %d pattern found in /%s', a:patternCount, @/))
	    return
	endif
    elseif empty(a:searchPattern)
	let l:searchPattern = s:GetPattern(-1)
	if empty(l:searchPattern)
	    call s:ErrorMsg('No search pattern')
	    return
	endif
    else
	let l:searchPattern = (ingo#regexp#magic#HasMagicAtoms(a:searchPattern) ? ingo#regexp#magic#Normalize(a:searchPattern) : a:searchPattern)
    endif

    if SearchAlternatives#RemPattern(l:searchPattern)
	call s:EchoSearchPattern()
    else

	call s:ErrorMsg('Pattern not found in /' . @/)
    endif
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
