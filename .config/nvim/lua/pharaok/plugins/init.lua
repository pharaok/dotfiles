return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[ colorscheme tokyonight ]])
    end,
  },
  "ellisonleao/gruvbox.nvim",
  "tomasiser/vim-code-dark",

  { "tpope/vim-fugitive", cmd = { "G", "Git" } },
  {
    "lewis6991/gitsigns.nvim",
    cmd = "Gitsigns",
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(e)
          vim.fn.system({ "git", "ls-files", "--error-unmatch", vim.fn.expand("%") })
          if vim.v.shell_error == 0 then
            require("gitsigns")
            vim.api.nvim_del_autocmd(e.id)
          end
        end,
      })
    end,
    opts = { current_line_blame = true },
  },
}
