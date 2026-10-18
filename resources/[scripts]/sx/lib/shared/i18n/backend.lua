sx.i18n.backends = { }

---@class i18n.i18nBackendOptions
---@field loadPath  string

---@class i18n.i18nBackend
---@field options   i18n.i18nBackendOptions
---@field read      fun( self: i18n.i18nBackend, language: string, namespace: string, callback: fun( err: string, data: nil ) | fun( err: nil, data: string ) )

function sx.i18n.backend()
end