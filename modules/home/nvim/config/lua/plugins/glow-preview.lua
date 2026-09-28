local M = {}

local preview_buf = nil
local preview_win = nil

function M.toggle()
    if preview_buf and vim.api.nvim_buf_is_valid(preview_buf) then
        M.close()
    else
        M.open()
    end
end

function M.open()
    if vim.fn.executable('glow') == 0 then
        vim.notify("glow not found. Install with: nix-shell -p glow", vim.log.levels.ERROR)
        return
    end

    local filename = vim.fn.expand('%:p')
    if filename == '' then
        vim.notify("No file to preview", vim.log.levels.WARN)
        return
    end

    -- Create vertical split
    vim.cmd('vsplit')
    preview_win = vim.api.nvim_get_current_win()
    preview_buf = vim.api.nvim_create_buf(false, true)

    -- Configure preview buffer
    vim.api.nvim_win_set_buf(preview_win, preview_buf)
    vim.api.nvim_buf_set_name(preview_buf, 'glow-preview')
    vim.api.nvim_buf_set_option(preview_buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(preview_buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(preview_buf, 'swapfile', false)

    -- Render markdown with glow
    vim.fn.termopen('glow -p ' .. vim.fn.shellescape(filename))
    vim.cmd('startinsert')

    -- Return to original file
    vim.cmd('wincmd p')
end

function M.close()
    if preview_win and vim.api.nvim_win_is_valid(preview_win) then
        vim.api.nvim_win_close(preview_win, true)
    end
    preview_buf = nil
    preview_win = nil
end

function M.update()
    if not preview_buf or not vim.api.nvim_buf_is_valid(preview_buf) then
        return
    end

    local filename = vim.fn.expand('%:p')
    if filename == '' then return end

    -- Save current window
    local curr_win = vim.api.nvim_get_current_win()

    -- Switch to preview and update
    vim.api.nvim_set_current_win(preview_win)
    vim.api.nvim_buf_set_lines(preview_buf, 0, -1, false, {})
    vim.fn.termopen('glow -p ' .. vim.fn.shellescape(filename))

    -- Return to original window
    vim.api.nvim_set_current_win(curr_win)
end

return M
