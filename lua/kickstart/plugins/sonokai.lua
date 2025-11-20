return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'sainnhe/sonokai',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      vim.g.sonokai_style = 'shusia' -- or 'default', 'atlantis', 'shusia', 'maia', 'espresso'
      vim.g.sonokai_better_performance = 1
      vim.g.sonokai_enable_italic = 0
      -- Load the colorscheme here.
      vim.cmd.colorscheme 'sonokai'
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
