local M = {}
local active = false

-- Create a padding buffer
local function create_padding(offset, dir)
  local name = " "

  if dir == "left" then
    vim.o.splitright = false
  else
    name = "  "
    vim.o.splitright = true
  end

  vim.cmd(string.format("%svnew", offset))
  local buf = vim.api.nvim_get_current_buf()

  vim.api.nvim_buf_set_name(buf, name)
  vim.api.nvim_set_option_value("number", false, { scope = "local" })
  vim.api.nvim_set_option_value("relativenumber", false, { scope = "local" })
  vim.api.nvim_set_option_value("buftype", "nofile", { scope = "local" })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { scope = "local" })

  return vim.api.nvim_get_current_win()
end

-- Reinitialize the padding buffers
local function check()
  if active and vim.fn.tabpagenr("$") == 1 then
    M.toggle()
    M.toggle()
  end
end

-- Toggle mindful mode
function M.toggle()
  local width = 120
  local current_win = vim.api.nvim_get_current_win()

  -- If already active, reset to the default state
  if active then
    vim.cmd("only")
    vim.opt.laststatus = 2
    active = false
    return
  end

  -- Calculate padding
  local offset = math.floor((vim.o.columns - width) / 2)

  if offset <= 0 then
    vim.notify("Not enough space to center the main window", vim.log.levels.WARN)
    return
  end

  -- Enter mindful mode
  if vim.fn.exists("winnr") == 1 then
    vim.cmd("only")
  end

  vim.opt.laststatus = 0
  create_padding(offset, "left")
  vim.api.nvim_set_current_win(current_win)
  vim.o.splitright = true
  create_padding(offset, "right")
  vim.api.nvim_set_current_win(current_win)

  active = true
end

function M.setup()
  vim.api.nvim_create_user_command("Mindful", M.toggle, { desc = "Toggle mindful mode" })

  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function()
      vim.defer_fn(check, 100) -- Slight delay to allow state to stabilize
    end,
  })
end

return M
