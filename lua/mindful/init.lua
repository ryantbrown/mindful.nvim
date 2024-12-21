local M = {}

function M.padding(offset, name)
  vim.cmd(string.format("%svnew", offset))
  local pad = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_name(pad, name)
  vim.api.nvim_set_option_value("number", false, { win = 0 })
  vim.api.nvim_set_option_value("relativenumber", false, { win = 0 })
end

function M.toggle()
  local width = 120
  local current = vim.api.nvim_get_current_win()
  local offset = math.floor((vim.o.columns - width) / 2)

  if vim.fn.exists("winnr") == 1 then
    vim.cmd("only")
  end

  vim.opt.laststatus = 0
  vim.o.splitright = false
  M.padding(offset, " ")
  vim.api.nvim_set_current_win(current)
  vim.o.splitright = true
  M.padding(offset, "  ")
  vim.api.nvim_set_current_win(current)
end

function M.setup()
  vim.api.nvim_create_user_command("Mindful", M.toggle, { desc = "Toggle mindful" })
end

return M
