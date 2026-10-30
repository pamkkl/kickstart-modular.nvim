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

        vim.keymap.set('n', '<localleader>le', '<Cmd>VimtexErrors<CR>', opts)
        vim.keymap.set('n', '<localleader>lk', '<Cmd>VimtexStop<CR>', opts)
        vim.keymap.set('n', '<localleader>lK', '<Cmd>VimtexStop All<CR>', opts)
        vim.keymap.set('n', '<localleader>ll', '<Cmd>VimtexCompile<CR>', opts)
        vim.keymap.set('n', '<localleader>lv', '<Cmd>VimtexView<CR>', opts)
        vim.keymap.set('n', '<localleader>lx', '<Cmd>VimtexReload<CR>', opts)
      end,
    })
  end,
}
