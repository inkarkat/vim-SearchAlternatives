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

    " TODO: Check for (no)magic and case-sensitivity atoms. 
    let @/ .= (empty(@/) ? '' : '\|') . l:searchPattern

    " The search pattern is added to the search history, as '/' or '*' would do. 
    call histadd('/', @/)
endfunction

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
