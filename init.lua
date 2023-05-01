vim.g.mapleader = " "
vim.g.maplocalleader = ' '
local keymap = vim.keymap.set

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
    config = function ()
      require('onedark').setup  {
        style = 'warm',
      }
      require('onedark').load()
    end
  },

  {
    "szw/vim-maximizer",
    config = keymap("n", "<leader>sm", ":MaximizerToggle<CR>")
  },

  "tpope/vim-surround",

  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  },

  "nvim-lua/plenary.nvim",

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      keymap("n", "<leader>e", ":Neotree toggle reveal left<CR>")
    end
  },

  "nvim-tree/nvim-web-devicons",

  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      keymap("n", "<leader>ff", ":Telescope find_files<cr>")
      keymap("n", "<leader>lg", ":Telescope live_grep<cr>")
      keymap("n", "<leader>gf", ":Telescope git_files<cr>")
      keymap("n", "<leader>gs", ":Telescope grep_string<cr>")
      keymap("n", "<leader>hh", ":Telescope search_history<cr>")
      keymap("n", "<leader><leader>", ":Telescope buffers<cr>")
      keymap("n", "<leader>ht", ":Telescope help_tags<cr>")
      keymap("n", "<leader>ks", ":Telescope keymaps<cr>")
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = { "saadparwaiz1/cmp_luasnip" },
    config = function()
      local cmp = require'cmp'
      
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            require'luasnip'.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-k>'] = cmp.mapping.select_prev_item(),
          ['<C-j>'] = cmp.mapping.select_next_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        sources = cmp.config.sources(
        {
          -- { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        },
        {
          { name = 'buffer' },
        },
        {
          { name = 'path' },
        }
        )
      })

      -- -- Set configuration for specific filetype.
      -- cmp.setup.filetype('gitcommit', {
      --   sources = cmp.config.sources({
      --     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
      --   }, {
      --     { name = 'buffer' },
      --   })
      -- })
      
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
      
        -- -- Set up lspconfig.
        -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
        -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
        -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
        --   capabilities = capabilities
        -- }
      
      vim.opt.completeopt = "menu,menuone,noselect"

    end
  },

  "hrsh7th/cmp-path",

  "hrsh7th/cmp-buffer",

  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip/loaders/from_vscode").lazy_load()
    end
  }
}, {})


-- do not copy symbol deleted via x
keymap("n", "x", '"_x')

-- move selected rows
keymap("v", "J", ":m '>+1<cr>gv")
keymap("v", "K", ":m '<-2<cr>gv")

-- keep search at center of the screen
keymap("n", "n", "nzz")
keymap("n", "N", "Nzz")

-- split windows
keymap("n", "<leader>sh", "<C-w>s")
keymap("n", "<leader>sv", "<C-w>v")
keymap("n", "<leader>se", "<C-w>=")
keymap("n", "<leader>sx", ":close<CR>")
vim.opt.splitright = true
vim.splitbelow = true

-- tabs
keymap("n", "<leader>to", ":tabnew<CR>")
keymap("n", "<leader>tn", ":tabn<CR>")
keymap("n", "<leader>tp", ":tabp<CR>")
keymap("n", "<leader>tx", ":tabclose<CR>")

-- terminal
keymap("n", "<leader>tv", "<C-w>v:term<cr>")
keymap("n", "<leader>th", "<C-w>s:term<cr>")
keymap("t", "<Esc>", "<C-\\><C-N>")
keymap("t", "<leader>tx", "<C-\\><C-N>:q<cr>")
vim.api.nvim_create_autocmd({"TermOpen"}, {
  callback = function()
    vim.cmd("startinsert")
  end
})

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

vim.opt.scrolloff = 8
vim.opt.guicursor = ""

vim.opt.relativenumber = true

-- 
-- vim.keymap.set("n", "n", "nzz")
-- vim.keymap.set("n", "N", "Nzz")
-- 
-- -- blanking cursor
-- vim.opt.guicursor = ""
-- 
-- vim.opt.splitright = true
-- vim.splitbelow = true
-- 
-- vim.keymap.set("n", "x", '"_x')
-- 
-- vim.opt.relativenumber = true
-- 
-- vim.opt.smartindent = true
-- 
-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- -- Set <space> as the leader key
-- -- See `:help mapleader`
-- --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
-- vim.g.mapleader = ' '
-- vim.g.maplocalleader = ' '
-- 
-- -- Install package manager
-- --    https://github.com/folke/lazy.nvim
-- --    `:help lazy.nvim.txt` for more info
-- local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
-- if not vim.loop.fs_stat(lazypath) then
--   vim.fn.system {
--     'git',
--     'clone',
--     '--filter=blob:none',
--     'https://github.com/folke/lazy.nvim.git',
--     '--branch=stable', -- latest stable release
--     lazypath,
--   }
-- end
-- vim.opt.rtp:prepend(lazypath)
-- 
-- -- NOTE: Here is where you install your plugins.
-- --  You can configure plugins using the `config` key.
-- --
-- --  You can also configure plugins after the setup call,
-- --    as they will be available in your neovim runtime.
-- require('lazy').setup({
--   -- NOTE: First, some plugins that don't require any configuration
-- 
--   -- Git related plugins
--   {
--       'tpope/vim-fugitive',
--       version = 'v3.x'
--   },
--   'tpope/vim-rhubarb',
-- 
--   -- Detect tabstop and shiftwidth automatically
--   {
--       'tpope/vim-sleuth',
--       version = 'v2.x'
--   },
-- 
--   -- NOTE: This is where your plugins related to LSP can be installed.
--   --  The configuration is done below. Search for lspconfig to find it below.
--   { -- LSP Configuration & Plugins
--     'neovim/nvim-lspconfig',
--     version = 'v0.1.x',
--     dependencies = {
--       -- Automatically install LSPs to stdpath for neovim
--       { 'williamboman/mason.nvim', config = true , tag = 'stable'},
--       { 'williamboman/mason-lspconfig.nvim', tag = 'stable' },
-- 
--       -- Useful status updates for LSP
--       -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
--       { 'j-hui/fidget.nvim', opts = {} },
-- 
--       -- Additional lua configuration, makes nvim stuff amazing!
--       { 'folke/neodev.nvim', tag = 'stable' },
--     },
--   },
-- 
--   { -- Autocompletion
--     'hrsh7th/nvim-cmp',
--     dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
--   },
-- 
--   -- Useful plugin to show you pending keybinds.
--   { 'folke/which-key.nvim', opts = {} },
--   { -- Adds git releated signs to the gutter, as well as utilities for managing changes
--     'lewis6991/gitsigns.nvim',
--     opts = {
--       -- See `:help gitsigns.txt`
--       signs = {
--         add = { text = '+' },
--         change = { text = '~' },
--         delete = { text = '_' },
--         topdelete = { text = '‾' },
--         changedelete = { text = '~' },
--       },
--     },
--   },
-- 
--   { -- Theme inspired by Atom
--     'navarasu/onedark.nvim',
--     priority = 1000,
--     config = function()
--       vim.cmd.colorscheme 'onedark'
--     end,
--   },
-- 
--   { -- Set lualine as statusline
--     'nvim-lualine/lualine.nvim',
--     -- See `:help lualine.txt`
--     opts = {
--       options = {
--         icons_enabled = false,
--         theme = 'onedark',
--         component_separators = '|',
--         section_separators = '',
--       },
--     },
--   },
-- 
--   { -- Add indentation guides even on blank lines
--     'lukas-reineke/indent-blankline.nvim',
--     -- Enable `lukas-reineke/indent-blankline.nvim`
--     -- See `:help indent_blankline.txt`
--     opts = {
--       char = '┊',
--       show_trailing_blankline_indent = false,
--     },
--     version = 'v2.20.*',
--   },
-- 
--   -- "gc" to comment visual regions/lines
--   { 'numToStr/Comment.nvim', opts = {}, version = 'v0.8.x' },
-- 
--   -- Fuzzy Finder (files, lsp, etc)
--   { 'nvim-telescope/telescope.nvim', version = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim', version = 'v0.1.x' } },
-- 
--   -- Fuzzy Finder Algorithm which requires local dependencies to be built.
--   -- Only load if `make` is available. Make sure you have the system
--   -- requirements installed.
--   {
--     'nvim-telescope/telescope-fzf-native.nvim',
--     -- NOTE: If you are having trouble with this installation,
--     --       refer to the README for telescope-fzf-native for more instructions.
--     build = 'make',
--     cond = function()
--       return vim.fn.executable 'make' == 1
--     end,
--   },
-- 
--   { -- Highlight, edit, and navigate code
--     'nvim-treesitter/nvim-treesitter',
--     dependencies = {
--       'nvim-treesitter/nvim-treesitter-textobjects',
--     },
--     build = ":TSUpdate",
--     version = 'v0.9.x',
--   },
-- 
--   {
--   "nvim-neo-tree/neo-tree.nvim",
--     branch = "v2.x",
--     dependencies = { 
--       "nvim-lua/plenary.nvim",
--       "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
--       "MunifTanjim/nui.nvim",
--     },
--     build = ":let g:neo_tree_remove_legacy_commands = 1",
--   }
-- }, {})
-- 
-- -- [[ Setting options ]]
-- -- See `:help vim.o`
-- 
-- -- Set highlight on search
-- vim.o.hlsearch = false
-- vim.o.incsearch = true
-- 
-- -- Make line numbers default
-- vim.wo.number = true
-- 
-- -- Enable mouse mode
-- vim.o.mouse = 'n'
-- 
-- -- Sync clipboard between OS and Neovim.
-- --  Remove this option if you want your OS clipboard to remain independent.
-- --  See `:help 'clipboard'`
-- -- vim.o.clipboard = 'unnamedplus'
-- 
-- -- Enable break indent
-- vim.o.breakindent = true
-- 
-- -- Save undo history
-- vim.o.undofile = false
-- 
-- -- Case insensitive searching UNLESS /C or capital in search
-- vim.o.ignorecase = true
-- vim.o.smartcase = true
-- 
-- -- Keep signcolumn on by default
-- vim.wo.signcolumn = 'yes'
-- 
-- -- Decrease update time
-- vim.o.updatetime = 250
-- vim.o.timeout = true
-- vim.o.timeoutlen = 300
-- 
-- -- Set completeopt to have a better completion experience
-- vim.o.completeopt = 'menuone,noselect'
-- 
-- -- NOTE: You should make sure your terminal supports this
-- vim.o.termguicolors = true
-- 
-- -- [[ Basic Keymaps ]]
-- 
-- -- vim.api.nvim_create_autocmd({"VimResized"}, {
-- --   callback = function()
-- --     local numberOfWindows = vim.call("winnrd", "$")
-- --     print(numberOfWindows)
-- --     vim.wo.colorcolumn = tostring(vim.call("winwidth", 0) - 6*numberOfWindows)
-- --   end
-- -- })
-- 
-- -- split windows
-- vim.keymap.set("n", "<leader>sh", "<C-w>s")
-- vim.keymap.set("n", "<leader>sv", "<C-w>v")
-- vim.keymap.set("n", "<leader>se", "<C-w>=")
-- vim.keymap.set("n", "<leader>sx", ":close<cr>")
-- 
-- vim.keymap.set("n", "<leader>to", ":tabnew<cr>")
-- vim.keymap.set("n", "<leader>tx", ":tabclose<cr>")
-- vim.keymap.set("n", "<leader>tn", ":tabn<cr>")
-- vim.keymap.set("n", "<leader>tp", ":tabp<cr>")
-- 
-- vim.keymap.set("n", "<leader>tv", "<C-w>v:term<cr>")
-- vim.keymap.set("n", "<leader>th", "<C-w>s:term<cr>")
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-N>")
-- vim.keymap.set("t", "<leader>tx", "<C-\\><C-N>:q<cr>")
-- vim.api.nvim_create_autocmd({"TermOpen"}, {
--   callback = function()
--     vim.cmd("startinsert")
--   end
-- })
-- 
-- -- move selected rows
-- vim.keymap.set("v", "J", ":m '>+1<cr>gv")
-- vim.keymap.set("v", "K", ":m '<-2<cr>gv")
-- 
-- vim.keymap.set("n", "n", "nzz")
-- vim.keymap.set("n", "N", "Nzz")
-- 
-- -- blanking cursor
-- vim.opt.guicursor = ""
-- 
-- vim.opt.splitright = true
-- vim.splitbelow = true
-- 
-- vim.keymap.set("n", "x", '"_x')
-- 
-- vim.opt.relativenumber = true
-- 
-- vim.opt.smartindent = true
-- 
-- vim.opt.swapfile = false
-- vim.opt.backup = false
-- 
-- vim.opt.scrolloff = 8
-- 
-- 
-- -- Keymaps for better default experience
-- -- See `:help vim.keymap.set()`
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- 
-- -- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- 
-- -- [[ Highlight on yank ]]
-- -- See `:help vim.highlight.on_yank()`
-- local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
-- vim.api.nvim_create_autocmd('TextYankPost', {
--   callback = function()
--     vim.highlight.on_yank()
--   end,
--   group = highlight_group,
--   pattern = '*',
-- })
-- 
-- 
-- -- [[ Configure Neotree ]]
-- -- see `:h neo-tree`
-- vim.keymap.set('n', '<leader>e', ':Neotree reveal toggle<cr>')
-- 
-- -- [[ Configure Telescope ]]
-- -- See `:help telescope` and `:help telescope.setup()`
-- require('telescope').setup {
--   defaults = {
--     mappings = {
--       i = {
--         ['<C-u>'] = false,
--         ['<C-d>'] = false,
--       },
--     },
--   },
-- }
-- 
-- -- Enable telescope fzf native, if installed
-- pcall(require('telescope').load_extension, 'fzf')
-- 
-- -- See `:help telescope.builtin`
-- vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
-- vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
-- vim.keymap.set('n', '<leader>/', function()
--   -- You can pass additional configuration to telescope to change theme, layout, etc.
--   require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--     winblend = 10,
--     previewer = false,
--   })
-- end, { desc = '[/] Fuzzily search in current buffer' })
-- 
-- vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
-- vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
-- vim.keymap.set('n', '<leader>h', require('telescope.builtin').help_tags, { desc = 'Search [H]elp' })
-- vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
-- 
-- -- [[ Configure Treesitter ]]
-- -- See `:help nvim-treesitter`
-- require('nvim-treesitter.configs').setup {
--   -- Add languages to be installed here that you want installed for treesitter
--   ensure_installed = { 'go', 'lua', 'python', 'javascript', 'vimdoc', 'vim', 'html', 'css', 'yaml', 'terraform' },
-- 
--   -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
--   auto_install = false,
-- 
--   highlight = { enable = true },
--   indent = { enable = true, disable = { 'python' } },
--   incremental_selection = {
--     enable = true,
--     keymaps = {
--       init_selection = '<c-space>',
--       node_incremental = '<c-space>',
--       scope_incremental = '<c-s>',
--       node_decremental = '<M-space>',
--     },
--   },
--   textobjects = {
--     select = {
--       enable = true,
--       lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
--       keymaps = {
--         -- You can use the capture groups defined in textobjects.scm
--         ['aa'] = '@parameter.outer',
--         ['ia'] = '@parameter.inner',
--         ['af'] = '@function.outer',
--         ['if'] = '@function.inner',
--         ['ac'] = '@class.outer',
--         ['ic'] = '@class.inner',
--       },
--     },
--     move = {
--       enable = true,
--       set_jumps = true, -- whether to set jumps in the jumplist
--       goto_next_start = {
--         [']m'] = '@function.outer',
--         [']]'] = '@class.outer',
--       },
--       goto_next_end = {
--         [']M'] = '@function.outer',
--         [']['] = '@class.outer',
--       },
--       goto_previous_start = {
--         ['[m'] = '@function.outer',
--         ['[['] = '@class.outer',
--       },
--       goto_previous_end = {
--         ['[M'] = '@function.outer',
--         ['[]'] = '@class.outer',
--       },
--     },
--     swap = {
--       enable = true,
--       swap_next = {
--         ['<leader>a'] = '@parameter.inner',
--       },
--       swap_previous = {
--         ['<leader>A'] = '@parameter.inner',
--       },
--     },
--   },
-- }
-- 
-- -- Diagnostic keymaps
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
-- -- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
-- 
-- -- LSP settings.
-- --  This function gets run when an LSP connects to a particular buffer.
-- local on_attach = function(_, bufnr)
--   -- NOTE: Remember that lua is a real programming language, and as such it is possible
--   -- to define small helper and utility functions so you don't have to repeat yourself
--   -- many times.
--   --
--   -- In this case, we create a function that lets us more easily define mappings specific
--   -- for LSP related items. It sets the mode, buffer and description for us each time.
--   local nmap = function(keys, func, desc)
--     if desc then
--       desc = 'LSP: ' .. desc
--     end
-- 
--     vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
--   end
-- 
--   nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
--   nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
-- 
--   nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
--   nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
--   nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
--   nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
--   nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
--   nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
-- 
--   -- See `:help K` for why this keymap
--   nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
--   nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
-- 
--   -- Lesser used LSP functionality
--   nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
--   nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
--   nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
--   nmap('<leader>wl', function()
--     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--   end, '[W]orkspace [L]ist Folders')
-- 
--   -- Create a command `:Format` local to the LSP buffer
--   vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
--     vim.lsp.buf.format()
--   end, { desc = 'Format current buffer with LSP' })
-- end
-- 
-- -- Enable the following language servers
-- --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
-- --
-- --  Add any additional override configuration in the following tables. They will be passed to
-- --  the `settings` field of the server config. You must look up that documentation yourself.
-- local servers = {
--   -- clangd = {},
--   -- gopls = {},
--   -- pyright = {},
--   -- rust_analyzer = {},
--   -- tsserver = {},
-- 
--   -- lua_ls = {
--   --   Lua = {
--   --     workspace = { checkThirdParty = false },
--   --     telemetry = { enable = false },
--   --   },
--   -- },
-- }
-- 
-- -- Setup neovim lua configuration
-- require('neodev').setup()
-- 
-- -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
-- 
-- -- Ensure the servers above are installed
-- local mason_lspconfig = require 'mason-lspconfig'
-- 
-- mason_lspconfig.setup {
--   ensure_installed = vim.tbl_keys(servers),
-- }
-- 
-- mason_lspconfig.setup_handlers {
--   function(server_name)
--     require('lspconfig')[server_name].setup {
--       capabilities = capabilities,
--       on_attach = on_attach,
--       settings = servers[server_name],
--     }
--   end,
-- }
-- 
-- -- nvim-cmp setup
-- local cmp = require 'cmp'
-- local luasnip = require 'luasnip'
-- 
-- luasnip.config.setup {}
-- 
-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       luasnip.lsp_expand(args.body)
--     end,
--   },
--   mapping = cmp.mapping.preset.insert {
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete {},
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     ['<Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_next_item()
--       elseif luasnip.expand_or_jumpable() then
--         luasnip.expand_or_jump()
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--     ['<S-Tab>'] = cmp.mapping(function(fallback)
--       if cmp.visible() then
--         cmp.select_prev_item()
--       elseif luasnip.jumpable(-1) then
--         luasnip.jump(-1)
--       else
--         fallback()
--       end
--     end, { 'i', 's' }),
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' },
--   },
-- }
-- 
-- -- The line beneath this is called `modeline`. See `:help modeline`
-- -- vim: ts=2 sts=2 sw=2 et
-- 
-- 
