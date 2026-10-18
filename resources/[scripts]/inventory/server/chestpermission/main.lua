-----------------------------------------------------------------------------------------------------------------------------------------
-- CHEST PERMISSION (SERVER)
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")

local Creative = {}
Tunnel.bindInterface("inventory/chestpermission", Creative)

local permissionsData = {}

function Creative.RequestConfig(Mode, optionsCached)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return { ok = false } end

    return {
        ok = true,
        mode = Mode or "role",
        target = { id = "1", name = "Lider", label = "Líder" },
        options = {
            { id = "1", name = "Lider", label = "Líder" },
            { id = "2", name = "Membro", label = "Membro" }
        },
        showSaleCommission = true,
        saleCommissionPercentage = 10,
        authorizedToWithdraw = true,
        authorizedToConfigureChest = true,
        limitsActive = false,
        limits = {}
    }
end

function Creative.SetMode(Mode)
    return { ok = true }
end

function Creative.SelectTarget(Mode, TargetId)
    return { ok = true }
end

function Creative.SetTarget(Mode, TargetId)
    return { ok = true }
end

function Creative.SetWithdrawAuthorization(Mode, TargetId, Authorized)
    return { ok = true }
end

function Creative.SetConfigureAuthorization(Mode, TargetId, Authorized)
    return { ok = true }
end

function Creative.SetSaleCommission(Mode, TargetId, Percentage)
    return { ok = true }
end

function Creative.RequestAuthorizedList(Mode, TargetId)
    return { items = {} }
end

function Creative.RemoveAuthorizedTarget(Mode, TargetId)
    return { ok = true }
end

function Creative.Save(Mode, TargetId, Config)
    return { ok = true }
end

function Creative.Close(IsEsc)
    return { ok = true }
end
