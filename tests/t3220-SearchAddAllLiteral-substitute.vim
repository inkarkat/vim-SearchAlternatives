" Test :SearchAddAllLiteral substitution makes literal after replacement.

view list.txt

call vimtest#StartTap()
call vimtap#Plan(1)

let @/ = ''
let @a = ".* for X"
SearchAddAllLiteral a /X/.*/
call IsPattern('\.\* for \.\*', 'add literal works both on match and replacement')

call vimtest#Quit()
