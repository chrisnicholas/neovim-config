local M = {}

function M.get_client_encoding(client)
  return client.offset_encoding
      or (client.server_capabilities and client.server_capabilities.offsetEncoding)
      or "utf-16"
end

function M.get_client_range_params(client)
  return vim.lsp.util.make_range_params(0, M.get_client_encoding(client))
end

return M
