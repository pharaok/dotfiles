return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = { "windwp/nvim-ts-autotag", "JoosepAlviste/nvim-ts-context-commentstring" },
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
      "help",
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
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
