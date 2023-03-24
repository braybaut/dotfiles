local present, null_ls = pcall(require, "null-ls")
local null_helpers = require "null-ls.helpers"

if not present then
  return
end

local b = null_ls.builtins

local cfn_lint = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "yaml" },
  generator = null_helpers.generator_factory {
    command = "cfn-lint",
    to_stdin = true,
    to_stderr = true,
    args = { "--format", "parseable", "-" },
    format = "line",
    check_exit_code = function(code)
      return code == 0 or code == 255
    end,
    on_output = function(line, params)
      local row, col, end_row, end_col, code, message = line:match ":(%d+):(%d+):(%d+):(%d+):(.*):(.*)"
      local severity = null_helpers.diagnostics.severities["error"]

      if message == nil then
        return nil
      end

      if vim.startswith(code, "E") then
        severity = null_helpers.diagnostics.severities["error"]
      elseif vim.startswith(code, "W") then
        severity = null_helpers.diagnostics.severities["warning"]
      else
        severity = null_helpers.diagnostics.severities["information"]
      end

      return {
        message = message,
        code = code,
        row = row,
        col = col,
        end_col = end_col,
        end_row = end_row,
        severity = severity,
        source = "cfn-lint",
      }
    end,
  },
}

local sources = {
  b.diagnostics.cfn_lint,
  -- format html and markdown
  b.formatting.prettierd.with { filetypes = { "html", "yaml", "markdown" } },
  -- markdown diagnostic
  b.diagnostics.markdownlint,
  -- Lua formatting
  b.formatting.stylua,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(client, bufnr)
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
        vim.lsp.buf.format { bufnr = bufnr }
      end,
    })
  end
end

null_ls.setup {
  debug = true,
  sources = sources,
  on_attach = on_attach,
}
