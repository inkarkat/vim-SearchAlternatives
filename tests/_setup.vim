call vimtest#AddDependency('vim-ingo-library')

runtime plugin/SearchAlternatives.vim

function! IsPattern( pattern, description )
    call vimtap#Is(@/, a:pattern, a:description)
endfunction
