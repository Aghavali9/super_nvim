-- lua/config/cmp.lua

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- LuaSnip jump keymaps
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
end, { silent = true, desc = "Snippet jump forward" })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  if luasnip.jumpable(-1) then luasnip.jump(-1) end
end, { silent = true, desc = "Snippet jump backward" })

-- Autopairs integration
pcall(function()
  local cmp_autopairs = require("nvim-autopairs.completion.cmp")
  cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end)
