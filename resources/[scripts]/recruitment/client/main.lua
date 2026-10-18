-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module("vrp","lib/Tunnel")
Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("recruitment",Creative)
vSERVER = Tunnel.getInterface("recruitment")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
local data = {
    maxDuration = 360,
    myOrg = "batatao",
    restart = true,
    leader = true,
    dataArray = {
        {
            owner = false,
            duration = 600,
            type = "legal",
            image = "https://s3-screenshots.int-cdn.lcpdfrusercontent.com/monthly_2020_10/1795910806_Image2.png.3e2f584afb55ee506e7c1d0c5b1b724d.png",
            name = "Desenvolvedor de Software",
            segment = "Favela",
            description = "Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups."
        },
        {
            owner = true,
            duration = 600,
            type = "legal",
            image = "https://s3-screenshots.int-cdn.lcpdfrusercontent.com/monthly_2020_10/1795910806_Image2.png.3e2f584afb55ee506e7c1d0c5b1b724d.png",
            name = "batatao",
            segment = "Favela",
            description = "Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups."
        },
        {
            owner = true,
            duration = 600,
            type = "ilegal",
            image = "https://s3-screenshots.int-cdn.lcpdfrusercontent.com/monthly_2020_10/1795910806_Image2.png.3e2f584afb55ee506e7c1d0c5b1b724d.png",
            name = "batatao",
            segment = "Favela",
            description = "Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups. Desenvolvimento de software para empresas e startups."
        },
    }
}

function GetAliasByGroup(group)
    local Table = GlobalState["AliasGroup"]
    for Group,Alias in pairs(Table) do
        if Group == group then
            return Alias
        end
    end
    return group
end

RegisterCommandLocalized("command.recruitment", function()
    if (LocalPlayer["state"]["minigame:active"]) then
        return
    end
    local Data = vSERVER.OpenRecruitment()
    local myOrg = GetGroupByAlias(Data.myOrg)
    for i=1,#Data.data do
        local orgName = GetGroupByAlias(Data.data[i]["name"])
        local orgAlias = GetAliasByGroup(orgName)
        Data.data[i]["duration"] = Data.data[i]["time"] - Data.time
        Data.data[i]["type"] = Data.data[i]["type"]:lower()
        Data.data[i]["owner"] = false
        Data.data[i]["image"] = Data.data[i]["url"]
        Data.data[i]["url"] = nil
        Data.data[i]["time"] = nil
        Data.data[i]["name"] = orgAlias
        if myOrg == orgName then
            Data.data[i]["owner"] = true
        end
    end 
    table.sort(Data.data, function(a,b) return a.duration > b.duration end)
    local myOrgAlias = GetAliasByGroup(myOrg)
    local Info = {
        maxDuration = Data.maxDuration,
        myOrg = myOrgAlias,
        restart = Data.restart,
        leader = Data.leader,
        admin = Data.admin,
        dataArray = Data.data
    }
    SendNUIMessage({ action = "Open", data = Info })    
    SetNuiFocus(true, true)
end)

RegisterNuiCallback("SendEvent", function(data, cb)
    print("SendEvent: ",json.encode(data))
    local Data = vSERVER.CreateRecruitment(data)
    local myOrg = GetGroupByAlias(Data.myOrg)
    for i=1,#Data.data do
        local orgName = GetGroupByAlias(Data.data[i]["name"])
        local orgAlias = GetAliasByGroup(orgName)
        Data.data[i]["duration"] = Data.data[i]["time"] - Data.time
        Data.data[i]["type"] = Data.data[i]["type"]:lower()
        Data.data[i]["owner"] = false
        Data.data[i]["image"] = Data.data[i]["url"]
        Data.data[i]["url"] = nil
        Data.data[i]["time"] = nil
        Data.data[i]["name"] = orgAlias
        if myOrg == orgName then
            Data.data[i]["owner"] = true
        end
    end 
    table.sort(Data.data, function(a,b) return a.duration > b.duration end)
    local Info = {
        maxDuration = Data.maxDuration,
        myOrg = myOrg,
        restart = Data.restart,
        leader = Data.leader,
        admin = Data.admin,
        dataArray = Data.data
    }
    cb(Info)
end)

RegisterNuiCallback("UpdateHours", function(data, cb)
    local Data = vSERVER.UpdateTime()
    local myOrg = GetGroupByAlias(Data.myOrg)
    for i=1,#Data.data do
        local orgName = GetGroupByAlias(Data.data[i]["name"])
        local orgAlias = GetAliasByGroup(orgName)
        Data.data[i]["duration"] = Data.data[i]["time"] - Data.time
        Data.data[i]["type"] = Data.data[i]["type"]:lower()
        Data.data[i]["owner"] = false
        Data.data[i]["image"] = Data.data[i]["url"]
        Data.data[i]["url"] = nil
        Data.data[i]["time"] = nil
        Data.data[i]["name"] = orgAlias
        if myOrg == orgName then
            Data.data[i]["owner"] = true
        end
    end
    table.sort(Data.data, function(a,b) return a.duration > b.duration end)
    local Info = {
        maxDuration = Data.maxDuration,
        myOrg = myOrg,
        restart = Data.restart,
        leader = Data.leader,
        admin = Data.admin,
        dataArray = Data.data
    }
    cb(Info)
end)

RegisterNuiCallback("MarkLocation", function(data, cb)
    vSERVER.MarkGroupCoords(data)
    print("MarkLocation: ",json.encode(data))
    SendNUIMessage({ action = "setVisible", data = false })
    SetNuiFocus(false, false)
    cb({})
end)

RegisterNuiCallback("DeleteEvent", function(data, cb)
    local Info = vSERVER.RemoveRecruitMent(data)
    cb(Info)
end)

RegisterNuiCallback("CallOrganization", function(data, cb)
    print(data)
    exports.smartphone:callPlayer(data)
    cb({})
end)

RegisterNuiCallback("hide", function(data, cb)
    SetNuiFocus(false, false)
    cb({})
end)

RegisterNUICallback( 'getCityId', function( Data, Callback )

    local cityName = GetConvar( 'cityName', '' )
    
    Callback( string.lower( cityName ) )
end)

RegisterNUICallback( 'getCityName', function( Data, Callback )

    local cityName = GetConvar( 'cityName', '' )

    Callback( string.lower( cityName ) )
end)