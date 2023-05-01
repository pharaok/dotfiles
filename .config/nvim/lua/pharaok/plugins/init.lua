return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = function()
      -- defer opts table so that plugins with higher priority
      -- can set global variables
      return {
        transparent = vim.g.transparent,
        styles = { sidebars = vim.g.transparent and "transparent" or "normal" },
      }
    end,
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd([[ colorscheme tokyonight ]])
    end,
  },
  "ellisonleao/gruvbox.nvim",
  "tomasiser/vim-code-dark",

  { "tpope/vim-fugitive", cmd = { "G", "Git" } },
  {
    "lewis6991/gitsigns.nvim",
    opts = { current_line_blame = true },
  },

  {
    "glacambre/firenvim",
    lazy = false,
    priority = 2000,
    cond = not not vim.g.started_by_firenvim,
    build = function()
      require("lazy").load({ plugins = "firenvim", wait = true })
      vim.fn["firenvim#install"](0)
    end,
    config = function()
      vim.g.transparent = false
    end,
  },
}
