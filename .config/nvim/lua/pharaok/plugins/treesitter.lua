return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = "windwp/nvim-ts-autotag",
  event = "BufReadPre",
  opts = {
    autotag = { enable = true },
    endwise = { enable = true },
    highlight = { enable = true },
    -- indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "html",
      "javascript",
      "json",
      "jsonc",
      "lua",
      "python",
      "regex",
      "rust",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "yaml",
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
