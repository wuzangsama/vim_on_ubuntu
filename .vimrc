" @file .vimrc
" @brief
" @author zhanghf@zailingtech.com
" @version 1.0
" @date 2017-07-29

"=========================================
" 基础>>
"=========================================

set nocompatible " 关闭兼容模式
let mapleader=';' " 定义快捷键的前缀，即 <leader>

set mouse=a
set mousehide
set gcr=a:block-blinkon0 " 禁止光标闪烁
set backspace=indent,eol,start " 退格键可用删除

" 禁止显示滚动条和菜单、工具条
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=m
set guioptions-=T

set laststatus=2 " 总是显示状态栏
function! s:statusline_expr()
    let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
    let ro  = "%{&readonly ? '[RO] ' : ''}"
    let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
    let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
    let sep = ' %= '
    let pos = ' %-12(%l : %c%V%) '
    let pct = ' %P '

    return '[%n] %w%h%m%r %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()

set ruler " 显示光标当前位置

" 滚动保留行数
set scrolloff=3
set sidescroll=1
set sidescrolloff=10

" 退出保留显示
" set t_ti=
" set t_te=

" 设置list
set list
set listchars=tab:›\ ,trail:•

set wildmenu " vim 自身命令行模式智能补全
set wildmode=list:longest
set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.so,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files
set wildignore+=*.fasl                           " Lisp FASLs

set lazyredraw
set ttyfast

" 开启行号显示
set number
set relativenumber

" 高亮显示当前行/列
set cursorline
"set cursorcolumn

set hlsearch " 高亮显示搜索结果
set incsearch " 开启实时搜索功能
set ignorecase " 搜索时大小写不敏感
set nowrap " 禁止折行
set expandtab " 将制表符扩展为空格
set tabstop=4 " 设置编辑时制表符占用空格数
set shiftwidth=4 " 设置格式化时制表符占用空格数
set softtabstop=4 " 让 vim 把连续数量的空格视为一个制表符

" 基于缩进或语法进行代码折叠
" set foldmethod=indent
" set foldlevel=2
set nofoldenable " 启动 vim 时关闭折叠代码
set formatoptions+=m " 如遇Unicode值大于255的文本，不必等到空格再折行
set formatoptions+=B " 合并两行中文时，不在中间加空格

set encoding=utf-8 " 设置新文件的编码为 UTF-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1 " 自动判断编码时，依次尝试以下编码：
set helplang=cn
set termencoding=utf-8 " 这句只影响普通模式 (非图形界面) 下的 Vim
set ffs=unix,dos,mac " Use Unix as the standard file type

syntax enable " 开启语法高亮功能
syntax on " 允许用指定语法高亮配色方案替换默认方案
filetype on " 开启文件类型侦测
filetype plugin on " 根据侦测到的不同类型加载对应的插件
filetype indent on " 自适应不同语言的智能缩进

set guifont=Source\ Code\ Pro\ for\ Powerline:h14 " 设置 gvim 显示字体

augroup posreset
    au!
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif " 启动后定位到上次关闭光标位置
    "autocmd BufWritePost $MYVIMRC source $MYVIMRC " 让配置变更立即生效
augroup END

augroup fileset
    au!
    autocmd FileType haskell,puppet,ruby,yaml setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType markdown,text setlocal wrap
augroup END

if has('nvim')
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    let g:python_host_prog='/usr/bin/python'
    let g:python3_host_prog = '/usr/bin/python3'
endif

"=========================================
" <<基础
"=========================================


"=========================================
" 插件安装>>
"=========================================

filetype off
" vim-plug 管理的插件列表必须位于 call plug#begin() 和 call plug#end() 之间
if has('nvim')
    call plug#begin('~/.config/nvim/bundle')
else
    call plug#begin('~/.vim/bundle')
endif

" 属性增强
Plug 'MarcWeber/vim-addon-mw-utils'

" 外观
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'
Plug 'luochen1990/rainbow'
Plug 'junegunn/vim-emoji'

" 一般功能
Plug 'Yggdroot/indentLine'
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/matchit.zip'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'nvie/vim-togglemouse'
Plug 'Shougo/vinarise.vim'
Plug 'shougo/vimshell.vim'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'shougo/vimfiler.vim'
Plug 'Shougo/unite.vim'
Plug 'shougo/unite-outline'
Plug 'shougo/neomru.vim'
Plug 'shougo/neoyank.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" 写作
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'iamcco/mathjax-support-for-mkdp'
Plug 'iamcco/markdown-preview.vim'

" 所有语言
Plug 'junegunn/vim-easy-align'
Plug 'tomtom/tcomment_vim' " 注释 gcc gcu gcap

" CPP
Plug 'octol/vim-cpp-enhanced-highlight',{'for': 'cpp'}
Plug 'derekwyatt/vim-fswitch',{'for': 'cpp'}
Plug 'derekwyatt/vim-protodef',{'for': 'cpp'}
Plug 'vim-scripts/DoxygenToolkit.vim',{'for': ['cpp', 'c']}
Plug 'vim-scripts/vim-unite-cscope',{'for': ['cpp', 'c']}

" GoLang
Plug 'fatih/vim-go'
Plug 'buoto/gotests-vim'

" 语法检测
Plug 'w0rp/ale',{'for': ['go']}
Plug 'vim-syntastic/syntastic',{'for': ['cpp', 'c']}

" 自动补全
Plug 'Valloric/YouCompleteMe', {'do': './install.py --clang-completer --system-libclang'}
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif
" Plug 'Shougo/neco-syntax'
" Plug 'zchee/deoplete-go', { 'do': 'make'}
" Plug 'tweekmonster/deoplete-clang2'
" Plug 'ervandew/supertab'
Plug 'jiangmiao/auto-pairs'
Plug 'SirVer/ultisnips'


" 插件列表结束
call plug#end()

"=========================================
" <<插件安装
"=========================================


"=========================================
" >>插件配置
"=========================================

" 配色方案
set t_Co=256

function! LoadColorSchemeSolarized()
    set background=dark
    colorscheme solarized
    let g:solarized_termtrans=1
    let g:solarized_contrast="normal"
    let g:solarized_visibility="normal"
    let g:solarized_termcolors=256"
endfunction

function! LoadColorSchemeMolokai()
    set background=dark
    colorscheme molokai
    let g:molokai_original = 1
    let g:rehash256 = 1
endfunction

function! LoadColorSchemeGruvbox()
    set background=dark
    colorscheme gruvbox
endfunction

function! LoadColorSchemeSeoul256()
    let g:indentLine_color_term = 239
    let g:indentLine_color_gui = '#616161'

    set background=dark
    colorscheme seoul256
endfunction

if has('gui')
    execute LoadColorSchemeGruvbox()
else
    execute LoadColorSchemeGruvbox()
endif

function! LoadEmoji()
    let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
    let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
    let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
    let g:gitgutter_sign_modified_removed = emoji#for('collision')
endfunction
" if filereadable(expand("~/.vim/bundle/vim-emoji/README.md"))
"     execute LoadEmoji()
" endif

function! LoadGoyo()
    autocmd! User GoyoEnter Limelight
    autocmd! User GoyoLeave Limelight!
endfunction
if filereadable(expand("~/.vim/bundle/goyo.vim/plugin/goyo.vim"))
    if filereadable(expand("~/.vim/bundle/limelight.vim/plugin/limelight.vim"))
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
        exec LoadGoyo()
    endif
endif

" *.cpp 和 *.h 间切换
function! LoadFswitch()
    nnoremap <silent> <leader>a :FSHere<cr>
endfunction
if filereadable(expand("~/.vim/bundle/vim-fswitch/plugin/fswitch.vim"))
    execute LoadFswitch()
endif

" 由接口快速生成实现框架
function! LoadProtodef()
    " 设置 pullproto.pl 脚本路径
    if has('nvim')
        let g:protodefprotogetter='~/.config/nvim/bundle/vim-protodef/pullproto.pl'
    else
        let g:protodefprotogetter='~/.vim/bundle/vim-protodef/pullproto.pl'
    endif
    " 成员函数的实现顺序与声明顺序一致
    let g:disable_protodef_sorting=1
endfunction
if filereadable(expand("~/.vim/bundle/vim-protodef/plugin/protodef.vim"))
    execute LoadProtodef()
endif

function! LoadUltisnips()
    let g:UltiSnipsSnippetDirectories=["mysnippets"] " snippets位置
    let g:UltiSnipsExpandTrigger="<leader><tab>" " 防止和ycm冲突
    let g:UltiSnipsJumpForwardTrigger="<leader><tab>"
    let g:UltiSnipsJumpBackwardTrigger="<leader><s-tab>"
endfunction
if filereadable(expand("~/.vim/bundle/ultisnips/plugin/UltiSnips.vim"))
    execute LoadUltisnips()
endif

function! LoadEasyAlign()
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
endfunction
if filereadable(expand("~/.vim/bundle/vim-easy-align/easy_align.vim"))
    execute LoadEasyAlign()
endif

function! LoadDoxygen()
    let g:DoxygenToolkit_authorName="zhanghf@zailingtech.com"
    let g:DoxygenToolkit_versionString="1.0"
    nnoremap <leader>da <ESC>gg:DoxAuthor<CR>
    nnoremap <leader>df <ESC>:Dox<CR>
endfunction
if filereadable(expand("~/.vim/bundle/DoxygenToolkit.vim/plugin/DoxygenToolkit.vim"))
    execute LoadDoxygen()
endif

function! LoadAle()
    let g:ale_open_list=1
    let g:ale_set_quickfix=1
    let g:ale_lint_on_text_changed='never'
    let g:ale_linters = {'go':['gometalinter','gofmt']}
endfunction
if filereadable(expand("~/.vim/bundle/ale/plugin/ale.vim"))
    execute LoadAle()
endif

function! LoadSyntastic()
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_cpp_checkers = ['clang_check']
    let g:syntastic_c_checkers = ['clang_check']
    let g:syntastic_clang_check_config_file = '.clang'

    " let g:syntastic_go_checkers = ['golint', 'govec', 'gometalinter']
    " let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=errcheck']
endfunction
if filereadable(expand("~/.vim/bundle/syntastic/plugin/syntastic.vim"))
    execute LoadSyntastic()
endif

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
    nnoremap <leader>j :YcmCompleter GoToDefinitionElseDeclaration<CR>"
endfunction
if filereadable(expand("~/.vim/bundle/YouCompleteMe/plugin/youcompleteme.vim"))
    execute LoadYcm()
endif

function! LoadDeoplete()
    " set completeopt+=noselect
    set completeopt-=preview
    let g:SuperTabDefaultCompletionType = "<c-n>"
    let g:deoplete#enable_at_startup = 1
    let g:deoplete#sources#clang#executable = '/Users/zhanghaifeng/clang/bin/clang'
    let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
    let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
endfunction
if filereadable(expand("~/.vim/bundle/deoplete.nvim/plugin/deoplete.vim"))
    exec LoadDeoplete()
endif

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
if filereadable(expand("~/.vim/bundle/rainbow/plugin/rainbow.vim"))
    execute LoadRainbow()
endif

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
    nnoremap <Space>t :BTags<cr>
    nnoremap <Space>f :Files<cr>
    nnoremap <Space>m :Marks<cr>
    nnoremap <Space>hs :History/<cr>
    nnoremap <Space>hc :History:<cr>
endfunction
" execute LoadFzf()

function! LoadUnite()
    nnoremap <Space><Space> :Unite<cr>
    nnoremap <Space>f :Unite file_rec/async<cr>
    nnoremap <Space>b :Unite buffer<cr>
    nnoremap <Space>r :Unite file_mru<cr>
    nnoremap <Space>o :Unite outline<cr>
    nnoremap <Space>hy :Unite history/yank<cr>
    nnoremap <Space>ci :Unite cscope/functions_calling<cr>
    nnoremap <Space>cb :Unite cscope/functions_called_by<cr>
    nnoremap <Space>cf :Unite cscope/find_this_symbol<cr>
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
if filereadable(expand("~/.vim/bundle/unite.vim/plugin/unite.vim"))
    execute LoadUnite()
endif

function! LoadVimFiler()
    nnoremap <F3> :VimFilerExplorer<CR>
    inoremap <F3> <ESC>:VimFilerExplorer<CR>
    vnoremap <F3> <ESC>:VimFilerExplorer<CR>
    let g:vimfiler_as_default_explorer = 1
    let g:vimfiler_restore_alternate_file = 1
    let g:vimfiler_tree_indentation = 1
    let g:vimfiler_tree_leaf_icon = ''
    let g:vimfiler_tree_opened_icon = '▼'
    let g:vimfiler_tree_closed_icon = '▷'
    let g:vimfiler_file_icon = ''
    let g:vimfiler_readonly_file_icon = '*'
    let g:vimfiler_marked_file_icon = '√'
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
if filereadable(expand("~/.vim/bundle/vimfiler.vim/plugin/vimfiler.vim"))
    execute LoadVimFiler()
endif

function! LoadSmoothScroll()
    noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
    noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
    noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
    noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>
endfunction
" execute LoadSmoothScroll()

function! LoadVimGo()
    let g:go_fmt_command = "goimports"
    let g:go_autodetect_gopath = 1
    let g:go_list_type = "quickfix"

    let g:go_highlight_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_generate_tags = 1

    " Open :GoDeclsDir with ctrl-g
    nmap <C-g> :GoDeclsDir<cr>
    imap <C-g> <esc>:<C-u>GoDeclsDir<cr>

    augroup go
        autocmd!

        " Show by default 4 spaces for a tab
        autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

        " :GoBuild and :GoTestCompile
        autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

        " :GoTest
        autocmd FileType go nmap <leader>t  <Plug>(go-test)

        " :GoRun
        autocmd FileType go nmap <leader>r  <Plug>(go-run)

        " :GoDoc
        autocmd FileType go nmap <leader>d <Plug>(go-doc)

        " :GoCoverageToggle
        autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)

        " :GoInfo
        autocmd FileType go nmap <leader>i <Plug>(go-info)

        " :GoMetaLinter
        autocmd FileType go nmap <leader>l <Plug>(go-metalinter)

        " :GoDef but opens in a vertical split
        autocmd FileType go nmap <leader>v <Plug>(go-def-vertical)
        " :GoDef but opens in a horizontal split
        autocmd FileType go nmap <leader>s <Plug>(go-def-split)

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
endfunction
if filereadable(expand("~/.vim/bundle/vim-go/plugin/go.vim"))
    execute LoadVimGo()
endif

function! LoadTagbar()
    nnoremap <F2> :TagbarToggle<CR>
    inoremap <F2> <ESC>:TagbarToggle<CR>
    vnoremap <F2> <ESC>:TagbarToggle<CR>
endfunction
if filereadable(expand("~/.vim/bundle/tagbar/plugin/tagbar.vim"))
    execute LoadTagbar()
endif

function! LoadCtrlSF()
    let g:ctrlsf_ackprg = 'ag'
    let g:ctrlsf_auto_close = 1
    let g:ctrlsf_case_sensitive = 'no'
    let g:ctrlsf_ignore_dir = ['.git', '.svn']
endfunction
if filereadable(expand("~/.vim/bundle/ctrlsf.vim/plugin/ctrlsf.vim"))
    execute LoadCtrlSF()
endif

function! LoadMarkdown()
    let g:mkdp_path_to_chrome = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome"
endfunction
if filereadable(expand("~/.vim/bundle/markdown-preview.vim/plugin/mkdp.vim"))
    execute LoadMarkdown()
endif

"=========================================
" <<插件配置
"=========================================


"=========================================
" 快捷键>>
"=========================================

" 定义快捷键到行首和行尾
nnoremap LB 0
nnoremap LE $

noremap j gj
noremap k gk
noremap gj j
noremap gk k

" 复制到行尾
nnoremap Y y$

" 选中连续缩进
vnoremap < <gv
vnoremap > >gv

" 定义快捷键关闭当前分割窗口
nnoremap <leader>q :q<CR>
" 定义快捷键保存当前窗口内容
nnoremap <leader>w :w<CR>
" 定义快捷键保存所有窗口内容并退出 vim
nnoremap <leader>WQ :wa<CR>:q<CR>
" 不做任何保存，直接退出 vim
nnoremap <leader>Q :qa!<CR>

nnoremap <leader>/ :nohlsearch<CR>

cmap cwd lcd %:p:h
cmap cd. lcd %:p:h

" 设置快捷键遍历子窗口
" 依次遍历
nnoremap <C-w> <C-w>w
nnoremap <tab> <C-w>w
" 跳转至右方的窗口
nnoremap <C-l> <C-w>l
" 跳转至方的窗口
nnoremap <C-h> <C-w>h
" 跳转至上方的子窗口
nnoremap <C-k> <C-w>k
" 跳转至下方的子窗口
nnoremap <C-j> <C-w>j

" 库信息参考
source $VIMRUNTIME/ftplugin/man.vim
" 定义;h命令查看各类man信息的快捷键
nnoremap <leader>h :Man 3 <cword><CR>

if has("cscope")
    set csprg=/usr/bin/cscope              "指定用来执行 cscope 的命令
    set csto=1                             "先搜索tags标签文件，再搜索cscope数据库
    set cst                                "使用|:cstag|(:cs find g)，而不是缺省的:tag
    set nocsverb                           "不显示添加数据库是否成功
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out                   "添加cscope数据库
    endif
    set csverb                             "显示添加成功与否
endif

nnoremap <F4> :call GeneratorTags()<cr><cr><cr><cr>
func! GeneratorTags()
    exec "!ctags -R --sort=1 --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ ."
    exec "!find . -name \"*.c\" -o -name \"*.cpp\" -o -name \"*.h\" -o -name \"*.hpp\" > cscope.files"
    exec "!cscope -q -R -b -i cscope.files"
endfunc

"C，C++ 按F7编译运行
nnoremap <F7> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -std=c++11 -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    endif
endfunc

" 精准替换
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
" 不确认、非整词
nnoremap <leader>R :call Replace(0, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 不确认、整词
nnoremap <leader>rw :call Replace(0, 1, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、非整词
nnoremap <leader>rc :call Replace(1, 0, input('Replace '.expand('<cword>').' with: '))<CR>
" 确认、整词
nnoremap <leader>rcw :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>
nnoremap <leader>rwc :call Replace(1, 1, input('Replace '.expand('<cword>').' with: '))<CR>

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
" Remove trailing whitespaces and ^M chars
autocmd FileType c,cpp,java,php,javascript,python,rust,xml,yaml,perl,sql autocmd BufWritePre <buffer> call StripTrailingWhitespace()
nnoremap <silent> <F10> :call StripTrailingWhitespace()<CR>

" 搜索选中项 {
function! VisualSelection() range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    execute 'CtrlSF '.l:pattern

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
" function! NormalSelection() range
"     let l:saved_reg = @"
"     execute "normal! viwy"
"
"     let l:pattern = escape(@", '\\/.*$^~[]')
"     let l:pattern = substitute(l:pattern, "\n$", "", "")
"
"     execute 'CtrlSF '.l:pattern
"
"     let @/ = l:pattern
"     let @" = l:saved_reg
" endfunction
vnoremap <Space>g :call VisualSelection()<CR>
" nnoremap <Space>g :call NormalSelection()<CR>
nnoremap <Space>g :CtrlSF 

" 将外部命令 wmctrl 控制窗口最大化的命令行参数封装成一个 vim 的函数
" fun! ToggleFullscreen()
" 	call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")
" endf
" 启动 vim 时自动全屏
"autocmd VimEnter * call ToggleFullscreen()
" 全屏开/关快捷键
"map <silent> <F11> :call ToggleFullscreen()<CR>

"=========================================
" <<快捷键
"=========================================
