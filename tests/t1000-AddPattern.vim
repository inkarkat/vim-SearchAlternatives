" Test AddPattern

call vimtest#StartTap()
call vimtap#Plan(3)

let @/ = '' | call SearchAlternatives#AddPattern('xy') | call IsPattern('xy', 'Add xy to empty')
let @/ = 'foo' | call SearchAlternatives#AddPattern('xy') | call IsPattern('foo\|xy', 'Add xy to foo')
let @/ = 'foo\|bar' | call SearchAlternatives#AddPattern('xy') | call IsPattern('foo\|bar\|xy', 'Add xy to foo\|bar')

call vimtest#Quit()
