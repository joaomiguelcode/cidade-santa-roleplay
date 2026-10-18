tooltip = class()

function tooltip:__init()
    self.screenWidth, self.screenHeight = GetActiveScreenResolution()

    local link = ('nui://%s/web/index.html'):format(GetCurrentResourceName())

    self.url = link

    self.dict    = 'tutorial'
    self.texture = 'tooltip'

    self.duiObject  = CreateDui(self.url, self.screenWidth, self.screenHeight)
    self.duihandle  = GetDuiHandle(self.duiObject)
    self.runtimeTxd = CreateRuntimeTxd(self.dict)
    self.txdObject  = CreateRuntimeTextureFromDuiHandle(self.runtimeTxd, self.texture, self.duihandle)
    self.alpha = 255

    self.themeReceived = false

    RequestStreamedTextureDict(self.dict, true)

    repeat Wait(1) until IsDuiAvailable(self.duiObject) and HasStreamedTextureDictLoaded(self.dict)
end

function tooltip:render3DSprite(coords, maxDistance)
    local distance = #(GetEntityCoords(PlayerPedId()) - coords)

    if distance > maxDistance then
        return
    end

    local scale = math.max(0.7, 1.0 / distance)

    scale = math.min(scale, 1.0)

    local isClose = distance < (maxDistance / 1.5)

    if (isClose) then
        self.alpha = math.min(255, self.alpha + 10)
    else
        self.alpha = math.max(-255, self.alpha - 10)
    end

    SetDrawOrigin(coords.x, coords.y, coords.z, false)
    DrawInteractiveSprite(self.dict, self.texture, 0, 0, scale, scale, 0.0, 255, 255, 255, self.alpha)
    ClearDrawOrigin()
end

function tooltip:destroy()
    DestroyDui(self.duiObject)
end

function tooltip:message(data)
    SendDuiMessage(self.duiObject, json.encode(data))
end

function tooltip:setText(data)
    self:message(
        {
            action = 'showTooltip',
            data = data,
        }
    )

    if (self.themeReceived) then
        return
    end

    self:message({
        action = 'getCityName',
        data = cityName
    })

    self:message({
        action = 'getCityId',
        data = cityName
    })

    print('sending theme')

    self.themeReceived = true
end