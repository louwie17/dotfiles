" be iMproved
set nocompatible

" required for Vundle"
filetype off

" map jj to enter normal mode
imap jj <Esc>

" use OS clipboard for paste
noremap p "+p

" use OS clipboard for yank
noremap y "+y

" allow space to be used the same as :
nnoremap <Space> :

" Vundle!
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'

" powerline across bottom
Bundle 'Lokaltog/powerline'

" peaksea color scheme
Bundle 'peaksea'

" toggle comments
Bundle 'tComment'

" vertical indentation bars
Bundle 'nathanaelkane/vim-indent-guides'

" align statements usually by the = character
Bundle 'vim-scripts/Align'

" open files with : notation to go to a given line
Bundle 'bogado/file-line'

" go vim plugin
Bundle 'vim-go'

" Node.js vim plugin
Bundle 'vim-node'

" JSON highlighting
Bundle 'vim-json'

" Typescript bundle
Bundle 'typescript-vim'

" You Complete Me - Auto complete
Bundle 'Valloric/YouCompleteMe'

" These are the tweaks I apply to YCM's config, you don't need them but they might help.
" YCM gives you popups and splits by default that some people might not like, so these should tidy it up a bit for you.
let g:ycm_add_preview_to_completeopt=0
let g:ycm_confirm_extra_conf=0
set completeopt-=preview

" Tern for JS
Plugin 'marijnh/tern_for_vim'

" required for Vundle
filetype plugin indent on

" backspace in insert mode works like normal editor
set backspace=2

" auto indenting
set autoindent

" get rid of annoying ~file
set nobackup

set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set ruler
syntax enable

" Use two spaces as tabs for Javascript
function! SetAltPrefs()
    set shiftwidth=2
endfunction
autocmd FileType xml,html,xhtml,javascript,json,less,css call SetAltPrefs()

set incsearch
set ignorecase
set linebreak
set scrolloff=3
set mouse=nicr

set background=dark
color peaksea

" add warning line at 80 characters of column
if exists('+colorcolumn')
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Show trailing whitespace
au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\s\+$', -1)

" fix common mistakes
com! W w
com! Q q
com! Wq wq
com! WQ wq

" use <Leader>ig to toggle indentation highlighting
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=236
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=237
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size  = 1
if !has("gui_running")
    let g:indent_guides_auto_colors = 0
endif

" powerline
set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim/

" Always show statusline
set laststatus=2

" Use 256 colours
set t_Co=256
