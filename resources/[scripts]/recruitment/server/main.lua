-----------------------------------------------------------------------------------------------------------------------------------------
-- RECRUITMENT (SERVER)
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Creative = {}
Tunnel.bindInterface("recruitment", Creative)
vCLIENT = Tunnel.getInterface("recruitment")

local recruitments = {}

function Creative.OpenRecruitment()
    local source = source
    local Passport = vRP.Passport(source)
    return {
        maxDuration = 360,
        myOrg = "Nenhuma",
        restart = true,
        leader = true,
        admin = vRP.HasPermission(Passport, "Admin"),
        data = recruitments,
        time = os.time()
    }
end

function Creative.CreateRecruitment(data)
    local source = source
    local Passport = vRP.Passport(source)
    return Creative.OpenRecruitment()
end

function Creative.UpdateTime()
    return Creative.OpenRecruitment()
end

function Creative.MarkGroupCoords(data)
end

function Creative.RemoveRecruitMent(data)
    return Creative.OpenRecruitment()
end
