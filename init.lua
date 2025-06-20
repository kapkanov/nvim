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
-- vim.o.noexpandtab    = true

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn   = "yes"

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase     = true
vim.o.smartcase      = true

-- Scroll keeping a cursor at the center of the screen
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "<c-d>", "<c-d>zz")

-- Do not copy text deleted via x
vim.keymap.set({"n", "v"}, "x", '"_x')

-- Move selected rows
vim.keymap.set("v", "J", ":m '>+1<cr>gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv")

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
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				style = "warm",
			})
			require("onedark").load()
		end,
	},

	{
	"nvim-treesitter/nvim-treesitter",
	build = function()
	  vim.cmd(":TSUpdate")
	end,
	config = function()
	  local ensure = {
	    "c",
	    "lua",
	    "bash",
	    "html",
	    "css",
	    "dockerfile",
	    "go",
	    "javascript",
	    "json",
	    "lua",
	    "make",
	    "nginx",
	    "php",
	    "python",
	    "sql",
	    "typescript",
	    "yaml",
	  }
          local list          = vim.api.nvim_exec("TSInstallInfo", true)
          local ensure_result = {}
          local languages     = {}
          
          for w in list:gmatch("[^\n]+") do
            table.insert(languages, w:match("^(%S+)"))
          end
          
          for _, check in ipairs(ensure) do
            for _, lang in ipairs(languages) do
              if lang == check then
                table.insert(ensure_result, lang)
              end
            end
          end
          
	  require("nvim-treesitter.configs").setup{
	  ensure_installed = ensure_result,
	    sync_install = false,

	    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	    auto_install = false,
	    highlight = {enable = true},
	  }
	 end
        },

  { 'neovim/nvim-lspconfig' }, -- Collection of configurations for built-in LSP client
  { 'hrsh7th/nvim-cmp' }, -- Autocompletion plugin
  { 'hrsh7th/cmp-nvim-lsp' }, -- LSP source for nvim-cmp
  { 'saadparwaiz1/cmp_luasnip' }, -- Snippets source for nvim-cmp
  { 'L3MON4D3/LuaSnip' }, -- Snippets plugin
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = 'Telescope live grep' })
      vim.keymap.set('n', '<leader>gs', builtin.grep_string, { desc = 'Searches for the string under your cursor or selection in your current working directory' })
      vim.keymap.set('n', '<leader>bu', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>ht', builtin.help_tags, { desc = 'Telescope help tags' })
      vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = 'Lists LSP references for word under the cursor' })
    end,
  },
}, {})

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.tm"},
  callback = function(_)
    vim.api.nvim_exec("set ft=terramate", true)
  end
})

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
-- local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
local servers = {
  {
    "ts_ls",
    dependencies = { "tsc", "typescript-language-server" }
  },
  "pyright",
  "gopls",
  "jdtls",
  "clangd",
}

if vim.fn.executable("terramate-ls") ~= 0 then
  local configs = require("lspconfig.configs")
  configs.terramate_ls = {
    default_config = {
      cmd = { "terramate-ls" },
      filetypes = { "terramate" },
      root_dir = function(fname)
        return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
      end
    }
  }
  table.insert(servers, {"terramate_ls", dependencies = {"terramate-ls"}})
end

for _, lsp in ipairs(servers) do
  local lsname       = lsp[1] or lsp
  local dependencies = lsp.dependencies or { lsp }
  local installed    = true

  for _, dependency in ipairs(dependencies) do
    dependency = dependency[1] or dependency
    installed  = installed and vim.fn.executable(dependency) ~= 0
  end

  if installed then
    lspconfig[lsname].setup {
      capabilities = capabilities,
    }
  end
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Esc>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.abort()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-J>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<C-K>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

vim.api.nvim_create_autocmd("TextChangedI", {
  pattern = "*",
  callback = function()
    local line = vim.api.nvim_get_current_line()
    if line:sub(-1) == "(" then
      vim.lsp.buf.signature_help()
    end
  end
})

vim.diagnostic.config({
  virtual_text     = true,
  signs            = true,
  update_in_insert = false,
  underline        = true,
  severity_sort    = false,
  float            = true,
})

vim.keymap.set("n", "<leader>er", vim.diagnostic.open_float)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.bo.shiftwidth = 4    -- Number of spaces for each indentation level
    vim.bo.tabstop = 4       -- Number of spaces that a <Tab> in the file counts for
    vim.bo.softtabstop = 4   -- Number of spaces a <Tab> counts for while editing
    vim.bo.expandtab = true  -- Use spaces instead of tabs
  end,
})

