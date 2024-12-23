return {
  {
    "nvim-tree/nvim-web-devicons",
    cond = function()
      return vim.g.icons
    end,
  },
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    version = "v4.*",
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
    "j-hui/fidget.nvim",
    tag = "v1.0.0",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    dependencies = "nvim-telescope/telescope-fzf-native.nvim",
  },

  { "brenoprata10/nvim-highlight-colors", event = "BufReadPre", opts = { enable_tailwind = true } },
}
