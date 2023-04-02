print('((╬◣﹏◢))')

-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

vim.opt.number = false
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = false

-- ========================================================================== --
-- ==                             KEYBINDINGS                              == --
-- ========================================================================== --

-- Space as leader key
vim.g.mapleader = ' '

-- Shortcuts
vim.keymap.set({'n', 'x', 'o'}, '<leader>h', '^')
vim.keymap.set({'n', 'x', 'o'}, '<leader>l', 'g_')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'cp', '"+y')
vim.keymap.set({'n', 'x'}, 'cv', '"+p')

-- Delete text
vim.keymap.set({'n', 'x'}, 'x', '"_x')

-- Commands
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
  {'kyazdani42/nvim-web-devicons'},
  {'nvim-lualine/lualine.nvim'},
  {'davidgranstrom/scnvim'},
  {'kdheepak/monochrome.nvim'},
  {'jesseleite/nvim-noirbuddy'},
  {'tjdevries/colorbuddy.nvim', branch = 'dev' }
})

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- Colorscheme
---
vim.opt.termguicolors = true
vim.cmd.colorscheme('monochrome')

---
-- noirbuddy
---

require('noirbuddy').setup({
	  colors = {
		  -- `primary` is for numbers 
		  primary = '#d3d3d3',
		  -- `primary` is for var sign
		  secondary = '#d3d3d3',
		  -- `background` is for bg
		  background = '#000000',
		  -- `noir_0` is light for dark themes, and dark for light themes
		  noir_0 = '#d3d3d3',
		  --  `noir_1` is light for curl {} brackets, ugen methods (only .kr, .ar)
		  noir_1 = '#d3d3d3',
		  -- idk
		  noir_2 = '#d3d3d3',
		  -- idk
		  noir_3 = '#d3d3d3',
		  -- `noir_4` is light for variables, class methods
		  noir_4 = '#d3d3d3',
		  -- `noir_5` is light for *, /, =, tanh etc
		  noir_5 = '#d3d3d3',
		  -- `noir_6` is light for some elements in nvim intro
		  noir_6 = '#ff0000',
		  -- idk 
		  noir_7 = '#d3d3d3',
		  -- `noir_8` is light for numbers, line numbers, ~ and post window divider
		  noir_8 = '#d3d3d3',
		  -- `noir_9` is dark for dark themes, and light for light themes
		  --  (also for post window divider line)
		  noir_9 = '#000000',
    }
})

---
-- lualine.nvim (statusline)
---
vim.opt.showmode = false
require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'monochrome',
    component_separators = '|',
    section_separators = '',
  },
})

-- noirbuddy lualine

local status_ok_lualine, lualine = pcall(require, "lualine")

if not status_ok_lualine then
    return
end

local noirbuddy_lualine = require("noirbuddy.plugins.lualine")

local theme = noirbuddy_lualine.theme
-- optional, you can define those yourself if you need
-- local sections = noirbuddy_lualine.sections
local sections = { 
	lualine_a = {'mode'},
  	lualine_b = {},
  	lualine_c = {'filename'},
  	lualine_x = {},
  	lualine_y = {},
  	lualine_z = {}
}
local inactive_sections = noirbuddy_lualine.inactive_sections

lualine.setup {
    options = {
        icons_enabled = true,
        theme = theme,
        filetype = { colored = false },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = sections,
    inactive_sections = inactive_sections,
}

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
    ['<S-CR>'] = map('editor.send_line', {'i', 'n'}),
    ['<C-e>'] = {
      map('editor.send_block', {'i', 'n'}),
      map('editor.send_selection', 'x'),
    },
    ['<CR>'] = map('postwin.toggle'),
    ['<M-CR>'] = map('postwin.toggle', 'i'),
    ['<M-L>'] = map('postwin.clear', {'n', 'i'}),
    ['<C-k>'] = map('signature.show', {'n', 'i'}),
    ['<F12>'] = map('sclang.hard_stop', {'n', 'x', 'i'}),
    ['<leader>st'] = map('sclang.start'),
    ['<leader>sk'] = map('sclang.recompile'),
    ['<F1>'] = map_expr('s.boot'),
    ['<F2>'] = map_expr('s.meter'),
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
    horizontal = false,
    direction = 'right',
    size = nil,
    fixed_size = nil,
    keymaps = nil,
    float = {
      enabled = false,
      row = 0,
      col = function()
        return vim.o.columns
      end,
      width = 64,
      height = 14,
      config = {
        border = 'single',
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

