" -*- vim -*-
" FILE: createfilenext.vim
" PLUGINTYPE: utility
" DESCRIPTION: Creates a file next to the one in the buffer.
" HOMEPAGE: https://github.com/caglartoklu/createfilenext.vim
" LICENSE: https://github.com/caglartoklu/createfilenext.vim/blob/master/LICENSE
" AUTHOR: caglartoklu


if exists('g:loaded_createfilenext') || &cp
    " If it already loaded, do not load it again.
    finish
endif


" mark that plugin loaded
let g:loaded_createfilenext = 1


function! s:Strip(input_string)
    " Strips (or trims) leading and trailing whitespace.
    " http://stackoverflow.com/a/4479072
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction


function! s:StrLeft(input_string, length)
    let length2 = a:length
    if (length2 < 0)
        let length2 = 0
    elseif (length2 > strlen(a:input_string))
        let length2 = strlen(a:input_string)
    endif
    let result = a:input_string
    if length2 < strlen(a:input_string)
        " strpart( {src}, {start}[, {len}])
        let istart = 0
        let result = strpart(a:input_string, istart, length2)
    endif
    return result
endfunction


function! s:StrRight(input_string, length)
    let length2 = a:length
    if (length2 < 0)
        let length2 = 0
    endif
    let result = a:input_string
    if length2 < strlen(a:input_string)
        let istart = strlen(a:input_string) - length2
        " strpart( {src}, {start}[, {len}])
        let result = strpart(a:input_string, istart, length2)
    endif
    return result
endfunction


function! s:GetPathSeparator(itemPath)
    " Determines the path separator, '/' or '\'.
    " To do that, it parses a path, and tries to
    " find which one is first, and returns it.
    let iforward = stridx(a:itemPath, '/')
    if iforward == -1
        let iforward = strlen(a:itemPath) + 1
    endif

    let iback = stridx(a:itemPath, '\')
    if iback == -1
        let iback = strlen(a:itemPath) + 1
    endif

    let pathChar = ''
    if iforward < iback
        let pathChar = '/'
    elseif iforward > iback
        let pathChar = '\'
    endif
    return pathChar
endfunction


function! s:CreateFileNext(fileName)
    if s:Strip(a:fileName) != ''
        " http://stackoverflow.com/q/16485748
        " parameter is not empty, use it:
        let fileDir = fnamemodify(a:fileName, ':h')
    else
        " use the file name of the current buffer:
        let fileDir = expand('%:p:h')
    endif

    let pathChar = s:GetPathSeparator(fileDir)

    if s:StrRight(fileDir, 1) != pathChar
        let fileDir = fileDir . pathChar
    endif

    let filePath = input(">", fileDir)
    if strlen(filePath) > 0
        if !filereadable(filePath)
            call writefile([], filePath)
            let cmd = 'edit ' . filePath
            execute cmd
        endif
    endif
endfunction


command! -nargs=? CreateFileNext : call s:CreateFileNext(<q-args>)
