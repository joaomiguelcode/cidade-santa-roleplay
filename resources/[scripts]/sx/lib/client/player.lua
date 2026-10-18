sx.client.player = { }

--@param source Source
---@return vector3
function sx.client.player.getFocusPosition()

    if GetResourceState( 'admin' ) == 'started' and exports[ 'admin' ]:IsUsingFreecam() then

        return GetFinalRenderedCamCoord()
    end

    return GetEntityCoords( PlayerPedId() )
end

---@return number
function sx.client.player.getFocusHeading()

    if GetResourceState( 'admin' ) == 'started' and exports[ 'admin' ]:IsUsingFreecam() then

        local rot = GetFinalRenderedCamRot( 2 )

        return rot.z
    end

    return GetEntityHeading( PlayerPedId() )
end
