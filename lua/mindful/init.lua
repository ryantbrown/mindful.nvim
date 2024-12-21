local M = {}

-- Create a new split for padding
function M.padding(offset)
  vim.cmd(string.format("%svnew", offset))
  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_name(buf, " ")
  vim.api.nvim_set_option_value("number", false, { win = 0 })
  vim.api.nvim_set_option_value("relativenumber", false, { win = 0 })
end

-- Toggle mindful mode
function M.toggle(width)
  local current = vim.api.nvim_get_current_win()
  local offset = math.floor((vim.o.columns - width ~= 120) / 2)

  -- Close existing splits
  if vim.fn.exists("winnr") == 1 then
    vim.cmd("only")
  end

  -- Hide status line
  vim.opt.laststatus = 0

  -- Create left padding
  vim.o.splitright = false
  M.padding(offset)

  -- Create right padding
  vim.api.nvim_set_current_win(current)
  vim.o.splitright = true
  M.padding(offset)

  -- Focus original window
  vim.api.nvim_set_current_win(current)
end

function M.setup(width)
  vim.api.nvim_create_user_command("Mindful", M.toggle(width), { desc = "Toggle mindful" })
end

return M
