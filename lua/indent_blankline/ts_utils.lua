local M = {}

M.get_node_at_cursor = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr)
    if not parser then
        return nil
    end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    local root
    parser:for_each_tree(function(tree)
        local r = tree:root()
        if r and vim.treesitter.is_in_node_range(r, row, col) then
            root = r
        end
    end)
    if not root then
        return nil
    end
    return root:named_descendant_for_range(row, col, row, col)
end

return M
