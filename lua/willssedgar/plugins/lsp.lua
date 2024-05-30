return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "kevinhwang91/nvim-ufo", -- Added nvim-ufo
    "kevinhwang91/promise-async", -- Dependency for nvim-ufo
  },

  config = function()
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities =
      vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "cssls",
        "html",
        "jdtls",
        "tsserver",
        "pyright",
        "tailwindcss",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
          })
        end,
      },
    })

    -- require("ufo").setup({
    --   provider_selector = function(_, ft, _)
    --     local lspWithOutFolding = { "markdown", "sh", "css", "html", "python", "json" }
    --     if vim.tbl_contains(lspWithOutFolding, ft) then
    --       return { "treesitter", "indent" }
    --     end
    --     return { "lsp", "indent" }
    --   end,
    --   close_fold_kinds_for_ft = {
    --     default = { "imports", "comment" },
    --   },
    --   open_fold_hl_timeout = 800,
    --   fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
    --     local hlgroup = "NonText"
    --     local newVirtText = {}
    --     local suffix = "   " .. tostring(endLnum - lnum)
    --     local sufWidth = vim.fn.strdisplaywidth(suffix)
    --     local targetWidth = width - sufWidth
    --     local curWidth = 0
    --     for _, chunk in ipairs(virtText) do
    --       local chunkText = chunk[1]
    --       local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    --       if targetWidth > curWidth + chunkWidth then
    --         table.insert(newVirtText, chunk)
    --       else
    --         chunkText = truncate(chunkText, targetWidth - curWidth)
    --         local hlGroup = chunk[2]
    --         table.insert(newVirtText, { chunkText, hlGroup })
    --         chunkWidth = vim.fn.strdisplaywidth(chunkText)
    --         if curWidth + chunkWidth < targetWidth then
    --           suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
    --         end
    --         break
    --       end
    --       curWidth = curWidth + chunkWidth
    --     end
    --     table.insert(newVirtText, { suffix, hlgroup })
    --     return newVirtText
    --   end,
    -- })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- For luasnip users.
      }, {
        { name = "buffer" },
      }),
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
