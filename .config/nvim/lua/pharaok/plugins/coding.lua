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
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      return {
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          -- { name = "buffer" },
          { name = "path" },
          { name = "luasnip" },
        }),
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
            elseif require("luasnip").expand_or_jumpable() then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        }),
        formatting = { format = lspkind.cmp_format({ mode = vim.g.icons and "symbol" or "text" }) },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
        view = { entries = "wildmenu" },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })
    end,
  },

  {
    "numToStr/Comment.nvim",
    dependencies = {"nvim-treesitter/nvim-treesitter", "JoosepAlviste/nvim-ts-context-commentstring"},
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
      require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
  { "kylechui/nvim-surround", version = "*", config = true },
  { "github/copilot.vim" },
}
