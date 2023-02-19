local function on_attach(_, bufnr)
  local remap = require("pharaok.keymap.remap")

  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  remap("n", "gD", vim.lsp.buf.declaration, bufopts)
  remap("n", "gd", vim.lsp.buf.definition, bufopts)
  remap("n", "K", vim.lsp.buf.hover, bufopts)
  remap("n", "gi", vim.lsp.buf.implementation, bufopts)
  remap("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  remap("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  remap("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  remap("n", "<Leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
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
    "williamboman/mason.nvim",
    config = true,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("pharaok.util").has("nvim-cmp")
        end,
      },
      { "folke/neoconf.nvim", config = true },
      { "folke/neodev.nvim", config = true },
      "b0o/SchemaStore.nvim",
    },
    cmd = "Neoconf",
    event = "BufReadPre",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      for _, server in ipairs({
        "lua_ls",
        "pylsp",
        "html",
        "cssls",
        "tailwindcss",
        "emmet_ls",
        "dockerls",
      }) do
        lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
      end
      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("pharaok.util").has("nvim-cmp")
        end,
      },
    },
    opts = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      return { server = { on_attach = on_attach, capabilities = capabilities } }
    end,
    ft = "rust",
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    dependencies = {
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("pharaok.util").has("nvim-cmp")
        end,
      },
    },
    opts = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      return { server = { on_attach = on_attach, capabilities = capabilities } }
    end,
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPre",
    config = function()
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          -- null_ls.builtins.completion.spell,
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.prettierd,
          null_ls.builtins.formatting.eslint_d,
          null_ls.builtins.formatting.rustfmt,
          null_ls.builtins.formatting.black,
          require("typescript.extensions.null-ls.code-actions"),
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
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
}
