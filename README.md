# kitty-nvim-scnvim
dotfiles

chain: 

- kitty 
	+ nvim
	+ scnvim (sc frontend)
		+ lualine (status polling)
		+ luasnip (snippets)
		+ vim-cmp (auto-completion)

keymaps: 

	shift + return = run line 
	opt + return = run selection/block of code 
	opt + . = sclang hard stop 
	F1 = s.boot
	F2 = s.meter
