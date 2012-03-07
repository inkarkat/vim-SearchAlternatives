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
function! SearchAlternatives#AddLiteralText( text, isWholeWordSearch )
    call SearchAlternatives#AddPattern(ingosearch#LiteralTextToSearchPattern( a:text, a:isWholeWordSearch, '/')
endfunction

function! SearchAlternatives#RemPattern( searchPattern )

    let l:currentSearchPattern = @/
    if ingosearch#HasMagicAtoms(l:currentSearchPattern)
	" Also account for different representations of the same pattern, e.g. \V
	" vs. individual escaping. We know that a:searchPattern doesn't use any
	" atoms that change the magicness, so we must only normalize the original
	" search pattern.
	let l:currentSearchPattern = ingosearch#NormalizeMagicness(l:currentSearchPattern)
    endif

    let l:alternatives = split(l:currentSearchPattern, '\\|')
    let l:alternativesNum = len(l:alternatives)

    call filter(l:alternatives, 'v:val !=# a:searchPattern')
    if len(l:alternatives) == l:alternativesNum
	" The text wasn't found in the search pattern; inform the user via a
	" bell.
	execute "normal! \<C-\>\<C-n>\<Esc>"
	return
    endif

    let @/ = join(l:alternatives, '\|')

    " The search pattern is added to the search history, as '/' or '*' would do.
    call histadd('/', @/)
endfunction
function! SearchAlternatives#RemLiteralText( text, isWholeWordSearch )
    call SearchAlternatives#RemPattern(ingosearch#LiteralTextToSearchPattern( a:text, a:isWholeWordSearch, '/' ))
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
