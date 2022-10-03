-- ---------------------------------------- nvim-dap ---------------------------------------------------------

local M = {}

M.load = function()
  require("nvim-dap-virtual-text").setup({})
  require("dapui").setup()

  local dap, dapui = require("dap"), require("dapui")
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({})
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close({})
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close({})
  end

  -- go
  require("dap-go").setup()

  -- java workaround for debugging tests:
  -- 1. start server with gradle --no-daemon --no-build-cache --rerun-tasks test --tests=DemoApplicationTests.contextLoads --debug-jvm
  -- 2. attach DAP
  -- for running other tasks, JdtRefreshDebugConfigs + dap normally works
  -- related gh issues: https://github.com/microsoft/vscode-java-test/issues/1481, https://github.com/microsoft/vscode-java-test/issues/1045
  local util = require("jdtls.util")
  dap.adapters.java = function(callback)
    util.execute_command({ command = "vscode.java.startDebugSession" }, function(err0, port)
      assert(not err0, vim.inspect(err0))
      callback({
        type = "server",
        host = "127.0.0.1",
        port = port,
      })
    end)
  end
  dap.configurations.java = {
    {
      type = "java",
      request = "attach",
      name = "Java attach",
      hostName = "127.0.0.1",
      port = 5005,
    },
  }

  -- dont display separate repl buffer
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dap-repl",
    callback = function(args)
      vim.api.nvim_buf_set_option(args.buf, "buflisted", false)
    end,
  })

  local opt = { noremap = true, silent = true }

  -- dap mappings
  vim.api.nvim_set_keymap("n", "<F5>", [[<Cmd>lua require'dap'.continue()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<F6>", [[<Cmd>lua require'dap'.step_over()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<F7>", [[<Cmd>lua require'dap'.step_into()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<F8>", [[<Cmd>lua require'dap'.step_out()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<F9>", [[<Cmd>lua require'dap'.toggle_breakpoint()<CR>]], opt)

  -- fzf mappings
  vim.api.nvim_set_keymap("n", "<Leader>i", [[<Cmd>lua require('fzf-lua').dap_commands()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>ic", [[<Cmd>lua require('fzf-lua').dap_configurations()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>ib", [[<Cmd>lua require('fzf-lua').dap_breakpoints()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>iv", [[<Cmd>lua require('fzf-lua').dap_variables()<CR>]], opt)
  vim.api.nvim_set_keymap("n", "<Leader>if", [[<Cmd>lua require('fzf-lua').dap_frames()<CR>]], opt)
end

return M
