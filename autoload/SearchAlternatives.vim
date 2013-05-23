" SearchAlternatives.vim: Add / subtract alternatives from the search pattern.
"
" DEPENDENCIES:
"   - ingosearch.vim autoload script.
"
" Copyright: (C) 2011-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
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
	let @/ .= ingosearch#GetNormalizeMagicnessAtom(@/) . '\|' . a:searchPattern
    endif

    " The search pattern is added to the search history, as '/' or '*' would do.
    call histadd('/', @/)
endfunction
function! s:SplitIntoAlternatives( pattern )
    let l:pattern = a:pattern
    if ingosearch#HasMagicAtoms(l:pattern)
	" Also account for different representations of the same pattern, e.g.
	" \V vs. individual escaping.
	let l:pattern = ingosearch#NormalizeMagicness(l:pattern)
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

function! SearchAlternatives#AddLiteralText( text, isWholeWordSearch )
    call SearchAlternatives#AddPattern(ingosearch#LiteralTextToSearchPattern( a:text, a:isWholeWordSearch, '/'))
endfunction
function! SearchAlternatives#RemLiteralText( text, isWholeWordSearch )
    if ! SearchAlternatives#RemPattern(ingosearch#LiteralTextToSearchPattern( a:text, a:isWholeWordSearch, '/' ))
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
    " Note: We do not use the EchoWithoutScrolling#Echo function even if
    " available, because for an Ex command, it makes more sense to show the
    " entire pattern, even if it causes the hit-enter prompt. (The user has just
    " acknowledged the command-line via <CR> anyhow.)
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
	let l:searchPattern = (ingosearch#HasMagicAtoms(a:searchPattern) ? ingosearch#NormalizeMagicness(a:searchPattern) : a:searchPattern)
    endif

    if SearchAlternatives#RemPattern(l:searchPattern)
	call s:EchoSearchPattern()
    else

	call s:ErrorMsg('Pattern not found in /' . @/)
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
