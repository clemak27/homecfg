----------------------------------------- general settings -----------------------------------------

-- enable termguicolors for colorschemes
vim.o.termguicolors = true
-- enable mouse support
vim.o.mouse = 'a'
-- line number
vim.o.number = true
-- use system clipboard
vim.cmd [[set clipboard+=unnamedplus]]
-- Sets how many lines of history VIM has to remember
vim.o.history = 500
-- Set to auto read when a file is changed from the outside
vim.o.autoread = true
-- Set 7 lines to the cursor - when moving vertically using j/k
vim.o.so = 7
-- Turn on the Wild menu
vim.o.wildmenu = true
-- Ignore compiled files
vim.o.wildignore = '*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store'
--Always show current position
vim.o.ruler = true
-- Height of the command bar
vim.o.cmdheight = 2
-- A buffer becomes hidden when it is abandoned
vim.o.hid = true
-- Ignore case when searching
vim.o.ignorecase = true
-- When searching try to be smart about cases
vim.o.smartcase = true
-- Highlight search results
vim.o.hlsearch = true
-- Makes search act like search in modern browsers
vim.o.incsearch = true
-- Don't redraw while executing macros (good performance config)
vim.o.lazyredraw = true
-- For regular expressions turn magic on
vim.o.magic = true
-- Show matching brackets when text indicator is over them
vim.o.showmatch = true
-- How many tenths of a second to blink when matching brackets
vim.o.mat = 2
-- No annoying sound on errors
vim.o.t_vb = ''
vim.o.tm = 500
-- Set utf8 as standard encoding and en_US as the standard language
vim.o.encoding = 'utf8'
-- Use Unix as the standard file type
vim.o.ffs = 'unix,dos,mac'
-- Use spaces instead of tabs
vim.o.expandtab = true
-- Be smart when using tabs
vim.o.smarttab = true
-- 1 tab == 2 spaces
vim.o.shiftwidth = 2
vim.o.tabstop = 2
-- Auto indent
vim.o.ai = true
-- Smart indent
vim.o.si = true
-- Wrap lines
vim.o.wrap = true
-- Always show the status line
vim.o.laststatus = 3
-- Always show the tab/buffer line
vim.o.showtabline = 2

vim.api.nvim_exec([[
  " Dont show mode in statusline
  set noshowmode
  " E355: Unknown option: noshowmode
  
  " Configure backspace so it acts as it should act
  set backspace=eol,start,indent
  set whichwrap+=<,>,h,l
  " Turn backup off
  set nobackup
  set nowb
  set noswapfile
  " E355: Unknown option: nobackup
  " E355: Unknown option: nowb
  " E355: Unknown option: noswapfile
]], false)


vim.api.nvim_exec([[
  " Specify the behavior when switching between buffers
  try
    set switchbuf=useopen,usetab,newtab
    set stal=0
  catch
  endtry
  
  au BufNewFile,BufRead *.nix setfiletype nix
  
  " Return to last edit position when opening files (You want this!)
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  
  " Delete trailing white space on save
  fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
  endfun
  
  if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
  endif
  
  " Autoload on file changes
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

]], false)

----------------------------------------- mappings -----------------------------------------

local function vim_map(keyMap, action)
  local opt = { noremap = false, silent = true }
  vim.api.nvim_set_keymap("", keyMap, action, opt)
end

local function vim_noremap(keyMap, action)
  local opt = { noremap = true, silent = true }
  vim.api.nvim_set_keymap("", keyMap, action, opt)
end

local function vim_nmap(keyMap, action)
  local opt = { noremap = false, silent = true }
  vim.api.nvim_set_keymap("n", keyMap, action, opt)
end

-- Set mapleader to space
vim.g.mapleader = " "
-- Smart way to move between windows
vim_map("<C-j>", "<C-W>j")
vim_map("<C-k>", "<C-W>k")
vim_map("<C-h>", "<C-W>h")
vim_map("<C-l>", "<C-W>l")
-- Move a line of text using ALT+[jk]
vim_nmap("<M-j>", "mz:m+<cr>`z")
vim_nmap("<M-k>", "mz:m-2<cr>`z")
-- Disable arrow keys
vim_noremap("<Up>", "<Nop>")
vim_noremap("<Down>", "<Nop>")
vim_noremap("<Left>", "<Nop>")
vim_noremap("<Right>", "<Nop>")
-- Remap 0 and § to first non-blank character
vim_map("§", "^")
vim_map("0", "^")
-- Remap ß to end of line
vim_map("ß", "$")

----------------------------------------- plugins -----------------------------------------

require('plugins').load()
