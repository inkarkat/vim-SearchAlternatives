" SearchAlternatives.vim: Add / subtract alternatives from the search pattern. 
"
" DESCRIPTION:
" USAGE:
"<Leader>+		Add the current whole \<word\> as an alternative to the
"			search pattern. 
"<Leader>g+		Add the current word as an alternative to the search
"			pattern. 
"{Visual}<Leader>+	Add the current selection as an alternative to the
"			search pattern. 
"
"<Leader>-		Remove the current whole \<word\> from the alternatives
"			in the search pattern. 
"<Leader>g-		Remove the current word from the alternatives in the
"			search pattern. 
"{Visual}<Leader>-	Remove the current selection from the alternatives in
"			the search pattern. 
"
" INSTALLATION:
"   Put the script into your user or system Vim plugin directory (e.g.
"   ~/.vim/plugin). 

" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 
"   - SearchAlternatives.vim autoload script. 
"   - EchoWithoutScrolling.vim (optional). 

" CONFIGURATION:
" INTEGRATION:
" LIMITATIONS:
" ASSUMPTIONS:
" KNOWN PROBLEMS:
" TODO:
"
" Copyright: (C) 2011 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	10-Jun-2011	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_SearchAlternatives') || (v:version < 700)
    finish
endif
let g:loaded_SearchAlternatives = 1

"- integration ----------------------------------------------------------------
" Use EchoWithoutScrolling#Echo to emulate the built-in truncation of the search
" pattern (via ':set shortmess+=T'). 
silent! call EchoWithoutScrolling#MaxLength()	" Execute a function to force autoload. 
if exists('*EchoWithoutScrolling#Echo')
    cnoremap <SID>EchoSearchPatternForward  call EchoWithoutScrolling#Echo(EchoWithoutScrolling#TranslateLineBreaks('/'.@/))
    cnoremap <SID>EchoSearchPatternBackward call EchoWithoutScrolling#Echo(EchoWithoutScrolling#TranslateLineBreaks('?'.@/))
else " fallback
    cnoremap <SID>EchoSearchPatternForward  echo '/'.@/
    cnoremap <SID>EchoSearchPatternBackward echo '?'.@/
endif


nnoremap <script> <Plug>SearchAlternativesAdd  :<C-U>call SearchAlternatives#Add( '*',expand('<cword>'),1)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>
nnoremap <script> <Plug>SearchAlternativesRem  :<C-U>call SearchAlternatives#Rem( '*',expand('<cword>'),1)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>
nnoremap <script> <Plug>SearchAlternativesGAdd :<C-U>call SearchAlternatives#Add('g*',expand('<cword>'),0)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>
nnoremap <script> <Plug>SearchAlternativesGRem :<C-U>call SearchAlternatives#Rem('g*',expand('<cword>'),0)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<CR>
" gV avoids automatic re-selection of the Visual area in select mode. 
vnoremap <script> <Plug>SearchAlternativesAdd  :<C-U>let save_cb=&cb<Bar>let save_reg=getreg('"')<Bar>let save_regtype=getregtype('"')<Bar>execute 'silent normal! gvy'<Bar>call SearchAlternatives#Add('gv*',@",0)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<Bar>call setreg('"', save_reg, save_regtype)<Bar>let &cb=save_cb<Bar>unlet save_cb<Bar>unlet save_reg<Bar>unlet save_regtype<CR>gV
vnoremap <script> <Plug>SearchAlternativesRem  :<C-U>let save_cb=&cb<Bar>let save_reg=getreg('"')<Bar>let save_regtype=getregtype('"')<Bar>execute 'silent normal! gvy'<Bar>call SearchAlternatives#Rem('gv*',@",0)<Bar>if &hlsearch<Bar>set hlsearch<Bar>endif<Bar><SID>EchoSearchPatternForward<Bar>call setreg('"', save_reg, save_regtype)<Bar>let &cb=save_cb<Bar>unlet save_cb<Bar>unlet save_reg<Bar>unlet save_regtype<CR>gV

if ! hasmapto('<Plug>SearchAlternativesAdd', 'n')
    nmap <silent> <Leader>+ <Plug>SearchAlternativesAdd
endif
if ! hasmapto('<Plug>SearchAlternativesGAdd', 'n')
    nmap <silent> <Leader>g+ <Plug>SearchAlternativesGAdd
endif
if ! hasmapto('<Plug>SearchAlternativesAdd', 'x')
    xmap <silent> <Leader>+ <Plug>SearchAlternativesAdd
endif
if ! hasmapto('<Plug>SearchAlternativesRem', 'n')
    nmap <silent> <Leader>- <Plug>SearchAlternativesRem
endif
if ! hasmapto('<Plug>SearchAlternativesGRem', 'n')
    nmap <silent> <Leader>g- <Plug>SearchAlternativesGRem
endif
if ! hasmapto('<Plug>SearchAlternativesRem', 'x')
    xmap <silent> <Leader>- <Plug>SearchAlternativesRem
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
