class = function(base)
    local cls = {}
    cls.__index = cls
    cls.__base = base
    setmetatable(
        cls,
        {
            __call = function(_, ...)
                local instance = setmetatable({}, cls)
                if cls.__init then
                    cls.__init(instance, ...)
                end
                return instance
            end,
            __index = base
        }
    )
    return cls
end

local scope = IsDuplicityVersion()

if (scope) then
else
    cityName = GetConvar('cityName', '')

    RegisterNUICallback(
        'getCityName',
        function(Data, Callback)
            print('cityName', cityName)

            Callback(cityName)
        end
    )

    RegisterNUICallback(
        'getCityId',
        function(Data, Callback)
            print('cityName', cityName)

            Callback(cityName or '')
        end
    )

    RegisterNUICallback(
        'getServerHost',
        function(Data, Callback)
            local api_url = GetConvar('api_url', '')
            print('[DEBUG] - GET SERVER HOST, api_url: ' .. api_url)
            Callback(api_url)
        end
    )
end
