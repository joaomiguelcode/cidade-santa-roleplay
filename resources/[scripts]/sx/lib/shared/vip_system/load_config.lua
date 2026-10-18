cityName = GetConvar("cityName", "")

VipSystem = {}

function GetVipSystem()
    local path = "code/shared/vip_system/servers/"..cityName..".lua"
    local file = LoadResourceFile("sx", path)
    if file then
        local func, err = load(file, path, "t", _ENV)
        if func then
            VipSystem = func()
        else
            print("GetVipSystem load error: "..tostring(err))
        end
    else
        print("GetVipSystem: file not found -> "..path)
    end
end

GetVipSystem()