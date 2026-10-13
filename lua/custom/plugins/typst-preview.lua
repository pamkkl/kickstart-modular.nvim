return {
  {
    'chomosuke/typst-preview.nvim',
    lazy = false,
    ft = 'typst',
    version = '1.*',
    opts = {
      -- Use tinymist installed by Mason
      dependencies_bin = { tinymist = 'tinymist' },
      partial_rendering = false,
      -- debug = true,
    },
    keys = {
      { '<leader>tp', '<cmd>TypstPreviewToggle<cr>', desc = 'Toggle Typst preview' },
    },
  },
}
