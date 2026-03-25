-- lua/plugins/folds.lua
-- Code-folding powered by nvim-ufo (treesitter + LSP providers)

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    init = function()
      -- UFO requires these options to be set before the plugin loads
      vim.o.foldcolumn    = "1"
      vim.o.foldlevel     = 99  -- start with all folds open
      vim.o.foldlevelstart = 99
      vim.o.foldenable    = true
    end,
    config = function()
      -- Track the last peek window so KK can enter it
      local last_peek_winid = nil

      require("ufo").setup({
        provider_selector = function(_, _, _)
          return { "treesitter", "indent" }
        end,
        preview = {
          win_config = {
            border     = "rounded",
            -- Link the floating window text and border to existing NormalFloat groups
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
            winblend   = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
          },
        },
      })

      -- zo / zc / za are left at Vim defaults (open / close / toggle)

      -- zR ── open every fold in the buffer
      vim.keymap.set("n", "zR", require("ufo").openAllFolds,
        { desc = "Open all folds (UFO)" })

      -- zM ── close every fold in the buffer
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds,
        { desc = "Close all folds (UFO)" })

      -- K ── peek the folded lines under cursor; fall back to LSP hover doc
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if winid then
          last_peek_winid = winid
        else
          last_peek_winid = nil
          -- prefer lspsaga hover when available, fall back to built-in hover
          local ok, err = pcall(vim.cmd, "Lspsaga hover_doc")
          if not ok then
            vim.notify("hover: " .. tostring(err), vim.log.levels.DEBUG)
            vim.lsp.buf.hover()
          end
        end
      end, { desc = "Peek fold / Hover doc (UFO)" })

      -- KK ── enter the currently-open peek / hover window
      vim.keymap.set("n", "KK", function()
        if last_peek_winid and vim.api.nvim_win_is_valid(last_peek_winid) then
          vim.api.nvim_set_current_win(last_peek_winid)
        else
          -- If no window is cached, open a fresh peek and jump straight in
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if winid then
            vim.api.nvim_set_current_win(winid)
          end
        end
      end, { desc = "Enter peek / hover window (UFO)" })
    end,
  },
}
