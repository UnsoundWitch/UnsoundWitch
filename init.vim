" hidden vim config here :)
set nocompatible              " vim, not vi

"  UI
syntax on
set background=light
set number                    " line numbers
set showmode
set nocursorline
set backspace=indent,eol,start
set wildmenu                  " menu has tab completion
set ruler                     " show the line number on the bar
set mouse=a                   " enable mouse
set scrolloff=5               " keep at least 5 lines above/below
set sidescrolloff=5           " keep at least 5 lines left/right
set lazyredraw                " don't redraw when don't have to
set more                      " use more prompt
set hidden

"  text
set tabstop=4                 " 6 spaces
set autoread                  " watch for file changes
set linebreak
setlocal spelllang=en_us

"  edit
set cmdheight=2               " command line two lines high
set undolevels=1000           " 1000 undos
set updatecount=100           " switch every 100 chars
set complete=.,w,b,u,U,t,i,d  " do lots of scanning on tab completion
set noautowrite               " don't automatically write on :next
set fileformats=unix
set autoindent smartindent    " auto/smart indent
set history=200
set shiftwidth=4

"  misc
set ttyfast                   " we have a fast terminal
set noerrorbells              " No error bells please
set shell=zsh
filetype on                   " Enable filetype detection
filetype indent on            " Enable filetype-specific indenting
filetype plugin on            " Enable filetype-specific plugins
set showcmd
set smarttab                  " tab and backspace are smart
set expandtab
set wildmode=longest:full
let maplocalleader=','        " all my macros start with ,
set laststatus=2
set showtabline=2
set guioptions=

"  searching
set incsearch                 " incremental search
set ignorecase                " search ignoring case
set hlsearch                  " highlight the search
set showmatch                 " show matching bracket
set diffopt=filler,iwhite     " ignore all whitespace and sync

call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'

call plug#end()



"  custom command
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis

"  keybinding

lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "hls", "ocamlls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

let mapleader=" "

nnoremap <Leader>bp :bprevious<CR>
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bf :bfirst<CR>
nnoremap <Leader>bl :blast<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>bk :bw<CR>
nnoremap <Leader>bi :buffers<CR>

nnoremap <Leader>xs :terminal<CR>
nnoremap <Leader>xq :q<CR>

nnoremap <Leader>w- :split<CR>
nnoremap <Leader>w/ :vsplit<CR>
nnoremap <Leader>ws :wall<CR>

nnoremap <Leader>cp :cprevious<CR>
nnoremap <Leader>cn :cnext<CR>
nnoremap <Leader>ci :clist<CR>
nnoremap <Leader>cm :make<CR>

nnoremap <Leader>ed :DiffOrig<CR>
nnoremap <Leader>es :mkview<CR>
nnoremap <Leader>el :loadview<CR>
nnoremap <Leader>ef zfap<CR>
nnoremap <Leader>eu :earlier<CR>
nnoremap <Leader>el :later<CR>
nnoremap <Leader>ea :undolist<CR>

nnoremap <Leader>so :set spell<CR>
nnoremap <Leader>sc :set nospell<CR>
nnoremap <Leader>sf z=<CR>

nnoremap <Leader>oh :TOhtml<CR>

nnoremap <F5> :call LanguageClient_contextMenu()<CR>
map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
map <Leader>lb :call LanguageClient#textDocument_references()<CR>
map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
