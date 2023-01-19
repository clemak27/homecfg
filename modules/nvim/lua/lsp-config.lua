-- ---------------------------------------- lspconfig --------------------------------------------------------

local M = {}

M.load = function()
  local set_border = function()
    local border = {
      { "╭", "FloatBorder" },
      { "─", "FloatBorder" },
      { "╮", "FloatBorder" },
      { "│", "FloatBorder" },
      { "╯", "FloatBorder" },
      { "─", "FloatBorder" },
      { "╰", "FloatBorder" },
      { "│", "FloatBorder" },
    }

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = border,
    })
  end

  local set_mappings = function()
    -- See :help vim.lsp.* for documentation on any of the below functions
    local builtin = require("telescope.builtin")
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "gd", builtin.lsp_definitions, bufopts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gr", builtin.lsp_references, bufopts)
    vim.keymap.set("n", "gi", builtin.lsp_implementations, bufopts)
    vim.keymap.set("n", "gt", builtin.lsp_type_definitions, bufopts)
    vim.keymap.set("n", "gf", function()
      vim.lsp.buf.format({ async = true })
    end, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gR", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
  end

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
    end

    set_border()
    set_mappings()

    --Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
  end

  -- config that activates keymaps and enables snippet support
  local function set_base_config()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return {
      -- enable snippet support
      capabilities = capabilities,
      -- map buffer local keybindings when the language server attaches
      on_attach = on_attach,
    }
  end

  local jdtls_config = function()
    local masonPath = vim.fn.stdpath("data") .. "/mason/packages"
    local jdtlsPath = masonPath .. "/jdtls"
    local lspJar = jdtlsPath .. "/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar"
    local osName = ""
    if vim.loop.os_uname().sysname == "Darwin" then
      osName = "mac"
    else
      osName = "linux"
    end
    local lspConfig = jdtlsPath .. "/config_" .. osName

    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
    local workspace_dir = os.getenv("HOME") .. "/.jdtls-workspace/" .. project_name

    -- This bundles definition is the same as in the previous section (java-debug installation)
    local bundles = {
      vim.fn.glob(
        masonPath .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
      ),
    }

    -- This is the new part
    vim.list_extend(bundles, vim.split(vim.fn.glob(masonPath .. "/vscode-java-test/server/*.jar"), "\n"))

    vim.api.nvim_create_user_command("JdtAddCommands", function()
      require("jdtls.setup").add_commands()
    end, {})

    return {
      cmd = {
        os.getenv("HOME") .. "/.nix-profile/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-jar",
        lspJar,
        "-configuration",
        lspConfig,
        "-data",
        workspace_dir,
      },

      -- This is the default if not provided, you can remove it. Or adjust as needed.
      -- One dedicated LSP server & client will be started per unique root_dir
      root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

      -- Here you can configure eclipse.jdt.ls specific settings
      -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
      -- for a list of options
      settings = {
        java = {
          signatureHelp = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*",
              "sun.*",
            },
            -- Defines the sorting order of import statements. A package or type name
            -- prefix (e.g. 'org.eclipse') is a valid entry. An import is always added
            -- to the most specific group.
            importOrder = {
              "at",
              "com",
              "org",
              "javax",
              "java",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
        },
      },

      on_attach = function(client, bufnr)
        local function buf_set_option(...)
          vim.api.nvim_buf_set_option(bufnr, ...)
        end

        set_border()
        set_mappings()

        --Enable completion triggered by <c-x><c-o>
        buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

        require("jdtls.setup").add_commands()
      end,

      -- Language server `initializationOptions`
      -- You need to extend the `bundles` with paths to jar files
      -- if you want to use additional eclipse.jdt.ls plugins.
      --
      -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
      --
      -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
      init_options = {
        bundles = bundles,
      },
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
    "terraformls",
    "texlab",
    "tsserver",
    "vimls",
    "vuels",
    "yamlls",
  }

  local function setup_servers()
    for _, server in pairs(servers) do
      local config = set_base_config()

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

      if server == "jdtls" and vim.bo.filetype == "java" then
        require("jdtls").start_or_attach(jdtls_config())
      else
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
