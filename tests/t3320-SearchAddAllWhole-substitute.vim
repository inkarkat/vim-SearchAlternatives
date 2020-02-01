" Test :SearchAddAllWhole substitution makes whole after replacement.

view list.txt

call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = ''
let @a = "a.*z for X"
SearchAddAllWhole a /X/a.*z/
call IsPattern('\<a\.\*z for a\.\*z\>', 'make whole word works both on match and replacement')

let @/ = ''
let @b = "&.*% for X"
SearchAddAllWhole b /X/\&.*%/
call IsPattern('\%(^\|\s\)\@<=&\.\*% for &\.\*%\%(\s\|$\)\@=', 'make whole WORD works both on match and replacement')

call vimtest#Quit()
