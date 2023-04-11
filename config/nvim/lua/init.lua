print('((╬◣﹏◢))')

-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

vim.opt.number = false -- show line numbers (x)
vim.opt.mouse = 'a' -- allow mouse
vim.opt.ignorecase = true -- ignore case 
vim.opt.smartcase = true -- INCLUDE will be treated the same as include
vim.opt.hlsearch = false -- Highlight search matches (x)
vim.opt.wrap = true -- wrap text 
vim.opt.breakindent = true -- line is visually indented
vim.opt.tabstop = 4 -- tabstop value
vim.opt.shiftwidth = 4 -- amount of spaces for a deeper level
vim.opt.expandtab = false -- expand tab to convert new tabs to spaces (x)
vim.wo.fillchars = 'eob: ' -- backslash whitespace

-- ========================================================================== --
-- ==                             KEYBINDINGS                              == --
-- ========================================================================== --

-- space as leader key
vim.g.mapleader = ' '

-- shortcuts
vim.keymap.set({'n', 'x', 'o'}, '<leader>h', '^')
vim.keymap.set({'n', 'x', 'o'}, '<leader>l', 'g_')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'cp', '"+y')
vim.keymap.set({'n', 'x'}, 'cv', '"+p')

-- delete text
vim.keymap.set({'n', 'x'}, 'x', '"_x')

-- mapping commands
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<leader>bq', '<cmd>bdelete<cr>')
vim.keymap.set('n', '<leader>bl', '<cmd>buffer #<cr>')


-- ========================================================================== --
-- ==                               COMMANDS                               == --
-- ========================================================================== --

vim.api.nvim_create_user_command('ReloadConfig', 'source $MYVIMRC', {})

local group = vim.api.nvim_create_augroup('user_cmds', {clear = true})

vim.api.nvim_create_autocmd('TextYankPost', {
  	desc = 'Highlight on yank',
 	group = group,
 	callback = function()
		vim.wo.fillchars = 'eob: '
	end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  	desc = '',
 	group = group,
 	callback = function()
		vim.highlight.on_yank({higroup = 'Visual', timeout = 200})
	end,
})

vim.api.nvim_create_autocmd('FileType', {
	pattern = {'help', 'man'},
  	group = group,
  	command = 'nnoremap <buffer> q <cmd>quit<cr>'
})

vim.api.nvim_create_autocmd( "FileType", {
	pattern = { "SuperCollider" }, 
	command = [[silent! lua require('scnvim').start()]] 
})

-- syntax off
vim.cmd("syntax off")

-- vim.api.nvim_create_autocmd('FileType', {
--	pattern = {'scnvim'},
--	group = group,
--  	command = 'opt_local.wrap = true'
-- })

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  -- You can "comment out" the line below after lazy.nvim is installed
  -- lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)
  require('lazy').setup(plugins, lazy.opts)
end

lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}

lazy.setup({
  {'folke/tokyonight.nvim'},
  {'nvim-tree/nvim-web-devicons'},
  {'nvim-lualine/lualine.nvim'},
  {'davidgranstrom/scnvim'},
  {'kdheepak/monochrome.nvim'},
  {'windwp/nvim-autopairs'},
  {'jesseleite/nvim-noirbuddy'},
  {'tjdevries/colorbuddy.nvim', branch = 'dev' },
  {'onsails/lspkind.nvim'},
  {'L3MON4D3/LuaSnip'}, -- luasnip snippets
  {'hrsh7th/nvim-cmp'}, -- completion engine
  {'quangnguyen30192/cmp-nvim-tags'}, -- completion source for tags
  {'saadparwaiz1/cmp_luasnip'}, -- completion source for luasnip snippets
  {'nvim-tree/nvim-tree.lua', version = "*"},
  {'folke/which-key.nvim'}
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- nvim-autopairs
---

local status_ok, npairs = pcall(require, 'nvim-autopairs')
if not status_ok then
	return
end

---
-- colorscheme
---
vim.opt.termguicolors = true
vim.cmd.colorscheme('monochrome')
vim.cmd 'set termguicolors'

---
-- noirbuddy
--

local color1 = '#000000' -- '#000000'
local color2 = '#d4d5da' -- '#d3d3d3'

require('noirbuddy').setup({
	  colors = {
		  -- `primary` is for numbers 
		  primary = color2,
		  -- `secondary` is for var sign
		  secondary = color2,
		  -- `background` is for bg
		  background = color1,
		  -- `noir_0` is light for dark themes, and dark for light themes
		  noir_0 = color2,
		  --  `noir_1` is light for curl {} brackets, ugen methods (only .kr, .ar)
		  noir_1 = color2,
		  -- idk
		  noir_2 = color2,
		  -- idk
		  noir_3 = color2,
		  -- `noir_4` is light for variables, class methods
		  noir_4 = color2,
		  -- `noir_5` is light for *, /, =, tanh etc
		  noir_5 = color2,
		  -- `noir_6` is light for some elements in nvim intro
		  noir_6 = color2,
		  -- idk 
		  noir_7 = color2,
		  -- `noir_8` is light for numbers, line numbers, ~ and post window divider
		  -- selection
		  noir_8 = color2,
		  -- `noir_9` is dark for dark themes, and light for light themes
		  --  (also for post window divider line)
		  noir_9 = color1
	  }
})

---
-- nvim-web-devicons
---

require'nvim-web-devicons'.setup {
 -- your personnal icons can go here (to override)
 -- you can specify color or cterm_color instead of specifying both of them
 -- DevIcon will be appended to `name`
 override = {
  zsh = {
    icon = "",
    color = "#428850",
    cterm_color = "65",
    name = "Zsh"
  }
 };
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
 -- globally enable "strict" selection of icons - icon will be looked up in
 -- different tables, first by filename, and if not found by extension; this
 -- prevents cases when file doesn't have any extension but still gets some icon
 -- because its name happened to match some extension (default to false)
 strict = true;
 -- same as `override` but specifically for overrides by filename
 -- takes effect when `strict` is true
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 -- same as `override` but specifically for overrides by extension
 -- takes effect when `strict` is true
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  }
 };
}

---
-- lualine.nvim (statusline)
---

-- polling scsynth status 

local function scstatus()
	if vim.bo.filetype == "supercollider" then
		stat = vim.fn["scnvim#statusline#server_status"]()
		stat = stat:gsub("%%", "☍")
		return stat
	else
		return ""
	end
end

local status_ok_colors, colors = pcall(require, "noirbuddy.colors")
if not status_ok_colors then
    return
end

local c = colors.all()

local theme = {
    normal = {
        a = { fg = c.gray_3, bg = c.gray_8, gui = "bold" },
        b = { fg = c.gray_3, bg = c.gray_9 },
        c = { fg = c.gray_3, bg = c.gray_8 },
    },
    insert = { a = { fg = c.black, bg = c.gray_2, gui = "bold" } },
    visual = { a = { fg = c.black, bg = c.gray_2, gui = "bold" } },
    replace = { a = { fg = c.black, bg = c.gray_1, gui = "bold" } },
    inactive = {
        a = { fg = c.gray_1, bg = c.black },
        b = { fg = c.gray_1, bg = c.black },
        c = { fg = c.gray_1, bg = c.black },
    },
}

local sections = { 
	lualine_a = {'mode'},
  	lualine_b = {},
  	lualine_c = {'filename'},
  	lualine_x = {scstatus},
  	lualine_y = {},
  	lualine_z = {}
}

local noirbuddy_lualine = require("noirbuddy.plugins.lualine")

local inactive_sections = noirbuddy_lualine.inactive_sections

require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = theme,
        filetype = { colored = false },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = sections,
    inactive_sections = inactive_sections
}

---
-- luasnip
---

vim.g.scnvim_snippet_format = 'luasnip'
require("luasnip").add_snippets("supercollider", require("scnvim/utils").get_snippets())

---
-- cmp 
---

local cmp = require'cmp'

local next_item = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end

local prev_item = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  else
    fallback()
  end
end

cmp.setup({
	snippet = {
		expand = function(args)
		require('luasnip').lsp_expand(args.body) -- for `luasnip` users.
		-- vim.fn["UltiSnips#Anon"](args.body) -- for `ultisnips` users.
		end,
		},
	sources = {
		{ name = 'tags', max_item_count = 3 },
		-- { name = 'luasnip', max_item_count = 2 }, -- for luasnip users
		{ name = "buffer",  max_item_count = 1 }, -- text within current buffer
  		{ name = "path",  max_item_count = 1 }
	},
	mapping = cmp.mapping.preset.insert({
   	 	['<A-Tab>'] = cmp.mapping.confirm({ select = true }),
		['<Tab>'] = cmp.mapping(next_item, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(prev_item , { 'i', 's' }),
      		['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    	}),
	view = {
		entries = { name = 'custom', separator = '|', selection_order = 'near_cursor' }
	},
	window = {
		completion = cmp.config.window.bordered({
			border = 'single',
		})
	}
})

---
-- nvim-tree
---

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- OR setup with some options
require("nvim-tree").setup({
	view = { 
		number = false,
		relativenumber = false,
		float = {
			enable = true,
			quit_on_focus_loss = true,
			open_win_config = {
				relative = "editor",
				border = "rounded",
				width = 30,
				height = 30,
				row = 1,
				col = 1,
			}
		}
	},
	filters = {
        	dotfiles = true,
        	git_clean = false,
        	no_buffer = false,
        	custom = {},
        	exclude = {},
	}
})

---
-- which-key
---

local status_ok_colors, wk = pcall(require, 'which-key')
if not status_ok_colors then
    return
end

wk.register({
	['<A-b>'] = { '<cmd>NvimTreeToggle<cr>', 'Explorer' } -- <A-b> :NvimTreeToggle
})

---
-- scnvim
---

local scnvim = require 'scnvim'
local map = scnvim.map
local map_expr = scnvim.map_expr
scnvim.setup {
  ensure_installed = true,
  sclang = {
    cmd = nil,
    args = {},
  },
  keymaps = {
    ['<A-e>'] = map('editor.send_line', {'i', 'n', 'x'}),
    ['<A-w>'] = {
      map('editor.send_block', {'i', 'n', 'x'}),
      map('editor.send_selection', 'i', 'n', 'x'),
    },
    ['<CR>'] = map('postwin.toggle'),
    ['<M-L>'] = map('postwin.clear', {'n', 'i'}),
    ['<C-k>'] = map('signature.show', {'n', 'i'}),
    ['<A-q>'] = map('sclang.hard_stop', {'n', 'x', 'i'}),
    ['<leader>st'] = map('sclang.start'),
    ['<leader>sk'] = map('sclang.recompile'),
    ['<F1>'] = map_expr('Nth.fast()'),
    ['<F2>'] = map_expr('s.meter'),
    ['<F3>'] = map_expr('s.scope'),
    ['<F4>'] = map_expr('s.freqscope')
  },
  documentation = {
    cmd = nil,
    horizontal = true,
    direction = 'top',
    keymaps = true,
  },
  postwin = {
    highlight = false,
    auto_toggle_error = true,
    scrollback = 5000,
    horizontal = true,
    direction = 'right',
    size = nil,
    fixed_size = nil,
    keymaps = nil,
    float = {
      enabled = true,
      row = 0,
      col = function()
        return vim.o.columns
      end,
      width = 48,
      height = 14,
      config = {
        border = "rounded"
      },
      callback = function(id)
        vim.api.nvim_win_set_option(id, 'winblend', 10)
      end,
    },
  },
  editor = {
    force_ft_supercollider = true,
    highlight = {
      color = 'TermCursor',
      type = 'flash',
      flash = {
        duration = 100,
        repeats = 2,
      },
      fade = {
        duration = 375,
      },
    },
    signature = {
      float = true,
      auto = true,
    },
  },
  snippet = {
    engine = {
      name = 'luasnip',
      options = {
        descriptions = true,
      },
    },
  },
  statusline = {
    poll_interval = 1,
  },
  extensions = {},
}

-- wrap text in post window
require('scnvim.postwin').on_open:append(function()
  vim.opt_local.wrap = true
end)

