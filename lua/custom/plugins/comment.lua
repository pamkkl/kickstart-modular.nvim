return {
  'numToStr/Comment.nvim',
  opts = {
    pre_hook = function(ctx)
      if vim.bo.filetype == 'spice' then
        return '* %s'
      end
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
