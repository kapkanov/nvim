vim.g.mapleader      = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

vim.opt.scrolloff    = 8

vim.o.incsearch      = true
vim.o.hlsearch       = false
vim.o.ignorecase     = true
vim.o.smartcase      = true

vim.g.number         = true
vim.g.relativenumber = true

vim.o.number         = true
vim.o.relativenumber = true
vim.o.softtabstop    = 2
vim.o.shiftwidth     = 2
vim.o.expandtab      = true

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn   = "yes"

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase     = true
vim.o.smartcase      = true

-- Scroll keeping a cursor at the center of the screen
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "<c-d>", "<c-d>zz")

-- Keep search at center of the screen
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")

if vim.fn.executable("pbcopy") ~= 0 then
  vim.keymap.set("v", "<leader>y", ":w !pbcopy<cr><cr>")
end

if vim.fn.executable("xclip") ~= 0 then
  vim.keymap.set("v", "<leader>y", ":w !xclip -i -sel c<cr><cr>")
end

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  callback = function()
    -- vim.wo.leader('')
    vim.cmd("startinsert")
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", {
  clear = true
})
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

require("telescope").setup()

vim.keymap.set('n', '<leader>ff', require("telescope.builtin").find_files, {
  desc = 'Telescope find files'
})

vim.keymap.set('n', '<leader>lg', require("telescope.builtin").live_grep, {
  desc = 'Telescope live grep'
})

vim.keymap.set('n', '<leader>gs', require("telescope.builtin").grep_string, {
  desc = 'Searches for the string under your cursor or selection in your current working directory'
})

vim.keymap.set('n', '<leader>bu', require("telescope.builtin").buffers, {
  desc = 'Telescope buffers'
})

vim.keymap.set('n', '<leader>ht', require("telescope.builtin").help_tags, {
  desc = 'Telescope help tags'
})

vim.keymap.set('n', '<leader>lr', require("telescope.builtin").lsp_references, {
  desc = 'Lists LSP references for word under the cursor'
})

require("oil").setup({
  win_options = {
    signcolumn = "yes",
    cursorcolumn = false,
  },
  skip_confirm_for_simple_edits = true,
})

vim.keymap.set('n', '<leader>o', ":Oil<CR>")
vim.keymap.set('n', '<leader>.', require("oil").toggle_hidden, {})

vim.lsp.enable("ada_ls")
vim.lsp.enable("yamlls")

vim.api.nvim_set_hl(0, "yamlBlockMappingKey", { link = "Keyword" })


require("mini.completion").setup()

local map_opts = {
  expr             = true,
  replace_keycodes = true,
  noremap          = true,
  silent           = true
}

vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() ~= 0 then
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    
    if item_selected then
      return '<C-y>'
    else
      return '<C-n><C-y>'
    end
  else
    return '<CR>'
  end
end, map_opts)

vim.keymap.set('i', '<C-K>', function()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-p>"
  else
    return "<C-K>"
  end
end, map_opts)

vim.keymap.set('i', '<C-J>', function()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-n>"
  else
    return "<C-J>"
  end
end, map_opts)


vim.api.nvim_create_autocmd("FileType", {
  pattern  = "*",
  callback = function()
    local leader = vim.g.mapleader or ' '
    
    local all_maps = vim.list_extend(
      vim.api.nvim_get_keymap('i'),
      vim.api.nvim_buf_get_keymap(0, 'i')
    )
    
    for _, map in ipairs(all_maps) do
      if vim.startswith(map.lhs, leader) then
        pcall(vim.keymap.del, 'i', map.lhs)
        pcall(vim.keymap.del, 'i', map.lhs, { buffer = 0 })
      end
    end
  end,
})


vim.cmd.colorscheme("gruber-darker")

