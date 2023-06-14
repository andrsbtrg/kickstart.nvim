-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
        -- 'codelldb'
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F5>', dap.continue, { desc = "Start debugger" })
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = "Step into" })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = "Step over" })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = "Step out" })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
    vim.keymap.set('n', '<leader>B', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end
      ,
      { desc = "Breakpoint condition" })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = "⏏",
        },
      },
    }
    -- toggle to see last session result. Without this ,you can't see session output in case of unhandled exception.
    vim.keymap.set("n", "<F7>", dapui.toggle)
    
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Debugger installation location
    local DEBUGGER_LOCATION =
    "C:/Users/andres.buitrago_ecow/AppData/Local/nvim-data/mason/packages/netcoredbg/netcoredbg"

    dap.adapters.coreclr = {
      type = "executable",
      command = DEBUGGER_LOCATION .. "/netcoredbg.exe",
      args = { "--interpreter=vscode" },
    }
    vim.g.dotnet_build_project = function()
      local default_path = vim.fn.getcwd() .. '/'
      if vim.g['dotnet_last_proj_path'] ~= nil then
        default_path = vim.g['dotnet_last_proj_path']
      end
      local path = vim.fn.input('Path to your *proj file', default_path, 'file')
      vim.g['dotnet_last_proj_path'] = path
      local cmd = 'dotnet build -c Debug ' .. path
      print('')
      print('Cmd to execute: ' .. cmd)
      os.execute('$Env:ASPNETCORE_ENVIRONMENT = "Development"')
      local f = os.execute(cmd)
      if f == 0 then
        print('\nBuild: ✔️ ')
      else
        print('\nBuild: ❌ (code: ' .. f .. ')')
      end
    end

    vim.g.dotnet_get_dll_path = function()
      local request = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      end
      if vim.g['dotnet_last_dll_path'] == nil then
        vim.g['dotnet_last_dll_path'] = request()
      else
        if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
          vim.g['dotnet_last_dll_path'] = request()
        end
      end

      print(vim.g['dotnet_last_dll_path'])
      local fixpath = string.gsub(vim.g['dotnet_last_dll_path'], '\\', '/')

      print(fixpath)
      return fixpath
    end

    local config = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
            vim.g.dotnet_build_project()
          end
          return vim.g.dotnet_get_dll_path()
        end,
      },
    }

    dap.configurations.cs = config
    dap.configurations.fsharp = config
    -- local mason_registry = require("mason-registry")
    --
    -- local codelldb = mason_registry.get_package('codelldb')
    -- local extension_path = codelldb:get_install_path() .. "/extension/"
    -- Install golang specific config
    -- require('dap-go').setup()
  end,
}
