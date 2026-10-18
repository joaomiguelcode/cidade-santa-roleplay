RegisterNetEvent("net.itemvip:change-visible", function(isVisible, playerItems)
    if isVisible then
        return OpenItemVipFrame(playerItems)
    end

    CloseItemVipFrame()
end)
