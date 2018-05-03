let mapleader = "\<Space>"
set clipboard=unnamed
" /////////////////////////////////////////////////////////////////////////////
" vim-plug
" /////////////////////////////////////////////////////////////////////////////

call plug#begin('$HOME/.vim/bundle')

let vimrc_plugins_path = '$HOME/.vim/.vimrc.plugin'

if filereadable(expand(vimrc_plugins_path))
    exec 'source ' . fnameescape(vimrc_plugins_path)
endif

call plug#end()

set background=dark
colorscheme gruvbox
set guifont=DejaVu\ Sans\ Mono\ 13
" /////////////////////////////////////////////////////////////////////////////
" General
" /////////////////////////////////////////////////////////////////////////////

set tags=.tags

" Redefine the shell redirection operator to receive both the stderr messages and stdout messages
set shellredir=>%s\ 2>&1
set history=50 " keep 50 lines of command line history
set updatetime=1000 " default = 4000
set autoread " auto read same-file change ( better for vc/vim change )
set maxmempattern=1000 " enlarge maxmempattern from 1000 to ... (2000000 will give it without limit)

" /////////////////////////////////////////////////////////////////////////////
" Visual
" /////////////////////////////////////////////////////////////////////////////
set matchtime=0 " 0 second to show the matching paren ( much faster )
set nu " show line number
set scrolloff=0 " minimal number of screen lines to keep above and below the cursor
set nowrap " do not wrap text

" only supoort in 7.3 or higher
if v:version >= 703
    set noacd " no autochchdir
endif

" ------------------------------------------------------------------
" Desc: Vim UI
" ------------------------------------------------------------------

set wildmenu " turn on wild menu, try typing :h and press <Tab>
set showcmd " display incomplete commands
set cmdheight=1 " 1 screen lines to use for the command-line
set ruler " show the cursor position all the time
set hidden " allow to change buffer without saving
set shortmess=aoOtTI " shortens messages to avoid 'press a key' prompt
set lazyredraw " do not redraw while executing macros (much faster)
set display+=lastline " for easy browse last line with wrap text
set laststatus=2 " always have status-line
set titlestring=%t\ (%{expand(\"%:p:.:h\")}/)

set showfulltag " show tag with function protype.
set guioptions+=b " present the bottom scrollbar when the longest visible line exceed the window

" disable menu & toolbar
set guioptions-=T

" ------------------------------------------------------------------
" Desc: Text edit
" ------------------------------------------------------------------

set ai " autoindent
set si " smartindent
set backspace=indent,eol,start " allow backspacing over everything in insert mode
" indent options
" see help cinoptions-values for more details
set	cinoptions=>s,e0,n0,f0,{0,}0,^0,:0,=s,l0,b0,g0,hs,ps,ts,is,+s,c3,C0,0,(0,us,U0,w0,W0,m0,j0,)20,*30
" default '0{,0},0),:,0#,!^F,o,O,e' disable 0# for not ident preprocess
" set cinkeys=0{,0},0),:,!^F,o,O,e

set cindent shiftwidth=4 " set cindent on to autoinent when editing c/c++ file, with 4 shift width
set tabstop=4 " set tabstop to 4 characters
set expandtab " set expandtab on, the tab will be change to space automaticaly
set ve=block " in visual block mode, cursor can be positioned where there is no actual character

" set Number format to null(default is octal) , when press CTRL-A on number
" like 007, it would not become 010
set nf=

" ------------------------------------------------------------------
" Desc: Fold text
" ------------------------------------------------------------------

set foldmethod=marker foldmarker={,} foldlevel=9999
set diffopt=filler,context:9999

" ------------------------------------------------------------------
" Desc: Search
" ------------------------------------------------------------------

set showmatch " show matching paren
set incsearch " do incremental searching
set hlsearch " highlight search terms
set ignorecase " set search/replace pattern to ignore case
set smartcase " set smartcase mode on, If there is upper case character in the search patern, the 'ignorecase' option will be override.

" set this to use id-utils for global search
set grepprg=lid\ -Rgrep\ -s
set grepformat=%f:%l:%m

"/////////////////////////////////////////////////////////////////////////////
" Key Mappings
"/////////////////////////////////////////////////////////////////////////////

" NOTE: F10 looks like have some feature, when map with F10, the map will take no effects

" Don't use Ex mode, use Q for formatting
map Q gq

nnoremap <leader>in :setl noai nocin nosi inde=<CR>

" Search and Replace
nnoremap <leader>re yiw:%s/\<<C-r>"\>//g<left><left>
vnoremap <leader>re y:%s/\<<C-r>"\>//g<left><left>

" CTRL-A is Select all
noremap <leader>a gggH<C-O>G
" inoremap <leader>a <C-O>gg<C-O>gH<C-O>G
cnoremap <leader>a <C-C>gggH<C-O>G
onoremap <leader>a <C-C>gggH<C-O>G
snoremap <leader>a <C-C>gggH<C-O>G
xnoremap <leader>a <C-C>ggVG

" Move line up and down
nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi
vnoremap <A-Up> :m '<-2<CR>gv=gv
vnoremap <A-Down> :m '>+1<CR>gv=gv

" F8 or <leader>/:  Set Search pattern highlight on/off
nnoremap <F8> :noh<CR>
inoremap <F8> :noh<CR>

" easy buffer navigation
" NOTE: if we already map to EXbn,EXbp. skip setting this
if !hasmapto(':EXbn<CR>') && mapcheck('<C-l>','n') == ''
    nnoremap <leader>n :bn<CR>
endif
set mouse=a

" Highlight all instances of word under cursor, when idle.
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction
