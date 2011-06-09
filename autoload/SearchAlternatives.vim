" SearchAlternatives.vim: Add / subtract alternatives from the search pattern. 
"
" DEPENDENCIES:
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	10-Jun-2011	file creation

function! SearchAlternatives#Add( starCommand, text, isWholeWordSearch )
    let l:searchPattern = ingosearch#LiteralTextToSearchPattern( a:text, a:isWholeWordSearch, '/' )

    if empty(@/)
	let @/ = l:searchPattern
    else
	" Check for (no)magic atoms in the existing search pattern and
	" neutralize it before appending the alternative. 
	" The case-sensitivity atoms \c and \C apply to the entire pattern;
	" they cannot be neutralized. However, this can be used to do a
	" case-insensitive search for alternatives by initializing the search
	" with a pattern like /\cxyz/. 
	let @/ .= ingosearch#NormalizeMagicness(@/) . '\|' . l:searchPattern
    endif

    " The search pattern is added to the search history, as '/' or '*' would do. 
    call histadd('/', @/)
endfunction

function! SearchAlternatives#Rem( starCommand, text, isWholeWordSearch )
    let l:searchPattern = ingosearch#LiteralTextToSearchPattern( a:text, a:isWholeWordSearch, '/' )

    let l:alternatives = split(@/, '\\|')
    let l:alternativesNum = len(l:alternatives)

    " TODO: Account for different representations of the same pattern, e.g. \V
    " vs. escaping. 
    call filter(l:alternatives, 'v:val !=# l:searchPattern')
    if len(l:alternatives) == l:alternativesNum
	" The text wasn't found in the search pattern; inform the user via a
	" bell. 
	execute "normal \<Plug>RingTheBell" 
	return
    endif

    let @/ = join(l:alternatives, '\|')

    " The search pattern is added to the search history, as '/' or '*' would do. 
    call histadd('/', @/)
endfunction

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
