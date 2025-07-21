local AuGroupConfig = {
  PREFIX = "com.cn.",
  DEFAULT_OPTS = {
    clear = true,
  },
}

AuGroupConfig.lsp = {
  name = string.format("%slsp", AuGroupConfig.PREFIX),
  opts = AuGroupConfig.DEFAULT_OPTS,
}

AuGroupConfig.nvim_opts = {
  name = string.format("%sopts", AuGroupConfig.PREFIX),
  opts = AuGroupConfig.DEFAULT_OPTS,
}

return AuGroupConfig
