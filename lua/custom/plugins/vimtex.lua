return {
  'lervag/vimtex',
  lazy = false,

  init = function()
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_mappings_enabled = 0
  end,

  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'tex',
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }

        vim.keymap.set('n', '<localleader>le', '<Cmd>Errors<CR>', opts)
        vim.keymap.set('n', '<localleader>lk', '<Cmd>Stop<CR>', opts)
        vim.keymap.set('n', '<localleader>lK', '<Cmd>Stop All<CR>', opts)
        vim.keymap.set('n', '<localleader>ll', '<Cmd>Compile<CR>', opts)
        vim.keymap.set('n', '<localleader>lv', '<Cmd>View<CR>', opts)
        vim.keymap.set('n', '<localleader>lx', '<Cmd>Reload<CR>', opts)
      end,
    })
  end,
}
