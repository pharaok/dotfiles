return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "mfussenegger/nvim-dap-python",
        config = function()
          require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
        end,
      },
      {
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-neotest/nvim-nio",
        name = "dapui",
        config = true,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = true,
      },
    },
    keys = function()
      return {
        {
          "<F5>",
          function()
            require("dap").continue()
          end,
        },
        {
          "<F9>",
          function()
            require("dap").toggle_breakpoint()
          end,
        },
        {
          "<F10>",
          function()
            require("dap").step_over()
          end,
        },
        {
          "<F11>",
          function()
            require("dap").step_into()
          end,
        },
        {
          "<F12>",
          function()
            require("dap").step_out()
          end,
        },
      }
    end,
    init = function()
      vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "debugBreakpoint" })
    end,
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
