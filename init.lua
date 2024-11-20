vim.wo.number = true
vim.wo.relativenumber = true

-- Set the leader key
vim.g.mapleader = " "

-- Lazy loads all our plugins (see lazy-setup.lua)
require("lazy-setup")
-- Set the colorscheme
-- vim.cmd.colorscheme "catppuccin-mocha"
-- vim.cmd.colorscheme "tokyonight-storm"
-- vim.cmd.colorscheme "tokyonight-night"
-- vim.cmd.colorscheme "tokyonight-moon"
vim.cmd("colorscheme kanagawa")
-- ~/.config/nvim/init.lua
-- This is the startup page plugin


-- Open Nvim Tree
vim.keymap.set('n', '<leader>t', ':NvimTreeFindFileToggle<CR>', {noremap = true, silent = true})

-- Pretty print json
vim.keymap.set('n', '<leader>fj', ':%!jq .<CR>', { noremap = true, silent = true, desc = 'Format JSON' })

-- Open a new line below the current line
vim.api.nvim_set_keymap('n', '<Leader>o', 'mpo<Esc>p', { noremap = true, silent = true })
-- Open a new line above the current line
vim.api.nvim_set_keymap('n', '<Leader>O', 'mpO<Esc>`p', { noremap = true, silent = true })

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
    local file = vim.fn.expand('%')
    local Terminal = require('toggleterm.terminal').Terminal
    local python_term = Terminal:new({
        cmd = "python3 " .. file,
        direction = "float",
        size = 50,
        close_on_exit = false
    })
    python_term:toggle()
end

vim.keymap.set('n', '<leader>r', ':lua run_python_file()<CR>', {noremap = true, silent = true})-- We want to be able to use system clipboard in nvim, both for copy and paste
vim.opt.clipboard = "unnamedplus"


-- Here are our nvim-tree options:
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()


-- THIS IS THE LSP STUFF (FROM LSP 0 GETTING STARTED)
-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end,
})

require('mason').setup({})
require('mason-lspconfig').setup({
  -- Replace the language servers listed here 
  -- with the ones you want to install
  ensure_installed = {'pyright', 'bashls','html','dockerls','jsonls','cssls','yamlls', 'lua_ls'},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})

-- SET UP AUTOCOMPLETE
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({}),
})

-- Run Black on save for Python files
return {
  -- https://github.com/psf/black
  'psf/black',
  ft = 'python',
  config = function()
    -- Automatically format file buffer when saving
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
      pattern = "*.py",
      callback = function()
        vim.cmd("Black")
      end,
    })
  end
}
