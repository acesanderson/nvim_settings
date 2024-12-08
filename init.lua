vim.wo.number = true
vim.wo.relativenumber = true

-- Set the leader key
vim.g.mapleader = " "
vim.opt.conceallevel = 1

vim.g.rocks = {
	enabled = false, -- This disables luarocks support completely
}

-- Lazy loads all our plugins (see lazy-setup.lua)
require("lazy-setup")

-- Specific background if you want to set it
vim.o.background = "dark"
-- vim.o.background = "light"

-- Set the colorscheme
-- vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd.colorscheme "catppuccin-latte"
-- vim.cmd.colorscheme "catppuccin-frappe"
-- vim.cmd.colorscheme("catppuccin-macchiato")
-- vim.cmd.colorscheme "catppuccin-mocha"
-- vim.cmd.colorscheme "tokyonight-storm"
-- vim.cmd.colorscheme("tokyonight-night")
-- vim.cmd.colorscheme("tokyonight-moon")
vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme gruvbox")
-- vim.cmd("colorscheme nightfox")
-- vim.cmd("colorscheme dayfox")
-- vim.cmd("colorscheme dawnfox")
-- vim.cmd("colorscheme duskfox")
-- vim.cmd("colorscheme nordfox")
-- vim.cmd("colorscheme terafox")
-- vim.cmd("colorscheme carbonfox")
-- vim.cmd("colorscheme sonokai")
-- vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme rose-pine-dawn")
-- vim.cmd("colorscheme rose-pine-moon")
-- vim.cmd("colorscheme doom-one")
-- vim.cmd("colorscheme oxocarbon")
-- vim.cmd("colorscheme apprentice")
-- vim.cmd("colorscheme dracula")
-- vim.cmd("colorscheme papercolor")
-- vim.cmd("colorscheme monokai")
-- vim.cmd("colorscheme oceanicnext")
-- vim.cmd("colorscheme solarized")

-- Open Nvim Tree
vim.keymap.set("n", "<leader>t", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })

-- Pretty print json
vim.keymap.set("n", "<leader>fj", ":%!jq .<CR>", { noremap = true, silent = true, desc = "Format JSON" })

-- Open a new line below the current line
vim.api.nvim_set_keymap("n", "<Leader>o", "mpo<Esc>p", { noremap = true, silent = true })
-- Open a new line above the current line
vim.api.nvim_set_keymap("n", "<Leader>O", "mpO<Esc>`p", { noremap = true, silent = true })

-- Create abbreviation for substitute command
-- This allows us to effectively use "very magic" (i.e. perlesque regex) in find/replace in command mode
vim.cmd([[
  cabbrev %s/ %s/\v
  cabbrev %s? %s?\v
  cabbrev s/ s/\v
  cabbrev s? s?\v
]])

-- Shortcut to run Python files -- this is a simple way to run Python files in a floating terminal
-- We have toggleterm installed, so you likely will more often want to use <ctrl>+\ to open a terminal instead
function _G.run_python_file()
	local file = vim.fn.expand("%")
	local Terminal = require("toggleterm.terminal").Terminal
	local python_term = Terminal:new({
		cmd = "python3 " .. file,
		direction = "float",
		size = 50,
		close_on_exit = false,
	})
	python_term:toggle()
end

vim.keymap.set("n", "<leader>r", ":lua run_python_file()<CR>", { noremap = true, silent = true }) -- We want to be able to use system clipboard in nvim, both for copy and paste
vim.opt.clipboard = "unnamedplus"

-- Stylua: Lua formatter
-- Format with shortcut <leader>st
vim.keymap.set("n", "<leader>st", function()
	vim.fn.system("stylua " .. vim.fn.expand("%"))
	vim.cmd("e!") -- reload the file
end)
-- Auto-format on save for lua files
vim.api.nvim_create_autocmd("BufWritePost", { -- Changed from BufWritePre to BufWritePost
	pattern = "*.lua",
	callback = function()
		vim.fn.system("stylua " .. vim.fn.expand("%"))
		vim.cmd("e!") -- reload the file
	end,
})

vim.opt.termguicolors = true
require("bufferline").setup({})
