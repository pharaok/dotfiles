local util = require("pharaok.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = function()
      return {
        {
          "<Leader>:",
          function()
            require("telescope.builtin").commands()
          end,
        },
        {
          "<Leader><Space>",
          function()
            require("telescope.builtin").find_files()
          end,
        },
        {
          "<Leader><Tab>",
          function()
            require("telescope.builtin").buffers({ sort_lastused = true })
          end,
        },
        {
          "<Leader>ff",
          function()
            require("telescope.builtin").find_files()
          end,
        },
        {
          "<Leader>fg",
          function()
            require("telescope.builtin").live_grep()
          end,
        },
        {
          "<Leader>fo",
          function()
            require("telescope.builtin").oldfiles()
          end,
        },
        {
          "<Leader>cs",
          function()
            require("telescope.builtin").colorscheme()
          end,
        },
      }
    end,
    config = function()
      if util.has("nvim-notify") then
        require("telescope").load_extension("notify")
      end
    end,
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "neovim/nvim-lspconfig", -- root_pattern
    },
    cmd = "Neotree",
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end

      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(e)
          local stat = vim.loop.fs_stat(e.file)
          if stat and stat.type == "directory" then
            require("neo-tree")
            vim.api.nvim_del_autocmd(e.id)
          end
        end,
      })
    end,
    keys = {
      {
        "<Leader>fe",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = util.root_dir(),
          })
        end,
        desc = "NeoTree",
      },
    },
    opts = {
      window = {
        width = 32,
      },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_by_name = { "node_modules" },
        },
        follow_current_file = true,
      },
    },
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = { "<C-\\>" },
    opts = {
      start_in_insert = false,
      shading_factor = "-10",
      open_mapping = "<C-\\>",
      on_open = function()
        vim.cmd([[ startinsert ]])
        if util.has("trouble.nvim") then
          require("trouble").close()
        end
      end,
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    cmd = "Trouble",
    keys = {
      {
        "<Leader>xx",
        function()
          if util.has("toggleterm.nvim") then
            local terminal = require("toggleterm.terminal")
            for _, t in ipairs(terminal.get_all()) do
              if t.direction == "horizontal" then
                t:close()
              end
            end
          end
          vim.cmd([[ TroubleToggle workspace_diagnostics ]])
        end,
      },
    },
    config = true,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    keys = {
      {
        "<Leader>xt",
        function()
          if util.has("toggleterm.nvim") then
            local terminal = require("toggleterm.terminal")
            for _, t in ipairs(terminal.get_all()) do
              if t.direction == "horizontal" then
                t:close()
              end
            end
          end
          vim.cmd([[ TodoTrouble ]])
        end,
      },
    },
    config = true,
  },
}
