require("telescope").setup({
    defaults = { sorting_strategy = "ascending", layout_config = { prompt_position = "top" },
        file_ignore_patterns = { "%.git/", "node_modules/", "%.venv/", "build/" } },
    pickers = { find_files = { hidden = true }, buffers = { sort_mru = true, ignore_current_buffer = true } },
})
pcall(require("telescope").load_extension, "fzf")
