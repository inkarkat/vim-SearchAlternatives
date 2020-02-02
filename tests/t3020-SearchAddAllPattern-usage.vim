" Test usage errors of :SearchAddAllPattern

view list.txt

call vimtest#StartTap()
call vimtap#Plan(1)

let @x = "foo\nbar"
call vimtap#err#Errors('Cannot pass both range and register', '1SearchAddAllPattern x', 'error when both range and register are passed')

call vimtest#Quit()
