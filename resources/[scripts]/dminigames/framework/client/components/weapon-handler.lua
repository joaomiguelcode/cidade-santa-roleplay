---Sistema genérico de gerenciamento de armas
---Gerencia equipar, holster e lifecycle de armas no cliente
---@class WeaponHandler

-- ✅ DEBUG: Verifica se class() está disponível
if not class then
    error('[WeaponHandler] ERRO CRÍTICO: função class() não está disponível!')
end

WeaponHandler = class()

---Inicializa o handler de armas
---@param minigameName? string Nome do minigame (para logs)
function WeaponHandler:__init(minigameName)
    self.minigameName = minigameName or 'Weapon'
    self.currentWeapon = nil
    self.thread = nil
    self.threadId = 0
end

---Equipa arma com sistema de holster automático
---@param weaponHash string Hash da arma (ex: 'WEAPON_KARAMBIT')
---@param ammo number Quantidade de munição
---@param options? table Opções: { holsterKey: number, onStop: function, checkCondition: function }
---@return number threadId ID da thread criada
function WeaponHandler:equipWithHolster(weaponHash, ammo, options)
    options = options or {}
    local holsterKey = options.holsterKey or 157 -- Tecla 1 por padrão
    
    -- Para arma anterior se existir
    self:stopCurrent()
    
    local ped = PlayerPedId()
    local weaponHashValue = GetHashKey(weaponHash)
    
    -- Dá a arma ao jogador
    GiveWeaponToPed(ped, weaponHashValue, ammo, true, false)
    
    -- Cria ID único para esta thread
    self.threadId = self.threadId + 1
    local myThreadId = self.threadId
    
    self.currentWeapon = {
        id = myThreadId,
        hash = weaponHash,
        hashValue = weaponHashValue,
        active = true
    }
    
    -- Thread de holster
    self.thread = CreateThread(function()
        while self.currentWeapon and self.currentWeapon.id == myThreadId and self.currentWeapon.active do
            local ped = PlayerPedId()
            
            -- Verifica se ainda tem a arma
            if not HasPedGotWeapon(ped, weaponHashValue, false) then
                break
            end
            
            -- Verifica condição customizada (ex: isInMatch, isGhostMode)
            if options.checkCondition and not options.checkCondition() then
                break
            end
            
            -- Detecta pressionar da tecla de holster
            if IsDisabledControlJustPressed(0, holsterKey) then
                local currentWeapon = GetSelectedPedWeapon(ped)
                
                if currentWeapon == weaponHashValue then
                    -- Arma equipada → Guarda
                    SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
                else
                    -- Arma guardada → Saca
                    SetCurrentPedWeapon(ped, weaponHashValue, true)
                end
            end
            
            Wait(1)
        end
        
        -- Callback ao parar
        if options.onStop then
            options.onStop()
        end
        
        -- Limpa se ainda for a thread atual
        if self.currentWeapon and self.currentWeapon.id == myThreadId then
            self.currentWeapon = nil
            self.thread = nil
        end
    end)
    
    return myThreadId
end

---Equipa arma sem sistema de holster
---@param weaponHash string Hash da arma
---@param ammo number Munição
---@param equipNow? boolean Se deve equipar imediatamente (padrão: true)
function WeaponHandler:equip(weaponHash, ammo, equipNow)
    self:stopCurrent()
    
    local ped = PlayerPedId()
    local weaponHashValue = GetHashKey(weaponHash)
    
    if equipNow == nil then equipNow = true end
    
    GiveWeaponToPed(ped, weaponHashValue, ammo, equipNow, false)
    
    self.currentWeapon = {
        hash = weaponHash,
        hashValue = weaponHashValue,
        active = true
    }
end

---Para a arma atual e remove do jogador
---@param removeWeapon? boolean Se deve remover a arma (padrão: true)
function WeaponHandler:stopCurrent(removeWeapon)
    if removeWeapon == nil then removeWeapon = true end
    
    if self.currentWeapon then
        self.currentWeapon.active = false
        self.currentWeapon = nil
        self.thread = nil
    end
    
    if removeWeapon then
        local ped = PlayerPedId()
        RemoveAllPedWeapons(ped, true)
    end
end

---Verifica se há uma arma ativa
---@return boolean hasWeapon
function WeaponHandler:hasActiveWeapon()
    return self.currentWeapon ~= nil and self.currentWeapon.active
end

---Retorna informações da arma atual
---@return table? weaponInfo Informações da arma ou nil
function WeaponHandler:getCurrentWeapon()
    return self.currentWeapon
end

---Remove TODAS as armas do jogador (método estático)
---@param source? number Source do jogador (servidor) ou nil (cliente)
function WeaponHandler.removeAllWeapons(source)
    if source then
        -- Servidor: remove armas de um jogador específico
        RemoveAllPedWeapons(GetPlayerPed(source), true)
    else
        -- Cliente: remove armas do jogador local
        RemoveAllPedWeapons(PlayerPedId(), true)
    end
end
