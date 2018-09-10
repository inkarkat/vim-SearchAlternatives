" Test RemPattern with normalized magicness.

call vimtest#StartTap()
call vimtap#Plan(8)

let @/ = 'foo\|\v(b|c)a+r' | call vimtap#Is(SearchAlternatives#RemPattern('\(b\|c\)a\+r'), 1, 'remove \(b\|c\)a\+r from foo\|\v(b|c)a+r') | call IsPattern('foo', 'removed even though original in very magic mode')
let @/ = 'foo\|\(b\|c\)a\+r' | call vimtap#Is(SearchAlternatives#RemPattern('\v(b|c)a+r'), 1, 'remove \v(b|c)a+r from foo\|\(b\|c\)a\+r') | call IsPattern('foo', 'removed even though removal in very magic mode')

let @/ = '\Vfoo\|****\|bar' | call vimtap#Is(SearchAlternatives#RemPattern('\*\*\*\*'), 1, 'remove \*\*\*\* from \Vfoo\|****\|bar') | call IsPattern('foo\|bar', 'removed even though original in very nomagic mode')
let @/ = 'foo\|\*\*\*\*\|bar' | call vimtap#Is(SearchAlternatives#RemPattern('\m\*\*\*\*'), 1, 'remove \m\*\*\*\* from foo\|\*\*\*\*\|bar') | call IsPattern('foo\|bar', 'removed even though removal has superfluous \m magic marker')

call vimtest#Quit()
