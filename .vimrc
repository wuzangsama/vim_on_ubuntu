" @file .vimrc
" @brief
" @author zhanghf@zailingtech.com
" @version 1.0
" @date 2017-07-29

" 基础 {{{
if &compatible | set nocompatible | endif
let mapleader=' '
let maplocalleader=';'

" 编码
if &encoding !=? 'utf-8' | let &termencoding = &encoding | endif
set encoding=utf-8 fileencoding=utf-8 fileformats=unix,mac,dos
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" 界面相关
silent! set number relativenumber background=dark nowrap guioptions=
silent! set ruler laststatus=2 noshowmode cursorline colorcolumn=80
silent! set list listchars=tab:›\ ,trail:• scrolloff=3
silent! set mouse=a mousehide guicursor=a:block-blinkon0 helplang=cn
if has('gui_running') | set guifont=Hack\ Regular\ Nerd\ Font\ Complete:h13 | else | set t_Co=256 | endif

" 编辑
silent! set shiftwidth=4 expandtab tabstop=4 softtabstop=4
silent! set nofoldenable foldlevel=2 foldmethod=indent
silent! set backspace=indent,eol,start formatoptions=cmMj
silent! set tags=tags,./tags,../tags,../../tags,../../../tags

" 剪切板
" silent! set clipboard=unnamed
" silent! set clipboard+=unnamedplus

" 搜索
silent! set ignorecase smartcase incsearch hlsearch magic

" 命令
silent! set wildmenu wildmode=list:longest
silent! set wildignore=*.~,*.?~,*.o,*.sw?,*.bak,*.hi,*.pyc,*.out,*.lock,*.DS_Store
silent! set wildignore+=.hg,.git,.svn
silent! set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
silent! set wildignore+=*.o,*.obj,*.exe,*.dll,*.so,*.manifest

" 性能表现
silent! set updatetime=300 timeout timeoutlen=500 ttimeout ttimeoutlen=50 ttyfast lazyredraw

" 退出保留显示
set t_ti= t_te=

syntax enable
syntax on
filetype on
filetype plugin on
filetype indent on
" }}}

" 函数 {{{
" 生成tags
function! GeneratorTags()
        exec "!ctags -R --sort=1 --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ ."
endfunc

" 替换函数。参数说明：
" confirm：是否替换前逐一确认
" wholeword：是否整词匹配
" replace：被替换字符串
function! Replace(confirm, wholeword, replace)
    wa
    let flag = ''
    if a:confirm
        let flag .= 'gec'
    else
        let flag .= 'ge'
    endif
    let search = ''
    if a:wholeword
        let search .= '\<' . escape(expand('<cword>'), '/\.*$^~[') . '\>'
    else
        let search .= expand('<cword>')
    endif
    let replace = escape(a:replace, '/\&~')
    execute 'argdo %s/' . search . '/' . replace . '/' . flag . '| update'
endfunction

" Strip whitespace
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

" 搜索选中项
function! VisualSelection() range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    execute 'Ag '.l:pattern

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Auto group {{{
augroup vimrc
  autocmd!
augroup END

autocmd vimrc SwapExists * let v:swapchoice = 'o' " 如已打开，自动选择只读
autocmd vimrc BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " 启动后定位到上次关闭光标位置
autocmd vimrc FileType haskell,puppet,ruby,yaml setlocal expandtab shiftwidth=2 softtabstop=2
autocmd vimrc FileType markdown,text setlocal wrap
autocmd vimrc FileType c,cpp,java,php,javascript,python,rust,xml,yaml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" autocmd vimrc BufWritePost $MYVIMRC source $MYVIMRC " 让配置变更立即生效
" }}}

" 插件安装 {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/bundle')

" 属性增强
Plug 'MarcWeber/vim-addon-mw-utils'

" 外观
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
function! LoadAirline(theme)
    let g:airline_theme=a:theme
    let g:airline_detect_spell=0
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_left_sep = "\uE0B0"
    let g:airline_left_alt_sep = "\uE0B1"
    let g:airline_right_sep = "\uE0B2"
    let g:airline_right_alt_sep = "\uE0B3"
    let g:airline_symbols.linenr = "\uE0A1"
    let g:airline_symbols.maxlinenr = "\uF749"
    let g:airline_symbols.branch = "\uE0A0"
    " 是否打开tabline
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#formatter = 'unique_tail'
    let g:airline#extensions#tabline#show_tab_nr = 1
    let g:airline#extensions#tabline#buffer_idx_mode = 1
    nmap <leader>1 <Plug>AirlineSelectTab1
    nmap <leader>2 <Plug>AirlineSelectTab2
    nmap <leader>3 <Plug>AirlineSelectTab3
    nmap <leader>4 <Plug>AirlineSelectTab4
    nmap <leader>5 <Plug>AirlineSelectTab5
    nmap <leader>6 <Plug>AirlineSelectTab6
    nmap <leader>7 <Plug>AirlineSelectTab7
    nmap <leader>8 <Plug>AirlineSelectTab8
    nmap <leader>9 <Plug>AirlineSelectTab9
    nmap <leader>- <Plug>AirlineSelectPrevTab
    nmap <leader>+ <Plug>AirlineSelectNextTab
endfunction
Plug 'tomasr/molokai'
function! LoadColorSchemeMolokai()
    colorscheme molokai
    let g:molokai_original = 1
    let g:rehash256 = 1
endfunction
Plug 'altercation/vim-colors-solarized'
function! LoadColorSchemeSolarized()
    colorscheme solarized
    let g:solarized_termtrans=1
    let g:solarized_contrast="normal"
    let g:solarized_visibility="normal"
    let g:solarized_termcolors=256"
endfunction
Plug 'morhetz/gruvbox'
function! LoadColorSchemeGruvbox()
    colorscheme gruvbox
endfunction
Plug 'junegunn/seoul256.vim'
function! LoadColorSchemeSeoul256()
    let g:indentLine_color_term = 239
    let g:indentLine_color_gui = '#616161'

    colorscheme seoul256
endfunction

Plug 'ryanoasis/vim-devicons'
function! LoadDevicons()
    " loading the plugin
    let g:webdevicons_enable = 1
    " adding the column to vimfiler
    let g:webdevicons_enable_vimfiler = 1
    " adding to vim-airline's tabline
    let g:webdevicons_enable_airline_tabline = 1
    " adding to vim-airline's statusline
    let g:webdevicons_enable_airline_statusline = 1
endfunction

Plug 'luochen1990/rainbow'
function! LoadRainbow()
    let g:rainbow_active = 1
    let g:rainbow_conf = {
                \	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
                \	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
                \	'operators': '_,_',
                \	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
                \	'separately': {
                \		'*': {},
                \		'tex': {
                \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
                \		},
                \		'lisp': {
                \			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
                \		},
                \		'vim': {
                \			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
                \		},
                \		'html': {
                \			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
                \		},
                \		'css': 0,
                \	}
                \}
endfunction

" 一般功能
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/matchit.zip'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'majutsushi/tagbar'
function! LoadTagbar()
    nnoremap <F2> :Tagbar<CR>
    inoremap <F2> <ESC>:Tagbar<CR>
    vnoremap <F2> <ESC>:Tagbar<CR>
endfunction
Plug 'Shougo/vinarise.vim'
Plug 'shougo/vimshell.vim'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'shougo/vimfiler.vim'
function! LoadVimFiler()
    nnoremap <F3> :VimFilerExplorer<CR>
    inoremap <F3> <ESC>:VimFilerExplorer<CR>
    vnoremap <F3> <ESC>:VimFilerExplorer<CR>
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_restore_alternate_file = 1
    let g:vimfiler_tree_indentation = 1
    let g:vimfiler_tree_leaf_icon = ''
    let g:vimfiler_tree_opened_icon = "\uF0D7"
    let g:vimfiler_tree_closed_icon = "\uF105"
    " let g:vimfiler_file_icon = ''
    let g:vimfiler_readonly_file_icon = "\uE0A2"
    let g:vimfiler_marked_file_icon = "\uFADF"
    "let g:vimfiler_preview_action = 'auto_preview'
    let g:vimfiler_ignore_pattern = [
                \ '^\.git$',
                \ '^\.DS_Store$',
                \ '^\.init\.vim-rplugin\~$',
                \ '^\.netrwhist$',
                \ '\.class$'
                \]
    call vimfiler#custom#profile('default', 'context', {
                \ 'explorer' : 1,
                \ 'winwidth' : 30,
                \ 'winminwidth' : 30,
                \ 'toggle' : 1,
                \ 'auto_expand': 1,
                \ 'explorer_columns' : 30,
                \ 'parent': 0,
                \ 'status' : 1,
                \ 'safe' : 0,
                \ 'split' : 1,
                \ 'hidden': 1,
                \ 'no_quit' : 1,
                \ 'force_hide' : 0,
                \ })

    augroup vfinit
        au!
        autocmd FileType vimfiler call s:vimfilerinit()
        autocmd vimenter * if !argc() | VimFilerExplorer | endif " 无文件打开显示vimfiler
        autocmd BufEnter * if (!has('vim_starting') && winnr('$') == 1 && &filetype ==# 'vimfiler') |
                    \ q | endif
    augroup END
    function! s:vimfilerinit()
        setl nonumber
        setl norelativenumber

        silent! nunmap <buffer> <C-l>
        silent! nunmap <buffer> <C-j>
        silent! nunmap <buffer> B

        nmap <buffer> i       <Plug>(vimfiler_switch_to_history_directory)
        nmap <buffer> <C-r>   <Plug>(vimfiler_redraw_screen)
        nmap <buffer> u       <Plug>(vimfiler_smart_h)
    endf
endfunction
Plug 'Shougo/unite.vim'
function! LoadUnite()
    call unite#custom#source('codesearch', 'max_candidates', 30)
    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])
    let g:unite_source_grep_max_candidates = 200
    let g:unite_source_grep_default_opts =
                \ '-iRHn'
                \ . " --exclude='tags'"
                \ . " --exclude='cscope*'"
                \ . " --exclude='*.svn*'"
                \ . " --exclude='*.log*'"
                \ . " --exclude='*tmp*'"
                \ . " --exclude-dir='**/tmp'"
                \ . " --exclude-dir='CVS'"
                \ . " --exclude-dir='.svn'"
                \ . " --exclude-dir='.git'"
                \ . " --exclude-dir='node_modules'"

    " Use ag (the silver searcher)
    " https://github.com/ggreer/the_silver_searcher
    let g:unite_source_grep_command = 'ag'
    let g:unite_source_grep_default_opts = '-i --line-numbers --nocolor --nogroup --hidden --ignore ' .
                \ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
    let g:unite_source_grep_recursive_opt = ''

    let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
endfunction
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
function! LoadFzf()
    " Default fzf layout
    " - down / up / left / right
    let g:fzf_layout = { 'down': '~40%' }

    " Customize fzf colors to match your color scheme
    let g:fzf_colors =
                \ { 'fg':      ['fg', 'Normal'],
                \ 'bg':      ['bg', 'Normal'],
                \ 'hl':      ['fg', 'Comment'],
                \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
                \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
                \ 'hl+':     ['fg', 'Statement'],
                \ 'info':    ['fg', 'PreProc'],
                \ 'prompt':  ['fg', 'Conditional'],
                \ 'pointer': ['fg', 'Exception'],
                \ 'marker':  ['fg', 'Keyword'],
                \ 'spinner': ['fg', 'Label'],
                \ 'header':  ['fg', 'Comment'] }

    " Enable per-command history.
    " CTRL-N and CTRL-P will be automatically bound to next-history and
    " previous-history instead of down and up. If you don't like the change,
    " explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
    let g:fzf_history_dir = '~/.local/share/fzf-history'

    " [Buffers] Jump to the existing window if possible
    let g:fzf_buffers_jump = 1

    " [[B]Commits] Customize the options used by 'git log':
    let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

    " [Tags] Command to generate tags file
    let g:fzf_tags_command = 'ctags -R'
    nnoremap <Leader>ff :Files<cr>
    nnoremap <Leader>fb :Buffers<cr>
    nnoremap <Leader>fm :Marks<cr>
    nnoremap <Leader>fr :History<cr>
    nnoremap <Leader>fc :Commits<cr>
    nnoremap <Leader>fs :GFiles?<cr>
    nnoremap <Leader>fhs :History/<cr>
    nnoremap <Leader>fhc :History:<cr>
    nnoremap <Leader>ft :BTags<cr>
endfunction
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
function! LoadGitGutter()
    let g:gitgutter_sign_added = "\uF457"
    let g:gitgutter_sign_removed = "\uF458"
    let g:gitgutter_sign_modified = "\uF459"
    let g:gitgutter_sign_modified_removed = "\uF45A"
endfunction
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-slash'
Plug 'junegunn/vim-peekaboo'
Plug 'nvie/vim-togglemouse'

" 写作
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
function! LoadGoyoLimelight()
    " Color name (:help cterm-colors) or ANSI code
    let g:limelight_conceal_ctermfg = 'gray'
    let g:limelight_conceal_ctermfg = 240
    " Color name (:help gui-colors) or RGB color
    let g:limelight_conceal_guifg = 'DarkGray'
    let g:limelight_conceal_guifg = '#777777'
    " Default: 0.5
    let g:limelight_default_coefficient = 0.7
    " Number of preceding/following paragraphs to include (default: 0)
    let g:limelight_paragraph_span = 3
    " Beginning/end of paragraph
    "   When there's no empty line between the paragraphs
    "   and each paragraph starts with indentation
    let g:limelight_bop = '^\s'
    let g:limelight_eop = '\ze\n^\s'
    " Highlighting priority (default: 10)
    "   Set it to -1 not to overrule hlsearch

    let g:limelight_priority = -1

    autocmd! User GoyoEnter Limelight
    autocmd! User GoyoLeave Limelight!
endfunction
" Plug 'junegunn/vim-xmark', { 'do': 'make' }

" 所有语言
Plug 'junegunn/vim-easy-align'
function! LoadEasyAlign()
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
endfunction
Plug 'tomtom/tcomment_vim' " 注释 gcc gcu gcap
" Plug 'Shougo/echodoc.vim'

" Dockerfile
Plug 'ekalinin/Dockerfile.vim', {'for' : 'Dockerfile'}

" CPP
Plug 'octol/vim-cpp-enhanced-highlight',{'for': 'cpp'}
Plug 'lyuts/vim-rtags', { 'for': ['c', 'cpp'] }
function! LoadRtags()
    let g:rtagsUseDefaultMappings=0

    augroup cpprtags
        autocmd!
        autocmd FileType c,cpp nnoremap <silent> <localleader>ri :call rtags#SymbolInfo()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rj :call rtags#JumpTo(g:SAME_WINDOW)<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rJ :call rtags#JumpTo(g:SAME_WINDOW, { '--declaration-only' : '' })<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rS :call rtags#JumpTo(g:H_SPLIT)<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rV :call rtags#JumpTo(g:V_SPLIT)<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rT :call rtags#JumpTo(g:NEW_TAB)<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rp :call rtags#JumpToParent()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rf :call rtags#FindRefs()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rF :call rtags#FindRefsCallTree()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rn :call rtags#FindRefsByName(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rs :call rtags#FindSymbols(input("Pattern? ", "", "customlist,rtags#CompleteSymbols"))<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rr :call rtags#ReindexFile()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rl :call rtags#ProjectList()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rw :call rtags#RenameSymbolUnderCursor()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rv :call rtags#FindVirtuals()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rb :call rtags#JumpBack()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rC :call rtags#FindSuperClasses()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rc :call rtags#FindSubClasses()<CR>
        autocmd FileType c,cpp nnoremap <silent> <localleader>rd :call rtags#Diagnostics()<CR>
    augroup END
endfunction
Plug 'derekwyatt/vim-fswitch',{'for': 'cpp'}
function! LoadFswitch()
    augroup cppswitch
        autocmd!
        autocmd FileType c,cpp nnoremap <silent> <localleader>a :FSHere<cr>
    augroup END
endfunction
Plug 'derekwyatt/vim-protodef',{'for': 'cpp'}
function! LoadProtodef()
    " 设置 pullproto.pl 脚本路径
    let g:protodefprotogetter='~/.vim/bundle/vim-protodef/pullproto.pl'
    " 成员函数的实现顺序与声明顺序一致
    let g:disable_protodef_sorting=1
endfunction
Plug 'vim-scripts/DoxygenToolkit.vim',{'for': ['cpp', 'c']}
function! LoadDoxygen()
    let g:DoxygenToolkit_authorName="zhanghf@zailingtech.com"
    let g:DoxygenToolkit_versionString="1.0"

    augroup cppswitch
        autocmd!
        autocmd FileType c,cpp nnoremap <localleader>da <ESC>gg:DoxAuthor<CR>
        autocmd FileType c,cpp nnoremap <localleader>df <ESC>:Dox<CR>
    augroup END
endfunction

" GoLang
Plug 'fatih/vim-go', { 'tag': 'v1.17' }
function! LoadVimGo()
    let g:go_fmt_fail_silently = 1
    let g:go_fmt_command = "goimports"
    let g:go_fmt_options = {
                \ 'goimports': '-local do/',
                \ }

    let g:go_debug_windows = {
                \ 'vars':  'leftabove 35vnew',
                \ 'stack': 'botright 10new',
                \ }

    let g:go_sameid_search_enabled = 1

    let g:go_test_prepend_name = 1
    let g:go_list_type = "quickfix"

    let g:go_auto_type_info = 0
    let g:go_auto_sameids = 0

    let g:go_def_mode = "guru"
    let g:go_echo_command_info = 1
    let g:go_gocode_autobuild = 1
    let g:go_gocode_unimported_packages = 1

    let g:go_autodetect_gopath = 1

    let g:go_metalinter_autosave_enabled = ['vet', 'golint']
    let g:go_highlight_space_tab_error = 0
    let g:go_highlight_array_whitespace_error = 0
    let g:go_highlight_trailing_whitespace_error = 0
    let g:go_highlight_extra_types = 0
    let g:go_highlight_build_constraints = 1
    let g:go_highlight_types = 0
    let g:go_highlight_format_strings = 0

    let g:go_modifytags_transform = 'camelcase'
    let g:go_fold_enable = []

    " Open :GoDeclsDir with ctrl-g
    nnoremap <C-g> :GoDeclsDir<cr>
    inoremap <C-g> <esc>:<C-u>GoDeclsDir<cr>

    augroup go
        autocmd!

        " :GoBuild and :GoTestCompile
        autocmd FileType go nmap <silent> <localleader>b :<C-u>call <SID>build_go_files()<CR>

        " :GoImplements
        autocmd FileType go nmap <silent> <localleader>j <Plug>(go-implements)

        " :GoTest
        autocmd FileType go nmap <silent> <localleader>t  <Plug>(go-test)

        " :GoRun
        autocmd FileType go nmap <silent> <localleader>r  <Plug>(go-run)

        " :GoDoc
        autocmd FileType go nmap <silent> <localleader>d <Plug>(go-doc)

        " :GoCoverageToggle
        autocmd FileType go nmap <silent> <localleader>c <Plug>(go-coverage-toggle)

        " :GoInfo
        autocmd FileType go nmap <silent> <localleader>i <Plug>(go-info)

        " :GoMetaLinter
        autocmd FileType go nmap <silent> <localleader>l <Plug>(go-metalinter)

        " :GoDef but opens in a vertical split
        autocmd FileType go nmap <silent> <localleader>v <Plug>(go-def-vertical)
        " :GoDef but opens in a horizontal split
        autocmd FileType go nmap <silent> <localleader>s <Plug>(go-def-split)

        " create doc
        autocmd FileType go nmap <silent> <localleader>a :<C-u>call <SID>create_go_doc_comment()<CR>

        " :GoAlternate  commands :A, :AV, :AS and :AT
        autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
        autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
        autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
        autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
    augroup END

    " build_go_files is a custom function that builds or compiles the test file.
    " It calls :GoBuild if its a Go file, or :GoTestCompile if it's a test file
    function! s:build_go_files()
        let l:file = expand('%')
        if l:file =~# '^\f\+_test\.go$'
            call go#cmd#Test(0, 1)
        elseif l:file =~# '^\f\+\.go$'
            call go#cmd#Build(0)
        endif
    endfunction

    function! s:create_go_doc_comment()
        norm "zyiw
        execute ":put! z"
        execute ":norm I// \<Esc>$"
    endfunction
endfunction
Plug 'buoto/gotests-vim'

" 语法检测
Plug 'vim-syntastic/syntastic'
function! LoadSyntastic()
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_cpp_checkers = ['clang_check']
    let g:syntastic_c_checkers = ['clang_check']
    let g:syntastic_clang_check_config_file = '.clang'

    let g:syntastic_go_checkers = ['golint', 'govec', 'gometalinter']
    let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=errcheck']
endfunction

" 语法检测
" Plug 'w0rp/ale'
" function! LoadAle()
"     let g:ale_lint_on_text_changed = 'never'
"     let g:ale_lint_on_enter = 0
"     let g:ale_set_loclist = 0
"     let g:ale_set_quickfix=1
"     let g:ale_open_list=1
"
"     let g:ale_linters = {'go':['gometalinter','gofmt'], 'cpp':['clangcheck','clangtidy'], 'c':['clangtidy']}
"
"     let g:ale_cpp_clang_options='-std=c++11 -Wall'
" endfunction

" 自动补全
Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --system-libclang'}
function! LoadYcm()
    " 补全菜单配色
    " 菜单
    "highlight Pmenu ctermfg=2 ctermbg=3 guifg=#005f87 guibg=#EEE8D5
    " 选中项
    "highlight PmenuSel ctermfg=2 ctermbg=3 guifg=#AFD700 guibg=#106900"

    " 不用每次提示加载.ycm_extra_conf.py文件
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

    " 关闭ycm的syntastic
    let g:ycm_show_diagnostics_ui = 0

    "let g:ycm_filetype_whitelist = {'c' : 1, 'cpp' : 1, 'java' : 1, 'python' : 1}
    let g:ycm_filetype_blacklist = {
                \ 'tagbar' : 1,
                \ 'qf' : 1,
                \ 'notes' : 1,
                \ 'markdown' : 1,
                \ 'unite' : 1,
                \ 'text' : 1,
                \ 'vimwiki' : 1,
                \ 'pandoc' : 1,
                \ 'infolog' : 1,
                \ 'mail' : 1,
                \ 'mundo': 1,
                \ 'fzf': 1,
                \ 'ctrlp' : 1
                \}

    " 评论中也应用补全
    let g:ycm_complete_in_comments = 1

    " 两个字开始补全
    let g:ycm_min_num_of_chars_for_completion = 2
    let g:ycm_seed_identifiers_with_syntax = 1
    let g:ycm_semantic_triggers =  {'c' : ['->', '.'], 'objc' : ['->', '.'], 'ocaml' : ['.', '#'], 'cpp,objcpp' : ['->', '.', '::'], 'php' : ['->', '::'], 'cs,java,javascript,vim,coffee,python,scala,go' : ['.'], 'ruby' : ['.', '::']}
    set completeopt-=preview
    nnoremap <Leader>j :YcmCompleter GoToDefinitionElseDeclaration<CR>"
endfunction
Plug 'jiangmiao/auto-pairs'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
function! LoadUltisnips()
    let g:UltiSnipsExpandTrigger="<C-j>"
endfunction

call plug#end()

if filereadable(expand("~/.vim/bundle/vim-airline/plugin/airline.vim"))
    execute LoadAirline('gruvbox')
endif

if filereadable(expand("~/.vim/bundle/gruvbox/README.md"))
    execute LoadColorSchemeGruvbox()
endif

if filereadable(expand("~/.vim/bundle/vim-devicons/README.md"))
    execute LoadDevicons()
endif

if filereadable(expand("~/.vim/bundle/goyo.vim/plugin/goyo.vim"))
    if filereadable(expand("~/.vim/bundle/limelight.vim/plugin/limelight.vim"))
        exec LoadGoyoLimelight()
    endif
endif

if filereadable(expand("~/.vim/bundle/vim-rtags/plugin/rtags.vim"))
    execute LoadRtags()
endif

if filereadable(expand("~/.vim/bundle/vim-fswitch/plugin/fswitch.vim"))
    execute LoadFswitch()
endif

if filereadable(expand("~/.vim/bundle/vim-protodef/plugin/protodef.vim"))
    execute LoadProtodef()
endif

if filereadable(expand("~/.vim/bundle/ultisnips/plugin/UltiSnips.vim"))
    execute LoadUltisnips()
endif

if filereadable(expand("~/.vim/bundle/vim-easy-align/easy_align.vim"))
    execute LoadEasyAlign()
endif

if filereadable(expand("~/.vim/bundle/DoxygenToolkit.vim/plugin/DoxygenToolkit.vim"))
    execute LoadDoxygen()
endif

if filereadable(expand("~/.vim/bundle/syntastic/plugin/syntastic.vim"))
    execute LoadSyntastic()
endif
" if filereadable(expand("~/.vim/bundle/ale/README.md"))
"     execute LoadAle()
" endif

if filereadable(expand("~/.vim/bundle/YouCompleteMe/plugin/youcompleteme.vim"))
    execute LoadYcm()
endif

if filereadable(expand("~/.vim/bundle/rainbow/plugin/rainbow.vim"))
    execute LoadRainbow()
endif

if filereadable(expand("~/.vim/bundle/fzf.vim/plugin/fzf.vim"))
    execute LoadFzf()
endif

if filereadable(expand("~/.vim/bundle/vim-gitgutter/README.mkd"))
    execute LoadGitGutter()
endif

if filereadable(expand("~/.vim/bundle/tagbar/README.md"))
    execute LoadTagbar()
endif

if filereadable(expand("~/.vim/bundle/unite.vim/plugin/unite.vim"))
    execute LoadUnite()
endif

if filereadable(expand("~/.vim/bundle/vimfiler.vim/plugin/vimfiler.vim"))
    execute LoadVimFiler()
endif

if filereadable(expand("~/.vim/bundle/vim-go/plugin/go.vim"))
    execute LoadVimGo()
endif
" }}}

" 快捷键 {{{
nnoremap LB 0
nnoremap LE $
noremap j gj
noremap k gk
noremap gj j
noremap gk k
nnoremap Y y$
vnoremap < <gv
vnoremap > >gv
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>WQ :wa<CR>:q<CR>
nnoremap <Leader>Q :qa!<CR>
nnoremap <Leader>cd :lcd %:h<CR>
nnoremap <Leader>' :terminal<CR>

nnoremap <C-w> <C-w>w
nnoremap <tab> <C-w>w
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j

nnoremap <F4> :call GeneratorTags()<cr><cr>

" 不确认、整词
nnoremap <Leader>rw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、非整词
nnoremap <Leader>rc :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、整词
nnoremap <Leader>rcw :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>
nnoremap <Leader>rwc :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>

vnoremap <Leader>fg :call VisualSelection()<CR>
nnoremap <Leader>fg :Ag 
" }}}
