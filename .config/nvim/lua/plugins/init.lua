-- This file was automatically created by the NvChad system package
-- to ensure NvChad starts correctly without errors.
--
-- You can add your custom lazy.nvim plugin specifications here.
-- For example:
-- return {
--   { "nvim-lua/plenary.nvim" },
--   -- add more plugins here
-- }
--
-- If you have no custom plugins yet, NvChad requires this file to return an empty table.
return {
-- nvim v0.8.0
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
        "LazyGit",
        "LazyGitConfig",
        "LazyGitCurrentFile",
        "LazyGitFilter",
        "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
        { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
}
