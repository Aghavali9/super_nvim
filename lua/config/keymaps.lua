-- lua/config/keymaps.lua

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>e", ":Ex<CR>", { desc = "Explorer" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Write" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>mp", ":MarkdownPreview<CR>", { desc = "Markdown preview" })

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Undotree" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git (fugitive)" })

-- Smart Build & Run (<leader>r) — handles C/C++, Python, and Java
vim.keymap.set("n", "<leader>r", function()
  if vim.bo.modified then vim.cmd("w") end

  local ft = vim.bo.filetype
  local cmd = ""

  if ft == "c" or ft == "cpp" then
    if vim.fn.filereadable("CMakeLists.txt") == 1 then
      cmd = "cmake -S . -B build && cmake --build build && ./build/$(grep -m 1 'project(' CMakeLists.txt | sed 's/project(//;s/ .*//')"
    else
      local file = vim.fn.expand("%")
      local ext = vim.fn.expand("%:e")
      if file == "" or (ext ~= "c" and ext ~= "cpp") then
        print("Not a valid C/C++ file")
        return
      end
      local compiler = ext == "cpp" and "g++" or "gcc"
      cmd = compiler .. " " .. file .. " -o " .. vim.fn.expand("%:r") .. " && ./" .. vim.fn.expand("%:r")
    end

  elseif ft == "python" then
    if vim.fn.filereadable("pyproject.toml") == 1 or vim.fn.filereadable("setup.py") == 1 then
      cmd = "python3 -m " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    else
      cmd = "python3 " .. vim.fn.expand("%")
    end

  elseif ft == "java" then
    if vim.fn.filereadable("pom.xml") == 1 then
      cmd = "mvn -q compile exec:java -Dexec.mainClass=com.example.Main"
    elseif vim.fn.filereadable("build.gradle") == 1 then
      cmd = "gradle run"
    else
      local file = vim.fn.expand("%")
      cmd = "javac " .. file .. " && java " .. vim.fn.expand("%:t:r")
    end

  else
    print("No runner configured for filetype: " .. ft)
    return
  end

  vim.cmd("belowright split | resize 12 | terminal " .. cmd)
end, { desc = "Smart Build & Run" })
