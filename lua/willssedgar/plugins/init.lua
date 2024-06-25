return {
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use
  "christoomey/vim-tmux-navigator", -- tmux & split window navigation
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<alt-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
    { "<alt-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
    { "<alt-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
    { "<alt-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
    { "<alt-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
  },
}
