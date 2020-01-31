" Test :SearchAddAllPattern with ranges.

view list.txt

call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = 'nil'
1,2SearchAddAllPattern
call IsPattern('nil\|one\|two', 'add simple two-line range')

let @/ = ''
8,11SearchAddAllPattern
call IsPattern('special^$and.*or[~]this#%&*\|foo/bar\too\|^anchored$\|\<fo\+\|\(g[aeiou]\)\1\>', 'add four regexps')

call vimtap#err#Errors('Nothing added', '6,7SearchAddAllPattern', 'Error with range that is just empty lines')

call vimtest#Quit()
