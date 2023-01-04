-- ---------------------------------------- lspconfig --------------------------------------------------------

local M = {}

M.load = function()
  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
    end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- saga
    local saga = require("lspsaga")
    saga.init_lsp_saga({
      code_action_lightbulb = {
        enable = false,
      },
    })

    -- See :help vim.lsp.* for documentation on any of the below functions
    buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    buf_set_keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
    buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
    buf_set_keymap("n", "gf", "<cmd>lua vim.lsp.buf.format { async = true }<CR>", opts)
    buf_set_keymap("n", "<space>u", "<cmd>Lspsaga rename<CR>", opts)
    buf_set_keymap("n", "<space>a", "<cmd>Lspsaga code_action()<CR>", opts)
    buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  end

  -- config that activates keymaps and enables snippet support
  local function make_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
      -- enable snippet support
      capabilities = capabilities,
      -- map buffer local keybindings when the language server attaches
      on_attach = on_attach,
    }
  end

  local lspconfig = require("lspconfig")

  require("mason-lspconfig").setup()

  local servers = {
    "bashls",
    "cssls",
    "golangci_lint_ls",
    "gopls",
    "gradle_ls",
    "html",
    "jdtls",
    "jsonls",
    "rnix",
    "sumneko_lua",
    "texlab",
    "tsserver",
    "vimls",
    "vuels",
    "yamlls",
  }

  local function setup_servers()
    for _, server in pairs(servers) do
      local config = make_config()

      if server == "bashls" then
        config.filetypes = { "bash", "sh", "zsh" }
      end

      if server == "jsonls" then
        config.filetypes = { "json", "json5" }
      end

      if server == "sumneko_lua" then
        local runtime_path = vim.split(package.path, ";")
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")
        config.cmd = { "lua-language-server" }
        config.settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
              -- Setup your lua path
              path = runtime_path,
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        }
      end

      if server == "gopls" then
        config.settings = {
          gopls = {
            gofumpt = true,
          },
        }
      end

      if server == "gradle_ls" then
        config.settings = {
          gradleWrapperEnabled = true,
        }
      end
      -- java is setup in jdtls-config
      if server ~= "jdtls" then
        lspconfig[server].setup(config)
      end
    end
  end

  setup_servers()

  -- customize signs
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  -- show borders around lspconfig windows
  require("lspconfig.ui.windows").default_options.border = "single"

  -- format on save
  vim.api.nvim_create_augroup("format_on_write", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*.go,*.js,*.ts,*.lua,*.bash,*.sh",
    group = "format_on_write",
    callback = function()
      vim.lsp.buf.formatting_seq_sync(nil, 500)
    end,
  })

  -- setup fidget
  require("fidget").setup({
    window = {
      blend = 0,
    },
  })
end

return M
