" Test AddPattern with global regular expression flags.

call vimtest#StartTap()
call vimtap#Plan(5)

let @/ = '\cfoo\|bar' | call SearchAlternatives#AddPattern('\cxyz') | call IsPattern('\cfoo\|bar\|xyz', 'add \cxyz to existing \c flag')
let @/ = 'foo\|bar' | call SearchAlternatives#AddPattern('\cxyz') | call IsPattern('\cfoo\|bar\|xyz', 'add \cxyz prepends \c flag to whole regexp')
let @/ = 'foo\|\Cbar' | call SearchAlternatives#AddPattern('\cxyz') | call IsPattern('\cfoo\|bar\|xyz', 'add \cxyz prepends \c flag to whole regexp and removes overridden existing \C flag')
let @/ = 'foo\|\cbar' | call SearchAlternatives#AddPattern('\Cxyz') | call IsPattern('\cfoo\|bar\|xyz', 'add \Cxyz moves existing \c flag to whole regexp and drops overridden added \C flag')

let @/ = 'foo\|bar' | call SearchAlternatives#AddPattern('\c\%#=1xyz') | call IsPattern('\%#=1\cfoo\|bar\|xyz', 'add \c\%#=1xyz prepends \%#=1 and \c flags to whole regexp')

call vimtest#Quit()
