local remap = require("pharaok.keymap.remap")

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
    opts = {
      current_line_blame = true,
      on_attach = function()
        local gitsigns = require("gitsigns")
        remap("n", "<Leader>hs", gitsigns.reset_hunk)
        remap("n", "<Leader>hr", gitsigns.reset_hunk)
        remap("v", "<Leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        remap("v", "<Leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end)
        remap("n", "<Leader>hS", gitsigns.stage_buffer)
        remap("n", "<Leader>hR", gitsigns.reset_buffer)
      end,
    },
    cmd = "Gitsigns",
    init = function()
      local augroup = vim.api.nvim_create_augroup("GitsignsLazy", {})
      vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        callback = function(event)
          if event.file == "" then
            return
          end
          vim.fn.system("git ls-files --error-unmatch " .. event.file)
          if vim.v.shell_error == 0 then
            require("gitsigns")
            vim.api.nvim_del_augroup_by_id(augroup)
          end
        end,
      })
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = true,
  },

  {
    "glacambre/firenvim",
    version = "*",
    lazy = false,
    priority = 2000,
    cond = not not vim.g.started_by_firenvim,
    build = function()
      require("lazy").load({ plugins = { "firenvim" }, wait = true })
      vim.fn["firenvim#install"](0)
    end,
    config = function()
      vim.g.firenvim_config = {
        localSettings = {
          [".*"] = {
            cmdline = "neovim",
            priority = 0,
            takeover = "never",
          },
        },
      }

      vim.g.transparent = false
      vim.g.icons = false

      LeetcodeSetFileType = function(result)
        result = result:sub(2, result:len() - 1):lower()
        local name_to_ft = {
          python3 = "python",
        }
        local ft = name_to_ft[result] or result
        vim.bo.filetype = ft
      end
      vim.cmd([[
        function LeetcodeSetFileType(result)
          call v:lua.LeetcodeSetFileType(a:result)
        endfunction
      ]])

      local imports = { "from typing import List, Dict", "import math", "import heapq", "import collections", "", "" }

      vim.api.nvim_create_autocmd("BufAdd", {
        pattern = "leetcode.com_problems*.txt",
        callback = function(event)
          local eval_js = vim.fn["firenvim#eval_js"]
          eval_js([[document.querySelector("button[id^=headlessui-listbox-button]").innerText]], "LeetcodeSetFileType")

          vim.api.nvim_buf_set_lines(event.buf, 0, 0, false, imports)
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "leetcode.com_problems*.txt",
        callback = function(event)
          vim.api.nvim_buf_set_lines(event.buf, 0, #imports, false, {})
        end,
      })
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "leetcode.com_problems*.txt",
        callback = function(event)
          vim.api.nvim_buf_set_lines(event.buf, 0, 0, false, imports)
        end,
      })
    end,
  },
}
