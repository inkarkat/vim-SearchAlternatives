" Test :SearchAddAllPattern substitution of patterns from register.

let @a = "three \"words\" here\nleading ws\ntrailing ws"
let @b = "expr(1).\nmore(2)?\npattern(3)!"

call vimtest#StartTap()
call vimtap#Plan(9)

let @/ = ''
SearchAddAllPattern a /\S.*\S/
call IsPattern('three "words" here\|trailing ws\|leading ws', 'add range without leading and trailing whitespace')

let @/ = ''
SearchAddAllPattern b /^\w\+/
call IsPattern('pattern\|expr\|more', 'add range with match')

let @/ = ''
SearchAddAllPattern b /\d/&&/
call IsPattern('pattern(33)!\|expr(11).\|more(22)?', 'add range with replacement doubling the match')

let @/ = ''
SearchAddAllPattern b /[()]/#/
call IsPattern('pattern#3)!\|expr#1).\|more#2)?', 'add range with replacement once')

let @/ = ''
SearchAddAllPattern b /[().?!]/#/g
call IsPattern('pattern#3##\|expr#1##\|more#2##', 'add range with global replacement')

let @/ = ''
SearchAddAllPattern b /^\(\w\+\)(\(\d\))\(.\)$/\2\3\1\3/
call IsPattern('3!pattern!\|1.expr.\|2?more?', 'add range with capture group replacement')

let @/ = ''
SearchAddAllPattern a /^\s\+\|\s\+$//g
call IsPattern('three "words" here\|trailing ws\|leading ws', 'add range without leading and trailing whitespace negative with empty replacement')

let @/ = ''
SearchAddAllPattern b /\w\+/g
call IsPattern('pattern3\|expr1\|more2', 'add range with global match')

let @/ = ''
SearchAddAllPattern b /\w\+/g/
call IsPattern('g(1).\|g(2)?\|g(3)!', 'global match is not confused with g replacement')

call vimtest#Quit()
