" Test :SearchAddAllPattern with register.

call vimtest#StartTap()
call vimtap#Plan(4)

let @/ = 'nil'
let @a = "one\ntwo"
SearchAddAllPattern a
call IsPattern('nil\|one\|two', 'add simple two-line range')

let @/ = ''
let @b = "foo/bar\\too\n^anchored$\n\\<fo\\+\\|\\(g[aeiou]\\)\\1\\>\nspecial^$and.*or[~]this#%&*"
SearchAddAllPattern b
call IsPattern('special^$and.*or[~]this#%&*\|foo/bar\too\|^anchored$\|\<fo\+\|\(g[aeiou]\)\1\>', 'add four regexps')

let @e = ''
call vimtap#err#Errors('Nothing added', 'SearchAddAllPattern e', 'error with register that is empty')

let @e = "\n\n"
call vimtap#err#Errors('Nothing added', 'SearchAddAllPattern e', 'error with register that is just empty lines')

call vimtest#Quit()
