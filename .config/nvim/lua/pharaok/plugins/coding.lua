return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    lazy = false,
    build = "make install_jsregexp",
    keys = {
      {
        "<Tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<S-Tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
    config = function()
      local ls = require("luasnip")
      ls.config.set_config({
        update_events = "TextChanged,TextChangedI",
        enable_autosnippets = true,
      })
      require("luasnip.loaders.from_lua").lazy_load({ paths = "./lua/pharaok/snippets" })

      local clear_session = function(event)
        if not ls.session.jump_active then
          while ls.session.current_nodes[event.buf] do
            ls.unlink_current()
          end
        end
      end
      vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = { "s:n", "i:*" },
        callback = clear_session,
      })

      -- https://github.com/L3MON4D3/LuaSnip/issues/747
      -- vim.api.nvim_create_autocmd("CursorMovedI", {
      --   pattern = "*",
      --   callback = function(event)
      --     local current_node = luasnip.session.current_nodes[event.buf]
      --     if not luasnip.session or not current_node or luasnip.session.jump_active then
      --       return
      --     end
      --     print(vim.inspect(current_node))
      --     local current_start, current_end = current_node.get_buf_position()
      --     current_start[1] = current_start[1] + 1 -- (1, 0) indexed
      --     current_end[1] = current_end[1] + 1 -- (1, 0) indexed
      --     local cursor = vim.api.nvim_win_get_cursor(0)
      --
      --     if
      --       cursor[1] < current_start[1]
      --       or cursor[1] > current_end[1]
      --       or cursor[2] < current_start[2]
      --       or cursor[2] > current_end[2]
      --     then
      --       luasnip.unlink_current()
      --     end
      --   end,
      -- })
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },

    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      snippets = { preset = "luasnip" },
      keymap = { preset = "super-tab" },

      appearance = {
        nerd_font_variant = "mono",
      },

      completion = { documentation = { auto_show = false } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },

  {
    "numToStr/Comment.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "JoosepAlviste/nvim-ts-context-commentstring" },
    event = { "BufReadPre" },
    opts = function()
      return { pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook() }
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = { "BufReadPre" },
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
  { "kylechui/nvim-surround", version = "*", config = true },

  -- {
  --   "zbirenbaum/copilot.lua",
  --   requires = {
  --     "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  --   },
  --   cmd = "Copilot",
  --   event = "InsertEnter",
  --   config = function()
  --     require("copilot").setup({
  --       suggestion = { auto_trigger = true },
  --     })
  --   end,
  -- },
}
