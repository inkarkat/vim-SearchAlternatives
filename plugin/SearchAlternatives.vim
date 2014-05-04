" SearchAlternatives.vim: Add / subtract alternatives to / from the search pattern.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ingo/avoidprompt.vim autoload script
"   - ingo/selection.vim autoload script
"   - SearchAlternatives.vim autoload script

" Copyright: (C) 2011-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.10.010	20-Jun-2013	ENH: Implement command completion that offers
"				existing alternatives (to remove or
"				clone-and-modify them).
"   1.10.009	19-Jun-2013	ENH: Blockwise <Leader>+ / <Leader>- add /
"				remove each partial selected trimmed line as a
"				separate search alternative.
"   1.01.008	07-Jun-2013	Move EchoWithoutScrolling.vim into ingo-library.
"   1.01.007	24-May-2013	Move ingointegration#GetVisualSelection() into
"				ingo-library.
"   1.01.006	05-Nov-2012	Remove -complete=expression; it's not useful for
"				completing regexp patterns.
"   1.00.005	08-Mar-2012	ENH: Add :SearchAdd and :SearchRemove commands.
"	004	08-Mar-2012	Rename #Add() to #AddLiteralText() and factor
"				out #AddPattern(); same for #Rem().
"				Remove unused starCommand argument.
"	003	30-Sep-2011	Use <silent> for <Plug> mapping instead of
"				default mapping.
"	002	12-Sep-2011	Use ingointegration#GetVisualSelection() instead
"				of inline capture.
"	001	10-Jun-2011	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_SearchAlternatives') || (v:version < 700)
    finish
endif
let g:loaded_SearchAlternatives = 1

"- integration ----------------------------------------------------------------

" Use ingo#avoidprompt#EchoAsSingleLine() to emulate the built-in truncation of
" the search pattern (via ':set shortmess+=T').
cnoremap <SID>EchoSearchPatternForward  call ingo#avoidprompt#EchoAsSingleLine('/'.@/)


"- commands --------------------------------------------------------------------

command!        -nargs=1 -complete=customlist,SearchAlternatives#Complete SearchAdd      call SearchAlternatives#AddCommand(<q-args>)
command! -count -nargs=? -complete=customlist,SearchAlternatives#Complete SearchRemove   call SearchAlternatives#RemCommand(<count>, <q-args>)


"- mappings --------------------------------------------------------------------

nnoremap <script> <silent> <Plug>SearchAlternativesAdd  :<C-U>call SearchAlternatives#AddLiteralText(expand('<cword>'), '', 1)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>
nnoremap <script> <silent> <Plug>SearchAlternativesRem  :<C-U>call SearchAlternatives#RemLiteralText(expand('<cword>'), '', 1)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>
nnoremap <script> <silent> <Plug>SearchAlternativesGAdd :<C-U>call SearchAlternatives#AddLiteralText(expand('<cword>'), '', 0)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>
nnoremap <script> <silent> <Plug>SearchAlternativesGRem :<C-U>call SearchAlternatives#RemLiteralText(expand('<cword>'), '', 0)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>
" gV avoids automatic re-selection of the Visual area in select mode.
vnoremap <script> <silent> <Plug>SearchAlternativesAdd  :<C-U>call SearchAlternatives#AddLiteralText(ingo#selection#Get(), visualmode(), 0)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>gV
vnoremap <script> <silent> <Plug>SearchAlternativesRem  :<C-U>call SearchAlternatives#RemLiteralText(ingo#selection#Get(), visualmode(), 0)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>gV

if ! hasmapto('<Plug>SearchAlternativesAdd', 'n')
    nmap <Leader>+ <Plug>SearchAlternativesAdd
endif
if ! hasmapto('<Plug>SearchAlternativesGAdd', 'n')
    nmap <Leader>g+ <Plug>SearchAlternativesGAdd
endif
if ! hasmapto('<Plug>SearchAlternativesAdd', 'x')
    xmap <Leader>+ <Plug>SearchAlternativesAdd
endif
if ! hasmapto('<Plug>SearchAlternativesRem', 'n')
    nmap <Leader>- <Plug>SearchAlternativesRem
endif
if ! hasmapto('<Plug>SearchAlternativesGRem', 'n')
    nmap <Leader>g- <Plug>SearchAlternativesGRem
endif
if ! hasmapto('<Plug>SearchAlternativesRem', 'x')
    xmap <Leader>- <Plug>SearchAlternativesRem
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
