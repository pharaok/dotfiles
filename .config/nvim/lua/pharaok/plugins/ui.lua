return {
  {
    "nvim-tree/nvim-web-devicons",
    cond = function()
      return vim.g.icons
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "v3.*",
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        buffer_close_icon = vim.g.icons and nil or "x",
        close_icon = vim.g.icons and nil or "X",
        show_buffer_icons = vim.g.icons,
        offsets = {
          {
            filetype = "neo-tree",
            text = "Neo-Tree",
            highlight = "Directory",
            text_align = "center",
          },
        },
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    -- dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    init = function()
      local str_split = require("pharaok.util").str_split
      vim.fn.jobstart({ "python3", "/home/pharaok/.config/nvim/mtop.py", vim.loop.os_getpid() }, {
        on_stdout = function(_, cpu)
          cpu = tonumber(cpu[1])
          if cpu ~= nil then
            vim.g.cpu = cpu
          end
        end,
      })
    end,
    opts = function()
      local opts = {
        options = {
          icons_enabled = vim.g.icons,
        },
        sections = {
          lualine_x = {
            -- {
            --   "g:cpu",
            --   cond = function()
            --     return vim.g.cpu >= 10
            --   end,
            --   fmt = function(cpu)
            --     cpu = tonumber(cpu)
            --     if cpu == nil then
            --       return ""
            --     end
            --
            --     local icons = {
            --       low = "\243\176\190\134 ",
            --       medium = "\243\176\190\133 ",
            --       high = "\243\176\147\133 ",
            --     }
            --
            --     local level = "low"
            --     if cpu > 66 then
            --       level = "high"
            --     elseif cpu > 33 then
            --       level = "medium"
            --     end
            --     return icons[level] .. math.floor(cpu) .. "%%"
            --   end,
            -- },
            {
              require("lazy.status").updates,
              cond = function()
                return vim.g.icons and require("lazy.status").has_updates()
              end,
              color = { fg = "#ff9e64" },
            },
          },
        },
      }
      if not vim.g.icons then
        opts = vim.tbl_deep_extend("force", opts, { options = { component_separators = "", section_separators = "" } })
      end
      return opts
    end,
  },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = { top_down = false, background_colour = vim.g.transparent and "#24283b" or nil },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  { "brenoprata10/nvim-highlight-colors", event = "BufReadPre", opts = { enable_tailwind = true } },
}
