---Utils exclusivos do servidor (vRP, DB, etc.).
---Early return se não for server; abaixo ficam todas as funções server.

if scope ~= 'server' then return end

---Retorna o nome do jogador a partir do userId (vRP).
---@param userId number|nil ID do usuário (profile_id)
---@return string Nome completo ou fallback "Jogador" / "Jogador &lt;id&gt;"
function utils.getPlayerNameByUserId(userId)
    if not userId then return 'Jogador' end
    if vRP and vRP.Identity then
        local identity = vRP.Identity(userId)
        if identity and identity.name and identity.name2 then
            return (identity.name or '') .. ' ' .. (identity.name2 or '')
        end
    end
    return 'Jogador ' .. tostring(userId)
end
