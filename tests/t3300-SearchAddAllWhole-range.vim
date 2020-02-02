" Test :SearchAddAllWhole with ranges.

view list.txt

call vimtest#StartTap()
call vimtap#Plan(5)

let @/ = 'nil'
1,2SearchAddAllWhole
call IsPattern('nil\|\<one\>\|\<two\>', 'add simple two-line range')

let @/ = ''
4,5SearchAddAllWhole
call IsPattern('\<trailing ws	    \|	    leading ws\>', 'keeps leading and trailing whitespace')

let @/ = ''
8,11SearchAddAllWhole
call IsPattern('\<special\^\$and\.\*or\[\~]this#%&\*\%(\s\|$\)\@=\|\%(^\|\s\)\@<=\\<fo\\+\\|\\(g\[aeiou]\\)\\1\\>\%(\s\|$\)\@=\|\<foo/bar\\too\>\|\%(^\|\s\)\@<=\^anchored\$\%(\s\|$\)\@=', 'add four regexps')

let @/ = ''
17,$SearchAddAllWhole
call IsPattern('\<_keyword_\>\|\<_mixed%\%(\s\|$\)\@=\|\%(^\|\s\)\@<=&WORD%\%(\s\|$\)\@=\|\<_\*\*\*_\>\|\%(^\|\s\)\@<=&&	%%\%(\s\|$\)\@=', 'add four keywords and WORDs')

call vimtap#err#Errors('Nothing added', '6,7SearchAddAllWhole', 'error with range that is just empty lines')

call vimtest#Quit()
