" Test :SearchAddAllPattern substitution of patterns from range.

view list.txt

call vimtest#StartTap()
call vimtap#Plan(0)

let @/ = ''
3,5SearchAddAllPattern /\S.*\S/
call IsPattern('three "words" here\|trailing ws\|leading ws', 'add range without leading and trailing whitespace')

let @/ = ''
13,15SearchAddAllPattern /^\w\+/
call IsPattern('pattern\|expr\|more', 'add range with match')

let @/ = ''
13,15SearchAddAllPattern /\d/&&/
call IsPattern('pattern(33)!\|expr(11).\|more(22)?', 'add range with replacement doubling the match')

let @/ = ''
13,15SearchAddAllPattern /[()]/#/
call IsPattern('pattern#3)!\|expr#1).\|more#2)?', 'add range with replacement once')

let @/ = ''
13,15SearchAddAllPattern /[().?!]/#/g
call IsPattern('pattern#3##\|expr#1##\|more#2##', 'add range with global replacement')

let @/ = ''
13,15SearchAddAllPattern /^\(\w\+\)(\(\d\))\(.\)$/\2\3\1\3/
call IsPattern('3!pattern!\|1.expr.\|2?more?', 'add range with capture group replacement')

let @/ = ''
3,5SearchAddAllPattern /^\s\+\|\s\+$//g
call IsPattern('three "words" here\|trailing ws\|leading ws', 'add range without leading and trailing whitespace negative with empty replacement')

call vimtest#Quit()
