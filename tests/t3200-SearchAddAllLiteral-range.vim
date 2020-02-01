" Test :SearchAddAllLiteral with ranges.

view list.txt

call vimtest#StartTap()
call vimtap#Plan(5)

let @/ = 'nil'
1,2SearchAddAllLiteral
call IsPattern('nil\|one\|two', 'add simple two-line range')

let @/ = ''
4,5SearchAddAllLiteral
call IsPattern('trailing ws	    \|	    leading ws', 'keeps leading and trailing whitespace')

let @/ = ''
8,11SearchAddAllLiteral
call IsPattern('special\^\$and\.\*or\[\~]this#%&\*\|\\<fo\\+\\|\\(g\[aeiou]\\)\\1\\>\|foo/bar\\too\|\^anchored\$', 'add four regexps')

let @/ = ''
17,$SearchAddAllLiteral
call IsPattern('_keyword_\|_mixed%\|&WORD%\|_\*\*\*_\|&&	%%', 'add four keywords and WORDs')

call vimtap#err#Errors('Nothing added', '6,7SearchAddAllLiteral', 'error with range that is just empty lines')

call vimtest#Quit()
