return {
  {
    "akinsho/bufferline.nvim",
    version = "v3.*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    opts = {
      options = {
        diagnostics = "nvim_lsp",
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
    opts = {
      sections = {
        lualine_x = {
          -- {
          --   "g:cpu_usage",
          --   fmt = function(n)
          --     return n .. "%%"
          --   end,
          --   cond = function()
          --     return vim.g.cpu_usage > 0
          --   end,
          --   color = function()
          --     local fg
          --     if not vim.g.cpu_usage then
          --       fg = "#ffffff"
          --       return { fg = fg }
          --     end
          --     if vim.g.cpu_usage < 20 then
          --       fg = "#ffff00"
          --     elseif vim.g.cpu_usage < 40 then
          --       fg = "#ffaa00"
          --     elseif vim.g.cpu_usage < 60 then
          --       fg = "#ff7700"
          --     else
          --       fg = "#ff1100"
          --     end
          --     return { fg = fg }
          --   end,
          -- },
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = "#ff9e64" },
          },
        },
      },
    },
  },

  -- {
  --   "folke/noice.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --   },
  --   event = "VeryLazy",
  --   opts = {},
  -- },
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    opts = { top_down = false },
    config = function(_, opts)
      require("notify").setup(opts)
      vim.notify = require("notify")
    end,
  },

  { "brenoprata10/nvim-highlight-colors", event = "BufReadPre", opts = { enable_tailwind = true } },
}
