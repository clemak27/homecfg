{ config, lib, pkgs, ... }:
let
in
{
  programs.nixvim = {
    enable = true;

    colorschemes.onedark.enable = true;

    opts = {
      clipboard = "unnamedplus";
      cursorline = true;
      cursorlineopt = "number";

      pumblend = 0;
      pumheight = 10;

      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      softtabstop = 2;

      ignorecase = true;
      smartcase = true;
      mouse = "a";
      cmdheight = 0;

      number = true;
      relativenumber = true;
      numberwidth = 2;

      signcolumn = "yes";
      splitbelow = true;
      splitright = true;
      splitkeep = "screen";
      termguicolors = true;
      timeoutlen = lib.mkDefault 400;

      conceallevel = 0;

      undofile = false;

      wrap = true;

      virtualedit = "block";
      winminwidth = 5;
      fileencoding = "utf-8";
      list = true;
      smoothscroll = true;
      fillchars = { eob = " "; };

      #interval for writing swap file to disk, also used by gitsigns
      updatetime = 550;
    };

    extraConfigLua = /* lua */''
      -- Autoload on file changes
      vim.api.nvim_create_augroup("reload_on_change", { clear = true })
      vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
        pattern = "*",
        group = "reload_on_change",
        callback = function()
          vim.api.nvim_exec2([[ if mode() != 'c' | checktime | endif ]], { output = false })
        end,
      })
      vim.api.nvim_create_autocmd({ "FileChangedShellPost" }, {
        pattern = "*",
        group = "reload_on_change",
        callback = function()
          vim.api.nvim_exec2(
            [[ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None ]],
            { output = false }
          )
        end,
      })

      ----------------------------------------- autocmds -----------------------------------------

      -- filetypes
      vim.api.nvim_create_augroup("coreos_ft", { clear = true })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.bu",
        group = "coreos_ft",
        callback = function()
          vim.api.nvim_exec2("set filetype=yaml", { output = false })
        end,
      })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.ign",
        group = "coreos_ft",
        callback = function()
          vim.api.nvim_exec2("set filetype=json", { output = false })
        end,
      })

      vim.api.nvim_create_augroup("linting_ft", { clear = true })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = ".yamllint",
        group = "linting_ft",
        callback = function()
          vim.api.nvim_exec2("set filetype=yaml", { output = false })
        end,
      })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = ".markdownlintrc",
        group = "linting_ft",
        callback = function()
          vim.api.nvim_exec2("set filetype=json", { output = false })
        end,
      })

      vim.api.nvim_create_augroup("tsconfig_ft", { clear = true })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "tsconfig.json",
        group = "coreos_ft",
        callback = function()
          vim.api.nvim_exec2("set filetype=jsonc", { output = false })
        end,
      })

      vim.api.nvim_create_augroup("todo_ft", { clear = true })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "todo.txt",
        group = "todo_ft",
        callback = function()
          vim.api.nvim_exec2("set filetype=todotxt", { output = false })
        end,
      })

      vim.api.nvim_create_augroup("hurl_ft", { clear = true })
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.hurl",
        group = "hurl_ft",
        callback = function()
          vim.api.nvim_exec2("set filetype=hurl", { output = false })
        end,
      })

      -- relative line numbers
      vim.api.nvim_create_augroup("numbertoggle", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
        pattern = "*",
        group = "numbertoggle",
        callback = function()
          vim.api.nvim_exec2([[ if &nu && mode() != "i" | set rnu | endif ]], { output = false })
        end,
      })
      vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
        pattern = "*",
        group = "numbertoggle",
        callback = function()
          vim.api.nvim_exec2([[ if &nu | set nornu | endif ]], { output = false })
        end,
      })

      -- don't show highlights after searching
      -- https://this-week-in-neovim.org/2023/Jan/9#tips
      local ns = vim.api.nvim_create_namespace("toggle_hlsearch")
      local function toggle_hlsearch(char)
        if vim.fn.mode() == "n" then
          local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
          local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

          if vim.opt.hlsearch:get() ~= new_hlsearch then
            vim.opt.hlsearch = new_hlsearch
          end
        end
      end

      vim.on_key(toggle_hlsearch, ns)

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
      -- Map save
      vim_map("gs", ":wa<CR>")
      ----------------------------------------- plugins -----------------------------------------

      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable", -- latest stable release
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup("plugins", {
        ui = {
          border = "single",
        },
        checker = {
          enabled = true,
          concurrency = nil,
          notify = true,
          frequency = 86400, -- 24h
          check_pinned = false,
        },
      })

      vim.api.nvim_create_augroup("lazyupdate", { clear = true })
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        pattern = "*",
        group = "lazyupdate",
        callback = function()
          if require("lazy.status").has_updates then
            require("lazy").update({ show = false })
          end
        end,
      })
    '';
  };
}
