local util = require("pharaok.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = function()
      return {
        { "<Leader>:", "<Cmd>Telescope commands<CR>" },
        { "<Leader><Space>", "<Cmd>Telescope find_files<CR>" },
        {
          "<Leader><Tab>",
          function()
            require("telescope.builtin").buffers({ sort_lastused = true })
          end,
        },
        { "<Leader>ff", "<Cmd>Telescope find_files<CR>" },
        { "<Leader>fg", "<Cmd>Telescope live_grep<CR>" },
        { "<Leader>fo", "<Cmd>Telescope oldfiles<CR>" },
        { "<Leader>cs", "<Cmd>Telescope colorscheme<CR>" },
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
      {
        "s1n7ax/nvim-window-picker",
        -- tag = "v1.*",
        config = function()
          require("window-picker").setup({
            selection_chars = "TNSERIAO",
            -- filter_rules = {
            --   bo = {
            --     buftype = { "quickfix", "terminal" },
            --   },
            -- },
          })
        end,
      },
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
        once = true,
        callback = function(e)
          local stat = vim.loop.fs_stat(e.file)
          if stat and stat.type == "directory" then
            require("neo-tree")
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
          })
        end,
        desc = "NeoTree",
      },
    },
    opts = {
      window = { width = 32 },
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
    -- version = "*",
    dependencies = {
      { "stevearc/stickybuf.nvim", dependencies = { "s1n7ax/nvim-window-picker" }, config = true },
    },
    keys = function(plugin)
      return { plugin.opts.open_mapping }
    end,
    opts = {
      start_in_insert = false,
      shading_factor = "-10",
      open_mapping = "<C-\\>",
      ---@param t Terminal
      on_create = function(t)
        local server = "command nvim --server " .. vim.v.servername
        t:send('alias nvim="' .. server .. " --remote-send '<Cmd>:stopinsert<CR>' && " .. server .. ' --remote"')
        require("stickybuf").pin(t.window, {
          restore_callback = function()
            vim.wo.winhighlight = ""
            vim.wo.number = vim.go.number
            vim.wo.relativenumber = vim.go.relativenumber
          end,
        })
      end,
      on_open = function(t)
        vim.cmd([[ startinsert ]])
        if t.direction == "horizontal" and util.has("trouble.nvim") then
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
    event = "BufReadPre",
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
