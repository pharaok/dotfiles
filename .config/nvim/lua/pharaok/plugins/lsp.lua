local has = require("pharaok.util").has

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local function on_attach(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    -- vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          async = false,
          filter = function(c)
            return c.name == client.name
          end,
        })
      end,
    })
  end

  local remap = require("pharaok.keymap.remap")

  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  remap("n", "gD", vim.lsp.buf.declaration, bufopts)
  remap("n", "gd", vim.lsp.buf.definition, bufopts)
  remap("n", "K", vim.lsp.buf.hover, bufopts)
  remap("n", "gi", vim.lsp.buf.implementation, bufopts)
  -- remap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  -- remap("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  -- remap("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  -- remap("n", "<Leader>wl", function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
  remap("n", "<Leader>D", vim.lsp.buf.type_definition, bufopts)
  remap("n", "<Leader>rn", vim.lsp.buf.rename, bufopts)
  remap("n", "<Leader>ca", vim.lsp.buf.code_action, bufopts)
  remap("n", "gr", vim.lsp.buf.references, bufopts)
  remap("n", "<Leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- { "williamboman/mason.nvim", cmd = "Mason", config = true },
      -- "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
        -- cond = function()
        --   return require("pharaok.util").has("nvim-cmp")
        -- end,
      },
      { "folke/neoconf.nvim", config = true },
      { "folke/neodev.nvim",  config = true },
      {
        "mrcjkb/rustaceanvim",
        version = "^5", -- Recommended
        lazy = false,
        init = function()
          vim.g.rustaceanvim = {
            server = {
              on_attach = on_attach,
            },
          }
        end,
      },
      {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        cond = function()
          return true
          -- return has("mason-registry") and require("mason-registry").is_installed("typescript-language-server")
        end,
      },
      {
        "b0o/SchemaStore.nvim",
        cond = function()
          return true
          -- return has("mason-registry") and require("mason-registry").is_installed("json-lsp")
        end,
      },
      {
        "ray-x/go.nvim",
        config = function()
          require("go").setup()
        end,
        event = { "CmdlineEnter" },
        ft = { "go", "gomod" },
        build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
      },
    },
    cmd = "Neoconf",
    event = "BufReadPre",
    config = function()
      local lspconfig = require("lspconfig")
      -- local mlsp = require("mason-lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      local opts = { on_attach = on_attach, capabilities = capabilities }

      lspconfig.clangd.setup(opts)
      lspconfig.lua_ls.setup(opts)
      lspconfig.pylsp.setup(opts)
      lspconfig.texlab.setup(opts)
      lspconfig.vimls.setup(opts)


      -- mlsp.setup({
      --   ensure_installed = {
      --     "lua_ls",
      --     "vimls",
      --   },
      -- })
      -- mlsp.setup_handlers({
      --   function(server)
      --     lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
      --   end,
      --   ["jsonls"] = function()
      --     lspconfig.jsonls.setup({
      --       on_attach = on_attach,
      --       capabilities = capabilities,
      --       settings = {
      --         json = {
      --           schemas = require("schemastore").json.schemas(),
      --           validate = { enable = true },
      --         },
      --       },
      --     })
      --   end,
      --   ["tsserver"] = function()
      --     require("typescript-tools").setup({ on_attach = on_attach })
      --   end,
      -- })
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "williamboman/mason.nvim",
      -- {
      --   "jose-elias-alvarez/typescript.nvim",
      --   cond = function()
      --     return require("mason-registry").is_installed("typescript-language-server")
      --   end,
      -- },
    },
    event = "BufReadPre",
    config = function()
      local null_ls = require("null-ls")

      local sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        -- null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.nixfmt
      }
      -- if require("pharaok.util").has("typescript.nvim") then
      --   table.insert(sources, require("typescript.extensions.null-ls.code-actions"))
      -- end

      null_ls.setup({
        sources = sources,
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            -- vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  async = false,
                  filter = function(c)
                    return c.name == client.name
                  end,
                })
              end,
            })
          end
        end,
      })
    end,
  },
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.tex_flavor = "latex"
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_quickfix_mode = 0
      -- vim.o.conceallevel = 2
      -- vim.g.tex_conceal = "abmgs"
      vim.g.vimtex_syntax_conceal = { math_bounds = 0 }
    end,
  },
}
