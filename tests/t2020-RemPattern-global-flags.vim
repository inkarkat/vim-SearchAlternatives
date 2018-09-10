" Test RemPattern with global regular expression flags.

call vimtest#StartTap()
call vimtap#Plan(6)

let @/ = '\cfoo\|bar' | call vimtap#Is(SearchAlternatives#RemPattern('foo'), 1, 'remove foo from \cfoo\|bar') | call IsPattern('\cbar', 'removed foo, ignoring the \c flag')
let @/ = '\%#=2foo\c\|bar' | call vimtap#Is(SearchAlternatives#RemPattern('foo'), 1, 'remove foo from \%#=2foo\c\|bar') | call IsPattern('\%#=2\cbar', 'removed foo, ignoring the \%#=2 and \c flags')
let @/ = '\%#=2foo\c\|\Cbar\|\Cnono$' | call vimtap#Is(SearchAlternatives#RemPattern('bar'), 1, 'remove bar from \%#=2foo\c\|bar\|nono$') | call IsPattern('\%#=2\cfoo\|nono$', 'removed bar, ignoring the \C flag, and the \%#=2 and \C flags in other branches')

call vimtest#Quit()
