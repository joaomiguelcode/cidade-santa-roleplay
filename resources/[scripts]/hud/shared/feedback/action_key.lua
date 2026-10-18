-- Árbitro de "o que a tecla M faz agora" (ENG-3050 §3.2b). O slot principal só mostra um card por
-- vez e a tecla de ação (M) é compartilhada entre eles — em vez de cada módulo registrar seu
-- próprio `RegisterKeyMapping` (o que faria os dois dispararem juntos), só existe UM bind real
-- (em `quality/nui.lua`), que delega pra quem reivindicou a tecla por último aqui.
---@class FeedbackActionKeyApi
FeedbackActionKey = {}

---@type fun()|nil
local currentHandler = nil

---@param handler fun()
---@return nil
function FeedbackActionKey.Claim( handler )
    currentHandler = handler
end

-- So libera se quem esta chamando ainda e o dono atual -- evita que um `Release` atrasado (ex.:
-- corrida entre esconder e um novo show) apague a reivindicacao de outro card mais recente.
---@param handler fun()
---@return nil
function FeedbackActionKey.Release( handler )
    if currentHandler == handler then
        currentHandler = nil
    end
end

---@return boolean handled
function FeedbackActionKey.Trigger()
    if not currentHandler then
        return false
    end

    currentHandler()
    return true
end
