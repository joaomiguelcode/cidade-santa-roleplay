PromotionCountdown = 0
PromotionTimerStatus = true
PromotionFirstOpen = false
RegisterNetEvent("startPromotionSystem")
AddEventHandler("startPromotionSystem",function(productId,countDown)
    print("startPromotionSystem >>", json.encode(productId), json.encode(countDown))
    local promotion = GetPromotionByProductId(productId)
    print(json.encode(promotion))
    if promotion then
        PromotionCountdown = countDown
        PromotionTimerStatus = true
        PromotionFirstOpen = true
        LocalPlayer["state"]:set("playerPromotion",productId,false)

        local micTutorialActive = gStateMicTutorialStarted or gMicSetupStarted

        if not micTutorialActive then
            SendNUIMessage({
                action = "startPromotionModal",
                data =  {
                    productId = productId,
                    image = promotion.background,
                    background = promotion.background,
                    background_color = promotion.background_color,
                    countDown = PromotionCountdown,
                    itens = promotion.itens,
                    description = promotion.description,
                    link = TebexStoreLink[cityName].."/package/"..productId,
                    price = promotion.price,
                    canCancel = false,
                }
            })
        end
        CreateThread(function()
            while PromotionCountdown > 0 do
                PromotionCountdown = PromotionCountdown - 1
                Wait(1000)
            end
        end)
        if not micTutorialActive then
            SetNuiFocus(true,true)
        end
    end
end)

RegisterNetEvent("playerUpdatePromotion")
AddEventHandler("playerUpdatePromotion",function(productId,countDown)
    print("playerUpdatePromotion >>", json.encode(productId), json.encode(countDown))
    PromotionCountdown = countDown
    LocalPlayer["state"]:set("playerPromotion",productId,false)
    CreateThread(function()
        while PromotionCountdown > 0 do
            PromotionCountdown = PromotionCountdown - 1
            Wait(1000)
        end
    end)
end)

RegisterNUICallback("clickPromo",function(data,cb)
    print("clickPromo >>", json.encode(LocalPlayer["state"]["playerPromotion"]))
    local removeFocus = data.removeFocus
    local productId = LocalPlayer["state"]["playerPromotion"]
    if productId then
        TriggerServerEvent("clickPromotion",productId)
    end
    if removeFocus then
        SetNuiFocus(false,false)
    end
    cb(true)
end)

RegisterNUICallback("closePromotionTimer",function(data,cb)
    print("closePromotionTimer >>", json.encode(data))
    PromotionTimerStatus = false
    if LocalPlayer["state"]["playerPromotion"] then
        local productId = LocalPlayer["state"]["playerPromotion"]
        local promotion = GetPromotionByProductId(productId)
        if promotion then
            if PromotionCountdown and PromotionCountdown > 0 then
                print("openPromotionCountDown >>>", PromotionTimerStatus)
                SendNUIMessage({
                    action = "openPromotionCountDown",
                    data =  {
                        image = promotion.background,
                        countDown = PromotionCountdown,
                        background_color = promotion.background_color,
                        timerStatus = PromotionTimerStatus
                    }
                })
            end
        end
    end
    cb(true)
end)

RegisterNUICallback("redeemPromotion",function(data,cb)
    print("redeemPromotion >>", json.encode(LocalPlayer["state"]["playerPromotion"]))
    if LocalPlayer["state"]["playerPromotion"] then
        local productId = LocalPlayer["state"]["playerPromotion"]
        local promotion = GetPromotionByProductId(productId)
        if promotion then
            if PromotionCountdown and PromotionCountdown > 0 then
                print("startPromotionModal")
                SendNUIMessage({
                    action = "startPromotionModal",
                    data =  {
                        productId = productId,
                        image = promotion.background,
                        background = promotion.background,
                        background_color = promotion.background_color,
                        countDown = PromotionCountdown,
                        itens = promotion.itens,
                        description = promotion.description,
                        link = TebexStoreLink[cityName].."/package/"..productId,
                        price = promotion.price,
                        canCancel = true,
                    }
                })
            end
        end
    end
    cb(true)
end)

RegisterNUICallback("ClosePromotionModal",function(data,cb)
    print("ClosePromotionModal >>", json.encode(data))
    local productId = data.productId
    local cancel = data.cancel
    local removeFocus = data.removeFocus
    if cancel then
        TriggerServerEvent("cancelPromotionModal",productId)
        SendNUIMessage({
            action = "closePromotionCountDown",
            data = true
        })
        LocalPlayer["state"]:set("playerPromotion",nil,false)
    else
        local promotion = GetPromotionByProductId(productId)
        if promotion then
            if PromotionCountdown and PromotionCountdown > 0 and not removeFocus then
                print("openPromotionCountDown")
                SendNUIMessage({
                    action = "openPromotionCountDown",
                    data =  {
                        image = promotion.background,
                        countDown = PromotionCountdown,
                        background_color = promotion.background_color,
                        timerStatus = PromotionTimerStatus,
                    }
                })
            end
        end
    end
    if removeFocus then
        SetNuiFocus(false,false)
    end
    cb(true)
end)



---@param threshold number
---@return boolean
local function StorePromotionalVideoPlayingProgress( threshold )

    local KVP_KEY = ('promotionalVideoPlayingProgressCustomerEventThresholdLastHitAt:%s:%s'):format( GetConvar( 'cityName', '' ), threshold )

    local now = GetCloudTimeAsInt()

    print('StorePromotionalVideoPlayingProgress -> now', now )

    local prevHitAt = GetResourceKvpInt( KVP_KEY )

    print('StorePromotionalVideoPlayingProgress -> prevHitAt', prevHitAt )

    local isPrevHitToday = prevHitAt ~= 0 and ( now - prevHitAt < 86400 ) -- 86400 seconds = 24 hours

    print('StorePromotionalVideoPlayingProgress -> isToday', isPrevHitToday )

    if isPrevHitToday then
        return false
    end

    SetResourceKvpInt( KVP_KEY, GetCloudTimeAsInt() )

    return true
end

RegisterNUICallback( 'promotionalVideoPlayingProgressChanged', function( data, cb )

    local thresholdHit = sx.table.includes( PROMOTIONAL_VIDEO_PLAYING_PROGRESS_CUSTOMER_EVENT_THRESHOLDS, data.progress )

    print('StorePromotionalVideoPlayingProgress -> thresholdHit', thresholdHit, data.progress)

    if thresholdHit then

        if StorePromotionalVideoPlayingProgress( data.progress ) then

            TriggerServerEvent( 'net.promotionalVideoPlayingProgress', data.progress )
        end
    end

    cb({ ok = true })
end)