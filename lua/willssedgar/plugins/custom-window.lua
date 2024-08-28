local plenary_window = require("plenary.window.float")

local function create_right_window(file_path)
  -- Get the dimensions of the current Neovim window
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.3) -- 30% of the screen width
  local height = 10

  -- Configure the window options
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = 0,
    col = ui.width - width,
    border = "single",
  }

  -- Check if the file exists, create it if it doesn't
  local file_exists = vim.fn.filereadable(file_path) == 1
  if not file_exists then
    local f = io.open(file_path, "w") -- Create an empty file if it does not exist
    if f then
      f:close()
    else
      print("Error: Could not create file " .. file_path)
      return
    end
  end

  -- Search for an existing buffer with the same name
  local bufnr = vim.fn.bufnr(file_path, true)
  local is_new_buffer = bufnr == -1

  if is_new_buffer then
    -- Create a new buffer if it doesn't already exist
    bufnr = vim.api.nvim_create_buf(true, false)
    if bufnr == -1 then
      print("Error: Could not create buffer")
      return
    end
  end -- Set the buffer's name to the file path
  vim.api.nvim_buf_set_option(bufnr, "buftype", "") -- Ensure it's not a special type

  vim.api.nvim_buf_set_name(bufnr, file_path)

  vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
  vim.api.nvim_buf_set_option(bufnr, "buflisted", true)

  -- Read the file and set its content to the buffer
  local lines = {}
  local f = io.open(file_path, "r")
  if f then
    for line in f:lines() do
      table.insert(lines, line)
    end
    f:close()
  else
    table.insert(lines, "# Error")
    table.insert(lines, "# Could not open file " .. file_path)
  end
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  -- Open the floating window with the buffer
  local win_id = vim.api.nvim_open_win(bufnr, true, opts)

  -- Set key mappings
  vim.api.nvim_set_keymap(
    "n",
    "<leader>cp",
    ":lua jump_to_popup(" .. win_id .. ")<CR>",
    { noremap = true, silent = true }
  )
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ce", ":lua jump_to_editor()<CR>", { noremap = true, silent = true })
  -- Automatically save the file without prompt
  vim.cmd("silent write! " .. file_path)
end

function ShowWindow(file_path)
  create_right_window(file_path)
end

function jump_to_popup(win_id)
  vim.api.nvim_set_current_win(win_id)
end

function jump_to_editor()
  local main_win = vim.fn.bufwinid(vim.fn.bufnr("%"))
  if main_win ~= -1 then
    vim.api.nvim_set_current_win(main_win)
  end
end

vim.api.nvim_set_keymap(
  "n",
  "<leader>cn",
  ":lua ShowWindow(vim.fn.input('File path: '))<CR>",
  { noremap = true, silent = true }
)
