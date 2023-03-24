local overrides = require "custom.configs.overrides"

local plugins = {

  ["neovim/nvim-lspconfig"] = {
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
    requires = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },
  },
  -- override plugin configs
  ["williamboman/mason.nvim"] = {

    config = function()
      require "plugins.configs.mason"
      require "custom.configs.mason"
    end,
  },
  ["nvim-treesitter/nvim-treesitter"] = {
    config = function()
      require "custom.configs.treesitter"
    end,
  },

  ["nvim-tree/nvim-tree.lua"] = {
    opts = overrides.nvimtree,
  },
  ["hashivim/vim-terraform"] = {},
}

return plugins
