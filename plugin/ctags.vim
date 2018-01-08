let s:tagDir = $PWD . "/.tags"
let s:tagFile = s:tagDir . "/tags"
let s:excludes = "--exclude=\".session.vim\" --exclude=\"*node_modules/*\""

set tags=s:tagFile

function! Silentify(command)
	return "silent !" . a:command . " > /dev/null 2>&1 &"
endfunction

"../../../init.vim"

function! ExecuteSilent(command)
	let l:silentified = Silentify(a:command)
	execute l:silentified
endfunction

function! Tag()
	let l:word = expand("<cword>")
	execute "tag " . l:word
endfunction

function! Vstag()
	vsplit
	execute "call Tag()"
endfunction

function! Stag()
	split
	execute "call Tag()"
endfunction

function! UpdateCtags()
	call ExecuteSilent("exctags --tag-relative=yes " . s:excludes . " --append -f " . s:tagFile . " " . expand("%"))
"	execute "silent redraw!"
endfunction

function! InitCtags()
	if !isdirectory(s:tagDir)
		call ExecuteSilent("mkdir " . s:tagDir)
	endif
	if !filereadable(s:tagFile)
		execute "!exctags --tag-relative=yes -R " . s:excludes . " -f " . s:tagFile . " " . $PWD
	endif
	execute "silent set tags=" . s:tagFile
endfunction

function! ReinitCtags()
	call ExecuteSilent("rm " . s:tagFile)
	call InitCtags()
endfunction

command! -nargs=0 Vstag call Vstag()
command! -nargs=0 Stag call Stag()
command! -nargs=0 Tag call Tag()

command! -nargs=0 ReinitTags call ReinitCtags()
nmap <leader>v :Vstag<CR>
nmap <leader>s :Stag<CR>
nmap <leader>] :Tag<CR>

autocmd VimEnter * execute "call InitCtags()"
autocmd BufWritePost * execute "call UpdateCtags()"
