" SearchAlternatives.vim: Add / subtract alternatives to / from the search pattern.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ingo-library.vim plugin

" Copyright: (C) 2011-2020 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

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
command! -count -nargs=? -complete=customlist,SearchAlternatives#Complete SearchRemove   if ! SearchAlternatives#RemCommand(<count>, <q-args>) | echoerr ingo#err#Get() | endif

if v:version < 702 | runtime autoload/SearchAlternatives/All.vim | runtime autoload/ingo/funcref.vim | endif  " The Funcref doesn't trigger the autoload in older Vim versions.
command! -range=-1 -nargs=? SearchAddAllLiteral if ! SearchAlternatives#All#Add('ingo#regexp#EscapeLiteralText', <count> != -1, <line1>, <line2>, <q-args>) | echoerr ingo#err#Get() | endif
command! -range=-1 -nargs=? SearchAddAllWhole   if ! SearchAlternatives#All#Add('SearchAlternatives#All#Whole',  <count> != -1, <line1>, <line2>, <q-args>) | echoerr ingo#err#Get() | endif
command! -range=-1 -nargs=? SearchAddAllPattern if ! SearchAlternatives#All#Add('ingo#funcref#UnaryIdentity',    <count> != -1, <line1>, <line2>, <q-args>) | echoerr ingo#err#Get() | endif


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
