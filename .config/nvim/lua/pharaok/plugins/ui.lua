return {
  { "nvim-tree/nvim-web-devicons", cond = vim.g.icons },
  {
    "akinsho/bufferline.nvim",
    version = "v3.*",
    -- dependencies = "nvim-tree/nvim-web-devicons",
    cond = not vim.g.started_by_firenvim,
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
        buffer_close_icon = vim.g.icons and nil or "x",
        close_icon = vim.g.icons and nil or "X",
        show_buffer_icons = not vim.g.icons,
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
      -- vim.fn.jobstart({
      --   "top",
      --   "-b",
      --   "-d0.5",
      --   "-p",
      --   vim.loop.os_getpid(),
      -- }, {
      --   on_stdout = function(_, top)
      --     local len = table.maxn(top)
      --     local line = top[len]
      --     local cols = {}
      --     local i = 1
      --     for col in line:gmatch("([^%s]+)") do
      --       cols[i] = col
      --       i = i + 1
      --     end
      --     local ok, n = pcall(tonumber, cols[9])
      --     if ok then
      --       vim.g.cpu_usage = n
      --     end
      --   end,
      -- })
    end,
    opts = function()
      local opts = {
        options = {
          icons_enabled = vim.g.icons,
        },
        sections = {
          lualine_x = {
            {
              require("lazy.status").updates,
              cond = function()
                return (not vim.g.started_by_firenvim) and require("lazy.status").has_updates()
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
