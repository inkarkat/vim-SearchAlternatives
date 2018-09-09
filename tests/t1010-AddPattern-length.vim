" Test AddPattern

call vimtest#StartTap()
call vimtap#Plan(7)

let @/ = 'barn\|foo' | call SearchAlternatives#AddPattern('barrier') | call IsPattern('barn\|foo\|barrier', 'Add barrier to barn\|foo')
let @/ = 'barn\|foo' | call SearchAlternatives#AddPattern('b') | call IsPattern('barn\|foo\|b', 'Add b to barn\|foo')
let @/ = 'barn\|foo' | call SearchAlternatives#AddPattern('\<b\>') | call IsPattern('barn\|foo\|\<b\>', 'Add \<b\> to barn\|foo')
let @/ = 'barn\|foo' | call SearchAlternatives#AddPattern('b\{5,}') | call IsPattern('barn\|foo\|b\{5,}', 'Add b\{5,} to barn\|foo')
let @/ = 'barn\|foo' | call SearchAlternatives#AddPattern('b\+') | call IsPattern('barn\|foo\|b\+', 'Add b\+ to barn\|foo')

let @/ = 'b\{4,6}\|f*' | call SearchAlternatives#AddPattern('ooooo') | call IsPattern('b\{4,6}\|f*\|ooooo', 'Add ooooo to b\{4,6}\|f*')
let @/ = 'b\{4,6}\|f*' | call SearchAlternatives#AddPattern('Oi*') | call IsPattern('b\{4,6}\|f*\|Oi*', 'Add Oi* to b\{4,6}\|f*')

call vimtest#Quit()
