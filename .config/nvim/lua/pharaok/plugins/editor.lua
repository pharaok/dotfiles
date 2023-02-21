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
    -- version = "*",
    keys = function(plugin)
      return { plugin.opts.open_mapping }
    end,
    opts = {
      start_in_insert = false,
      shading_factor = "-10",
      open_mapping = "<C-\\>",
      on_create = function(t)
        t:send('alias nvim="command nvim --server ' .. vim.v.servername .. ' --remote"')
        vim.b.toggleterm_winnr = t.window
      end,
      on_open = function(t)
        vim.cmd([[ startinsert ]])
        if t.direction == "horizontal" and util.has("trouble.nvim") then
          require("trouble").close()
        end
      end,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          print("BufEnter")
          local alt_buf = vim.fn.bufnr("#")
          if alt_buf == -1 then
            return
          end

          local filetype = vim.api.nvim_buf_get_option(alt_buf, "filetype")
          if filetype ~= "toggleterm" then
            return
          end
          local t_win = vim.api.nvim_buf_get_var(alt_buf, "toggleterm_winnr")
          if t_win ~= vim.api.nvim_get_current_win() then
            return
          end

          local eventignore = vim.opt.eventignore
          vim.opt.eventignore = "all"

          local buf = vim.api.nvim_get_current_buf()
          local wins = find_buf_wins(buf)
          local new = table.maxn(wins) == 1

          vim.cmd("buffer #")

          if not new then
            local win = find_buf_wins(buf)[1]
            vim.api.nvim_set_current_win(win)
            vim.opt.eventignore = eventignore
            return
          end

          local path = vim.api.nvim_buf_get_name(buf)
          vim.cmd("bdelete " .. buf)

          local suitable_window
          print(vim.inspect(vim.api.nvim_tabpage_list_wins(0)))
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local win_buf = vim.api.nvim_win_get_buf(win)
            local win_buf_ft = vim.api.nvim_buf_get_option(win_buf, "filetype")
            if win_buf_ft ~= "toggleterm" then
              suitable_window = win
            end
          end
          vim.api.nvim_set_current_win(suitable_window)

          vim.opt.eventignore = eventignore
          vim.cmd("e " .. vim.fn.fnameescape(path))
        end,
      })
    end,
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
