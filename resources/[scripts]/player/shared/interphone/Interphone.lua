InterphoneCoords = {
    {vector3(1681.6,6429.16,32.18),"Ballas"}
}

if cityName == "Santa" then
    InterphoneCoords = {
        
}
elseif cityName == "CidadeNobre" then
    InterphoneCoords = {     
    {vector3(761.17,-559.92,32.35),"Medusa"}
}
elseif cityName == "Maresia" then
    InterphoneCoords = {     
        
        
}
elseif cityName == "Universo" then
    InterphoneCoords = {     
    
}
end

CreateThread(function()
    local Configs = exports["org_system"]:GetAllOfConfig("INTERPHONE")
    for i=1,#Configs do
        local Config = Configs[i]
        for j=1,#Config do
            table.insert(InterphoneCoords,Config[j])
        end
    end
end)