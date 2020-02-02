" Test :SearchAddAllAny1Whitespace and :SearchAddAllAny0Whitespace integrations with AdvancedSearches.vim.

setlocal comments=b:#

call vimtest#StartTap()
call vimtap#Plan(2)

let @/ = ''
let @a = "one two"
SearchAddAllAny1Whitespace a
call IsPattern('one\_s\+\%(#\%(\s\|\$\)\@=\)\?\_s*two', 'add simple register with any whitespace in between')

let @/ = ''
SearchAddAllAny0Whitespace a
call IsPattern('o\_s*\%(#\%(\s\|\$\)\@=\)\?\_s*n\_s*\%(#\%(\s\|\$\)\@=\)\?\_s*e\_s*\%(#\%(\s\|\$\)\@=\)\?\_s*\_s*\%(#\%(\s\|\$\)\@=\)\?\_s*t\_s*\%(#\%(\s\|\$\)\@=\)\?\_s*w\_s*\%(#\%(\s\|\$\)\@=\)\?\_s*o', 'add simple register any any or no whitespace in between')

call vimtest#Quit()
