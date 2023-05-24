vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.autowriteall = "true"

vim.wo.foldmethod = "indent"
vim.wo.foldlevel = 99

vim.g.relativenumber = true
vim.wo.relativenumber = true

vim.g.number = true
vim.wo.number = true

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
		"barrett-ruth/live-server.nvim",
		config = function()
			require("live-server").setup()
			keymap("n", "<leader>ls", ":LiveServerStart<cr>")
			keymap("n", "<leader>lS", ":LiveServerStop<cr>")
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup()
		end,
	},
	{
		"f-person/git-blame.nvim",
		config = function()
			keymap("n", "<leader>gb", ":GitBlameToggle<cr>")
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("trouble").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
			keymap("n", "<leader>tr", ":TroubleToggle workspace_diagnostics<cr>")
		end,
	},
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		config = function()
			vim.o.foldcolumn = "0" -- '0' is not bad
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", require("ufo").openAllFolds)
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

			require("ufo").setup()
		end,
	},
	{
		"sindrets/diffview.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			keymap("n", "<leader>gl", ":DiffviewFileHistory<CR>")
			keymap("n", "<leader>gd", ":DiffviewOpen<CR>")
			keymap("n", "<leader>gD", ":DiffviewOpen ")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				-- for example, context is off by default, use this to turn it on
				show_current_context = true,
				show_current_context_start = true,
			})
		end,
	},
	{
		"mhartington/formatter.nvim",
		config = function()
			-- Utilities for creating configurations
			local util = require("formatter.util")
			local jsBeautify = function(type)
				return {
					function()
						-- Full specification of configurations is down below and in Vim help
						-- files
						return {
							exe = "js-beautify",
							args = {
								"--type",
								type,
								"--file",
								util.escape_path(util.get_current_buffer_file_path()),
							},
							stdin = true,
						}
					end,
				}
			end

			local filetypesSettings = {
				python = {
					function()
						return {
							exe = "black",
							args = {
								"--stdin-filename",
								util.escape_path(util.get_current_buffer_file_path()),
							},
							stdin = false,
						}
					end,
				},
				css = jsBeautify("css"),
				html = jsBeautify("html"),
				javascript = jsBeautify("js"),
				lua = {
					-- "formatter.filetypes.lua" defines default configurations for the
					-- "lua" filetype
					require("formatter.filetypes.lua").stylua,
				},
				-- Use the special "*" filetype for defining formatter configurations on
				-- any filetype
				["*"] = {
					-- "formatter.filetypes.any" defines default configurations for any
					-- filetype
					require("formatter.filetypes.any").remove_trailing_whitespace,
				},
			}

			-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
			require("formatter").setup({
				-- Enable or disable logging
				logging = true,
				-- Set the log level
				log_level = vim.log.levels.WARN,
				-- All formatter configurations are opt-in
				filetype = filetypesSettings,
			})

			-- local formatterGroup = vim.api.nvim_create_augroup("FormatterOnSave", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				group = vim.api.nvim_create_augroup("FormatterOnSave", { clear = true }),
				command = "FormatWrite",
			})

			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = { "yaml", "gh-actions" },
				callback = function(_)
					vim.bo.softtabstop = 2
					vim.bo.shiftwidth = 2
					vim.bo.expandtab = true
				end,
			})
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			vim.g.mkdp_auto_close = 0
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	{
		"tpope/vim-fugitive",
		config = function()
			keymap("n", "<leader>gi", ":Git<CR>")
			keymap("n", "<leader>gL", ":Gclog<CR>")
		end,
	},
	-- {
	--   "dense-analysis/ale",
	--   config = function()
	--     vim.g.ale_fixers = {
	--       ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
	--       ['terraform'] = {'terraform'},
	--     }
	--     vim.g.ale_fix_on_save = 1
	--   end,
	-- },

	{
		"williamboman/mason.nvim",
		build = "vim.cmd(':MasonUpdate')", -- :MasonUpdate updates registry contents
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = "williamboman/mason.nvim",
		config = function()
			require("mason-lspconfig").setup()
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = "williamboman/mason-lspconfig.nvim",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local language_servers = require("mason-lspconfig").get_installed_servers() -- or list servers manually like {'gopls', 'clangd'}

			require("lspconfig").tflint.setup({})
			for _, ls in pairs(language_servers) do
				require("lspconfig")[ls].setup({
					capabilities = capabilities,
					-- you can add other fields for setting up lsp server in this table
				})

				require("lspconfig").lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { "vim" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file("", true),
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = {
								enable = false,
							},
						},
					},
				})
			end

			keymap("n", "<leader>de", vim.lsp.buf.definition)
			keymap("n", "<leader>dc", vim.lsp.buf.declaration)

			-- keymap("n", '<leader>lf', function()
			--   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- end)
			--
			--   require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
			--     capabilities = capabilities
			--   }

			--Enable (broadcasting) snippet capability for completion
			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- local htmlGroup = vim.api.nvim_create_augroup('FormatHtml', { clear = true })
			-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
			--   group = htmlGroup,
			--   pattern = {"*.html"},
			--   callback = function()
			--     vim.lsp.buf.format{
			--       filter = function(client) return client.name == "html" end
			--     }
			--   end,
			-- })

			-- local cssGroup = vim.api.nvim_create_augroup('FormatCss', { clear = true })
			-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
			--   group = cssGroup,
			--   pattern = {"*.css"},
			--   callback = function()
			--     vim.lsp.buf.format{
			--       filter = function(client) return client.name == "cssls" end
			--     }
			--   end,
			-- })

			vim.filetype.add({
				pattern = {
					[".*%.github/workflows/.*%.yml"] = "gh-actions",
					[".*%.github/workflows/.*%.yaml"] = "gh-actions",
				},
			})
			-- require'lspconfig'.actionlint.setup{
			--   cmd = { "actionlint" },
			--   filetypes = { "gh-actions" },
			--   -- root_dir =
			-- }

			-- require'lspconfig'.terraformls.setup{ capabilities = capabilities, }
			-- vim.api.nvim_create_autocmd({"BufWritePre"}, {
			--   pattern = {"*.tf", "*.tfvars"},
			--   callback = function()
			--     vim.lsp.buf.format{
			--       filter = function(client) return client.name == "terraformls" end
			--     }
			--   end,
			-- })
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			vim.cmd(":TSUpdate")
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"terraform",
					"lua",
					"vim",
					"vimdoc",
					"python",
					"go",
					"bash",
					"gitcommit",
					"java",
					"json",
					"make",
					"regex",
					"sql",
					"yaml",
				},

				sync_install = false,

				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = false,

				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

				highlight = {
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
			vim.treesitter.language.add("terraform", { filetype = "terraform-vars" })
			vim.treesitter.language.add("yaml", { filetype = "gh-actions" })
		end,
	},

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
		"szw/vim-maximizer",
		config = keymap("n", "<leader>sm", ":MaximizerToggle<CR>"),
	},

	"tpope/vim-surround",

	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
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
			-- local neotreeOpen = vim.api.nvim_create_augroup('OpenNeotree', { clear = true })
			-- vim.api.nvim_create_autocmd({"BufAdd"}, {
			--   group = htmlGroup,
			--   pattern = {"*.html"},
			--   callback = function()
			--     vim.lsp.buf.format{
			--       filter = function(client) return client.name == "html" end
			--     }
			--   end,
			-- })

			local htmlGroup = vim.api.nvim_create_augroup("FormatHtml", { clear = true })
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = htmlGroup,
				pattern = { "*.html" },
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							return client.name == "html"
						end,
					})
				end,
			})
		end,
	},

	"nvim-tree/nvim-web-devicons",

	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = false,
				theme = "onedark",
				component_separators = "|",
				section_separators = "",
			},
		},
	},

	{
		"nvim-telescope/telescope.nvim",
		version = "*",
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
			keymap("n", "<leader>di", require("telescope.builtin").diagnostics)
			keymap("n", "<leader>/", function()
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end)
			-- )
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-nvim-lsp",
		},
		--     dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
				}, {
					{ name = "buffer" },
				}, {
					{ name = "path" },
				}),
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
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			vim.opt.completeopt = "menu,menuone,noselect"
		end,
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
		end,
	},

	{
		"klen/nvim-test",
		config = function()
			require("nvim-test").setup()
			keymap("n", "<leader>ts", ":TestSuite<cr>")
			keymap("n", "<leader>tf", ":TestFile<cr>")
			keymap("n", "<leader>tt", ":TestNearest<cr>")
		end,
	},
}, {})

-- vim.api.nvim_buf_create_user_command(vim.bufnr, 'Format', function(_)
--   vim.lsp.buf.format()
-- end, { desc = 'Format current buffer with LSP' })

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

keymap("n", "<c-u>", "<c-u>zz")
keymap("n", "<c-d>", "<c-d>zz")
-- copy to system clipboard
keymap("v", "<leader>y", '"+y')
-- paste from system clipboard
keymap("v", "<leader>p", '"+p')

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
keymap("n", "<leader>sH", ":bo split<cr>")
keymap("n", "<leader>sv", "<C-w>v")
keymap("n", "<leader>sV", ":bo vsplit<cr>")
keymap("n", "<leader>se", "<C-w>=")
keymap("n", "<leader>sq", ":q<CR>")
keymap("n", "<leader>sQ", ":q!<CR>")
keymap("n", "<leader>sx", ":bd!<CR>")
-- keymap("n", "<leader>sX", ":bd!<CR>")
vim.opt.splitright = true
vim.splitbelow = true

-- tabs
keymap("n", "<leader>to", ":tabnew<CR>")
keymap("n", "<leader>tn", ":tabn<CR>")
keymap("n", "<leader>tp", ":tabp<CR>")
keymap("n", "<leader>tx", ":tabclose<CR>")

-- terminal
-- keymap("n", "<leader>tv", "<C-w>v:term<cr>")
keymap("n", "<leader>tv", ":bo :vsplit<cr>:term<cr>")
keymap("n", "<leader>th", ":bo :split<cr>:term<cr>")
keymap("t", "<Esc>", "<C-\\><C-N>")
-- keymap("t", "<leader>tx", "<C-\\><C-N>:q<cr>")
vim.api.nvim_create_autocmd({ "TermOpen" }, {
	callback = function()
		-- vim.wo.leader('')
		vim.cmd("startinsert")
	end,
})

-- Set highlight on search
vim.o.hlsearch = false
vim.o.incsearch = true

vim.opt.scrolloff = 8
vim.opt.guicursor = ""

vim.wo.signcolumn = "yes"

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false

-- vim.o.foldmethod = "syntax"

-- require('lazy').setup({
--   -- NOTE: First, some plugins that don't require any configuration
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
-- -- [[ Setting options ]]
-- -- See `:help vim.o`
--
--
-- -- Enable mouse mode
vim.o.mouse = "nic"
--
-- -- Sync clipboard between OS and Neovim.
-- --  Remove this option if you want your OS clipboard to remain independent.
-- --  See `:help 'clipboard'`
-- -- vim.o.clipboard = 'unnamedplus'
--
-- -- Enable break indent
vim.o.breakindent = true
--
-- -- Save undo history
vim.o.undofile = false
--
-- -- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- -- Decrease update time
-- vim.o.updatetime = 250
-- vim.o.timeout = true
-- vim.o.timeoutlen = 300
--
-- -- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
--
-- -- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true
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
--
--
--
--
--
--
-- -- Keymaps for better default experience
-- -- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
--
-- -- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
--
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
-- vim.keymap.set('n', '<leader>/', function()
--   -- You can pass additional configuration to telescope to change theme, layout, etc.
--
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
--
