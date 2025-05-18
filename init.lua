vim.g.mapleader = " "
vim.g.localleader = " "

vim.o.number = true
vim.o.mouse = "a"
vim.o.showmode = true
vim.o.breakindent = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.o.colorcolumn = "80"
vim.o.wrap = false

-- NOTE: Uncomment to show empty chars
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.more = false
vim.opt.foldmethod = "manual"
vim.opt.title = true
vim.opt.titlestring = '%t%( %M%)%( (%{expand("%:~:h")})%)%a (nvim)'

vim.opt.undofile = true
vim.opt.swapfile = false

vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "jk", "<Esc>", {
  silent = true,
})
vim.keymap.set("i", "kj", "<Esc>", {
  silent = true,
})
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Function to setup the statusline
function _G.statusline()
  local statusline = ""
  statusline = statusline .. " %<%f%m "
  statusline = statusline .. "%="
  statusline = statusline .. " %l:%c/%L "
  statusline = statusline .. " [%{&fileencoding?&fileencoding:&encoding}] "
  statusline = statusline .. " " .. os.date "%Y-%m-%d %I:%M:%S %p" .. " "
  return statusline
end

vim.opt.statusline = "%!v:lua.statusline()"
---@diagnostic disable-next-line: undefined-field
local timer = vim.loop.new_timer()
timer:start(
  1000,
  1000,
  vim.schedule_wrap(function()
    -- Force statusline update
    vim.cmd "redrawstatus"
  end)
)

vim.opt.laststatus = 2

-- Resize buffers when I am using more than 1
vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    vim.cmd "wincmd ="
  end,
})

-- Add this to your init.lua or another config file that gets loaded
vim.keymap.set("n", "<leader>gg", function()
  -- Function to calculate dimensions
  local function get_dimensions()
    local width = math.floor(vim.o.columns * 0.9)
    local height = math.floor(vim.o.lines * 0.9)
    return {
      width = width,
      height = height,
      col = math.floor((vim.o.columns - width) / 2),
      row = math.floor((vim.o.lines - height) / 2),
    }
  end

  -- Create a floating terminal window
  local buf = vim.api.nvim_create_buf(false, true)
  local dim = get_dimensions()

  local opts = {
    relative = "editor",
    width = dim.width,
    height = dim.height,
    col = dim.col,
    row = dim.row,
    style = "minimal",
    border = "rounded",
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  -- Set window-local keymapping for 'q' to close the window
  vim.api.nvim_buf_set_keymap(buf, "t", "q", [[<C-\><C-n>:q<CR>]], { noremap = true, silent = true })

  -- Create an autocommand to handle resizing
  local group = vim.api.nvim_create_augroup("LazyGitResize", { clear = true })
  vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
      -- If window still exists, resize it
      if vim.api.nvim_win_is_valid(win) then
        local new_dim = get_dimensions()
        vim.api.nvim_win_set_config(win, {
          relative = "editor",
          width = new_dim.width,
          height = new_dim.height,
          col = new_dim.col,
          row = new_dim.row,
        })
      else
        -- If window no longer exists, clean up autocmd
        vim.api.nvim_del_augroup_by_name "LazyGitResize"
      end
    end,
  })

  -- Set up autocmd to clean up group when buffer is closed
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function()
      vim.api.nvim_del_augroup_by_name "LazyGitResize"
    end,
  })

  -- Open lazygit using jobstart with term option
  vim.fn.jobstart("lazygit", {
    term = true,
    cwd = vim.fn.getcwd(),
    buffer = buf,
  })

  -- Switch to terminal mode automatically
  vim.cmd "startinsert"
end, { noremap = true, silent = true, desc = "Open lazygit in floating window" })

-- Function to toggle line wrapping
function _G.toggle_wrap()
  local wrap_state = vim.wo.wrap
  vim.wo.wrap = not wrap_state
  print("Wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end

-- Key mapping to toggle wrap (using <Leader>w)
vim.api.nvim_set_keymap("n", "<leader>w", ":lua toggle_wrap()<CR>", { noremap = true, silent = true })

-- Load lazy
require "config.lazy"
