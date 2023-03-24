local present, mason = pcall(require, "mason")

if not present then
  return
end

local options = {
  ensure_installed = {
    "lua-language-server",
    "terraform-ls",
    "cfn-lint",
    "bash-language-server",
    "stylua",

  }, -- not an option from mason.nvim
}

options = require("core.utils").load_override(options, "williamboman/mason.nvim")

vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
end, {})


mason.setup(options)

