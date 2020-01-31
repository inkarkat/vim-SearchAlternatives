" Test RemPattern.

call vimtest#StartTap()
call vimtap#Plan(12)

let @/ = '' | call vimtap#Is(SearchAlternatives#RemPattern('xy'), 0, 'xy not found in empty pattern') | call IsPattern('', 'pattern still empty')
let @/ = 'foo\|bar' | call vimtap#Is(SearchAlternatives#RemPattern('bar'), 1, 'remove bar from foo\|bar') | call IsPattern('foo', 'removed bar from foo\|bar')
let @/ = 'foo\|bar' | call vimtap#Is(SearchAlternatives#RemPattern('foo'), 1, 'remove foo from foo\|bar') | call IsPattern('bar', 'removed foo from foo\|bar')

let @/ = 'foo\|bar' | call vimtap#Is(SearchAlternatives#RemPattern('ba'), 0, 'cannot remove partial ba from foo\|bar') | call IsPattern('foo\|bar', 'pattern unchanged')
let @/ = 'foo\|bar' | call vimtap#Is(SearchAlternatives#RemPattern('xyz'), 0, 'cannot remove xyz from foo\|bar') | call IsPattern('foo\|bar', 'pattern unchanged')

let @/ = 'foo\|bar\|^lulli\|nono$' | call vimtap#Is(SearchAlternatives#RemPattern('^lulli'), 1, 'remove ^lulli from foo\|bar\|^lulli\|nono$') | call IsPattern('foo\|bar\|nono$', 'removed ^lulli from foo\|bar\|^lulli\|nono$')

call vimtest#Quit()
