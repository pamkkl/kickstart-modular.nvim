-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
-- custom keymaps

-- Yank to system clipboard (normal + visual mode)
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', [["+Y]], { desc = 'Yank line to system clipboard' })

-- Paste from system clipboard (normal mode)
vim.keymap.set('n', '<leader>p', [["+p]], { desc = 'Paste from system clipboard' })
vim.keymap.set('n', '<leader>P', [["+P]], { desc = 'Paste before cursor from system clipboard' })

-- Execute ngspice file (normal mode)
local ngspice = {
  buf = nil,
  win = nil,
  job = nil,
}

local function open_ngspice()
  -- create buffer once
  if not ngspice.buf or not vim.api.nvim_buf_is_valid(ngspice.buf) then
    ngspice.buf = vim.api.nvim_create_buf(false, true)
  end

  local prev_win = vim.api.nvim_get_current_win()

  -- open split if not visible
  if not ngspice.win or not vim.api.nvim_win_is_valid(ngspice.win) then
    vim.cmd 'botright split'
    ngspice.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(ngspice.win, ngspice.buf)

    -- start job only once (IMPORTANT: must happen AFTER term buffer is attached)
    ngspice.job = vim.fn.termopen({ 'ngspice' }, {
      on_exit = function()
        ngspice.job = nil
      end,
    })
  end

  -- enforce 20% height split
  local height = math.floor(vim.o.lines * 0.2)
  vim.api.nvim_win_set_height(ngspice.win, height)

  -- restore focus to code window
  vim.api.nvim_set_current_win(prev_win)
end

vim.keymap.set('n', '<leader>ng', function()
  vim.cmd 'write'
  local file = vim.fn.expand '%:p'

  open_ngspice()

  if ngspice.job then
    vim.fn.chansend(ngspice.job, 'source ' .. file .. '\n')
  end
end, { desc = 'Send file to ngspice (reuse terminal)' })

vim.keymap.set('n', '<leader>nk', function()
  if ngspice.job then
    vim.fn.chansend(ngspice.job, 'quit\n')

    vim.defer_fn(function()
      if ngspice.job then
        vim.fn.jobstop(ngspice.job)
      end
    end, 500)
  end

  if ngspice.win and vim.api.nvim_win_is_valid(ngspice.win) then
    vim.api.nvim_win_close(ngspice.win, true)
  end

  ngspice.win = nil
  ngspice.buf = nil
  ngspice.job = nil
end, { desc = 'Stop ngspice + close terminal' })

-- Delete current buffer
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = '[B]uffer [D]elete' })

-- Next/Prev buffer
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { desc = '[B]uffer [P]revious' })

-- Exit insert mode
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode with jk' })

-- Insert current date
vim.keymap.set('n', '<leader>d', ':r! date "+\\%Y-\\%m-\\%d" <CR>', { desc = '[D]ate' })
-- vim.keymap.set('n', '<leader>tt', ':r! date "+\\%H:\\%M:\\%S" <CR>', { noremap = true })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et
