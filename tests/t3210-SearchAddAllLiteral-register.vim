" Test :SearchAddAllLiteral with register.

call vimtest#StartTap()
call vimtap#Plan(5)

let @/ = 'nil'
let @a = "one\ntwo"
SearchAddAllLiteral a
call IsPattern('nil\|one\|two', 'add simple two-line register')

let @/ = ''
let @b = "foo/bar\\too\n^anchored$\n\\<fo\\+\\|\\(g[aeiou]\\)\\1\\>\nspecial^$and.*or[~]this#%&*"
SearchAddAllLiteral b
call IsPattern('special\^\$and\.\*or\[\~]this#%&\*\|\\<fo\\+\\|\\(g\[aeiou]\\)\\1\\>\|foo/bar\\too\|\^anchored\$', 'add four regexps')

let @/ = ''
let @c = "_keyword_\n_***_\n&WORD%\n&&	%%\n_mixed%"
SearchAddAllLiteral c
call IsPattern('_keyword_\|_mixed%\|&WORD%\|_\*\*\*_\|&&	%%', 'add four keywords and WORDs')

let @e = ''
call vimtap#err#Errors('Nothing added', 'SearchAddAllLiteral e', 'error with register that is empty')

let @e = "\n\n"
call vimtap#err#Errors('Nothing added', 'SearchAddAllLiteral e', 'error with register that is just empty lines')

call vimtest#Quit()
