" Test :SearchAddAllWhole with register.

call vimtest#StartTap()
call vimtap#Plan(5)

let @/ = 'nil'
let @a = "one\ntwo"
SearchAddAllWhole a
call IsPattern('nil\|\<one\>\|\<two\>', 'add simple two-line range')

let @/ = ''
let @b = "foo/bar\\too\n^anchored$\n\\<fo\\+\\|\\(g[aeiou]\\)\\1\\>\nspecial^$and.*or[~]this#%&*"
SearchAddAllWhole b
call IsPattern('\<special\^\$and\.\*or\[\~]this#%&\*\%(\s\|$\)\@=\|\%(^\|\s\)\@<=\\<fo\\+\\|\\(g\[aeiou]\\)\\1\\>\%(\s\|$\)\@=\|\<foo/bar\\too\>\|\%(^\|\s\)\@<=\^anchored\$\%(\s\|$\)\@=', 'add four regexps')

let @/ = ''
let @c = "_keyword_\n_***_\n&WORD%\n&&	%%\n_mixed%"
SearchAddAllWhole c
call IsPattern('\<_keyword_\>\|\<_mixed%\%(\s\|$\)\@=\|\%(^\|\s\)\@<=&WORD%\%(\s\|$\)\@=\|\<_\*\*\*_\>\|\%(^\|\s\)\@<=&&	%%\%(\s\|$\)\@=', 'add four keywords and WORDs')

let @e = ''
call vimtap#err#Errors('Nothing added', 'SearchAddAllWhole e', 'error with register that is empty')

let @e = "\n\n"
call vimtap#err#Errors('Nothing added', 'SearchAddAllWhole e', 'error with register that is just empty lines')

call vimtest#Quit()
