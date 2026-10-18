---Sistema de gerenciamento de traduções para minigames
---Permite que cada minigame registre suas próprias traduções de forma organizada
---@class TranslationManager
TranslationManager = class()

---Armazena todas as traduções registradas [namespace][locale][key] = value
---@type table<string, table<string, table<string, string>>>
TranslationManager.registeredTranslations = {}

---Locale padrão do sistema
---@type string
TranslationManager.defaultLocale = 'pt-br'

---Locale atual do jogador
---@type string?
TranslationManager.currentLocale = nil

---No client: locale capturado ao carregar o script (mesmo contexto do init.lua), para não depender da global lang no momento do .get()
---@type string?
TranslationManager._clientLocale = nil

---Flag para verificar se o locale já foi inicializado
---@type boolean
TranslationManager.initialized = false

---Inicializa o TranslationManager
---@return TranslationManager
function TranslationManager:__init()
    -- Instância singleton não necessária, usa métodos estáticos
    return self
end

---Registra traduções para um namespace (minigame)
---@param namespace string Namespace único (ex: 'murder', 'ffa', 'racing')
---@param translations table<string, table<string, string>> Traduções por locale
---@return boolean success
function TranslationManager.register(namespace, translations)
    if not namespace or type(namespace) ~= 'string' then
        -- print('[TranslationManager] Erro: namespace inválido')
        return false
    end

    if not translations or type(translations) ~= 'table' then
        -- print('[TranslationManager] Erro: translations deve ser uma tabela')
        return false
    end

    -- Valida estrutura das traduções
    for locale, keys in pairs(translations) do
        if type(locale) ~= 'string' or type(keys) ~= 'table' then
            -- print(('[TranslationManager] Erro: estrutura inválida no locale %s'):format(locale))
            return false
        end
    end

    TranslationManager.registeredTranslations[namespace] = translations
    return true
end

---Remove traduções de um namespace
---@param namespace string Namespace a ser removido
---@return boolean success
function TranslationManager.unregister(namespace)
    if TranslationManager.registeredTranslations[namespace] then
        TranslationManager.registeredTranslations[namespace] = nil
        return true
    end
    return false
end

---Lê o locale do convar (server e client; no client o setr já replica).
---@return string
function TranslationManager.detectLocale()
    return GetConvar('language', 'pt-br') or 'pt-br'
end

---Inicializa o TranslationManager (detecta e define o locale automaticamente)
---Chamado automaticamente uma vez no client
---@return string locale O locale detectado
function TranslationManager.initialize()
    if TranslationManager.initialized then
        return TranslationManager.getLocale()
    end

    local locale = TranslationManager.detectLocale()
    -- print('locale: ' .. locale)
    TranslationManager.setLocale(locale)
    TranslationManager.initialized = true

    return locale
end

---Define o locale atual manualmente
---@param locale string Código do idioma (ex: 'pt-br', 'en-us', 'es-es', 'pt-pt')
---@return boolean success
function TranslationManager.setLocale(locale)
    if type(locale) ~= 'string' then
        return false
    end

    TranslationManager.currentLocale = locale
    TranslationManager.initialized = true
    return true
end

---Obtém o locale atual (com fallback para o padrão).
---No client usa o valor capturado ao carregar (init.lua já rodou); no momento do .get() a global lang pode não estar visível (sandbox).
---@return string
function TranslationManager.getLocale()
    if not IsDuplicityVersion() then
        if TranslationManager._clientLocale then
            return TranslationManager._clientLocale
        end
        local fromLang = (type(lang) == 'string' and #lang > 0) and lang or nil
        local fromConvar = GetConvar('language', 'pt-br') or 'pt-br'
        local locale = fromLang or fromConvar
        TranslationManager._clientLocale = locale
        return locale
    end
    if not TranslationManager.initialized then
        TranslationManager.initialize()
    end
    return TranslationManager.currentLocale or TranslationManager.defaultLocale
end

---Obtém uma tradução
---@param namespace string Namespace (minigame)
---@param key string Chave da tradução
---@param ... any Parâmetros para string.format (opcional)
---@return string
function TranslationManager.get(namespace, key, ...)
    if not namespace or not key then
        return key or ''
    end

    local locale = TranslationManager.getLocale()
    local namespaceTranslations = TranslationManager.registeredTranslations[namespace]

    if not namespaceTranslations then
        -- print(('[TranslationManager] Aviso: namespace "%s" não registrado'):format(namespace))
        return key
    end

    -- Tenta obter tradução no locale atual
    local translation = namespaceTranslations[locale] and namespaceTranslations[locale][key]

    -- O Match Social usa inglês para idiomas ainda não traduzidos.
    local fallbackLocale = namespace == 'neighbor' and 'en-us' or TranslationManager.defaultLocale
    if not translation and locale ~= fallbackLocale then
        translation = namespaceTranslations[fallbackLocale]
            and namespaceTranslations[fallbackLocale][key]
    end

    -- Se ainda não encontrou, retorna a chave
    if not translation then
        return key
    end

    -- Se há parâmetros, aplica string.format
    local args = { ... }
    if #args > 0 then
        local success, result = pcall(string.format, translation, ...)
        if success then
            return result
        else
            -- print(('[TranslationManager] Erro ao formatar tradução: %s'):format(result))
            return translation
        end
    end

    return translation
end

---Alias curto para get() - tradução rápida
---@param namespace string Namespace (minigame)
---@param key string Chave da tradução
---@param ... any Parâmetros para string.format (opcional)
---@return string
function TranslationManager.t(namespace, key, ...)
    return TranslationManager.get(namespace, key, ...)
end

---Verifica se uma chave de tradução existe
---@param namespace string Namespace (minigame)
---@param key string Chave da tradução
---@param locale? string Locale específico (opcional, usa o atual se não fornecido)
---@return boolean
function TranslationManager.exists(namespace, key, locale)
    locale = locale or TranslationManager.getLocale()

    local namespaceTranslations = TranslationManager.registeredTranslations[namespace]
    if not namespaceTranslations then
        return false
    end

    return namespaceTranslations[locale] and namespaceTranslations[locale][key] ~= nil
end

---Obtém todas as traduções de um namespace
---@param namespace string Namespace (minigame)
---@param locale? string Locale específico (opcional, usa o atual se não fornecido)
---@return table<string, string>
function TranslationManager.getAll(namespace, locale)
    locale = locale or TranslationManager.getLocale()

    local namespaceTranslations = TranslationManager.registeredTranslations[namespace]
    if not namespaceTranslations or not namespaceTranslations[locale] then
        return {}
    end

    return namespaceTranslations[locale]
end

---Obtém todos os locales disponíveis para um namespace
---@param namespace string Namespace (minigame)
---@return string[]
function TranslationManager.getAvailableLocales(namespace)
    local namespaceTranslations = TranslationManager.registeredTranslations[namespace]
    if not namespaceTranslations then
        return {}
    end

    local locales = {}
    for locale, _ in pairs(namespaceTranslations) do
        table.insert(locales, locale)
    end

    return locales
end

---Obtém estatísticas de um namespace
---@param namespace string Namespace (minigame)
---@return table
function TranslationManager.getStats(namespace)
    local namespaceTranslations = TranslationManager.registeredTranslations[namespace]
    if not namespaceTranslations then
        return {
            exists = false
        }
    end

    local stats = {
        exists = true,
        locales = {},
        totalKeys = 0
    }

    for locale, keys in pairs(namespaceTranslations) do
        local keyCount = 0
        for _ in pairs(keys) do
            keyCount = keyCount + 1
        end

        stats.locales[locale] = keyCount

        if keyCount > stats.totalKeys then
            stats.totalKeys = keyCount
        end
    end

    return stats
end

---Debug: Lista todos os namespaces registrados
---@return string[]
function TranslationManager.listNamespaces()
    local namespaces = {}
    for namespace, _ in pairs(TranslationManager.registeredTranslations) do
        table.insert(namespaces, namespace)
    end
    return namespaces
end

-- ============================================
-- AUTO-INICIALIZAÇÃO
-- ============================================
if IsDuplicityVersion() then
    TranslationManager.initialize()
else
    -- Client: captura o locale ao carregar (mesmo contexto que init.lua), para getLocale() não depender de lang no momento do .get()
    TranslationManager._clientLocale = (type(lang) == 'string' and #lang > 0) and lang or (GetConvar('language', 'pt-br') or 'pt-br')
end

---Cria uma classe de traduções para um namespace específico
---Retorna uma tabela com métodos helper que encapsulam o namespace
---@param namespace string Namespace único (ex: 'murder', 'ffa')
---@param translations table<string, table<string, string>> Traduções por locale
---@return table TranslationsClass Classe com métodos helper
function TranslationManager.createTranslationClass(namespace, translations)
    -- Registra as traduções
    if not TranslationManager.register(namespace, translations) then
        error(('[TranslationManager] Falha ao registrar traduções para namespace "%s"'):format(namespace))
    end

    -- Cria classe wrapper
    local TranslationClass = {
        namespace = namespace
    }

    ---Obtém uma tradução
    ---@param key string Chave da tradução
    ---@param ... any Parâmetros para string.format (opcional)
    ---@return string
    function TranslationClass.get(key, ...)
        return TranslationManager.get(namespace, key, ...)
    end

    ---Alias curto para get()
    ---@param key string Chave da tradução
    ---@param ... any Parâmetros para string.format (opcional)
    ---@return string
    function TranslationClass.t(key, ...)
        return TranslationClass.get(key, ...)
    end

    ---Verifica se uma chave de tradução existe
    ---@param key string Chave da tradução
    ---@return boolean
    function TranslationClass.exists(key)
        return TranslationManager.exists(namespace, key)
    end

    ---Obtém todas as traduções
    ---@param locale? string Código do idioma (opcional, usa o atual se não fornecido)
    ---@return table<string, string>
    function TranslationClass.getAll(locale)
        return TranslationManager.getAll(namespace, locale)
    end

    return TranslationClass
end
