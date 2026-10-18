
---Jogador está dentro de um volume de minigame (volume global)
---@param volumeDef MinigameVolumeDef
function OnUpdateMinigamePoint( volumeDef )

    if volumeDef.index == MINIGAMEVOLUME_DEF_TEMPORARY_INDEX then

        -- Index temporário, vamos ignorar!

        -- print(('OnUpdateMinigamePoint :: Index temporário, vamos ignorar! volumeDef.index=%s'):format(volumeDef.index))

        return
    end

    local minigame = GetActiveMinigame()

    if  not CanCreateMinigameClient( volumeDef )
        and not (
            minigame and
            minigame.isStarted == false and
            minigame.volumeDef and minigame.volumeDef.index == volumeDef.index
        )
    then

        -- local minigameDef = MINIGAME_DEF_DATABASE[ volumeDef.minigameDefIndex ]

        -- print(('OnUpdateMinigamePoint :: Não pode criar minigame %s'):format(minigameDef.displayName:upper()))

        return
    end

    local volumePos = volumeDef.volume.coords

    DrawMarker(20, volumePos.x, volumePos.y, volumePos.z - 0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, 0, 0, 0, 1)

    local fc = GetFrameCount()

    local minigameDef = MINIGAME_DEF_DATABASE[ volumeDef.minigameDefIndex ]

    assert(minigameDef, ('MinigameDef not found with minigameDefIndex=%s!'):format(volumeDef.minigameDefIndex))

    if fc % 100 == 0 then

        -- print(('OnUpdateMinigamePoint :: Iniciar %s'):format(volumeDef.minigameDef.displayName:upper()))
        TriggerEvent("hoverfy:toggle", true, { title = minigameDef.displayName:upper(), key = "E", legend = _t("press_to_start") })
    end

    if IsControlJustPressed(0, 38) and not vRP.ReturnNoClip() then

        if minigame then

            RequestStartMinigame(minigame)
        else

            RequestCreateMinigameFromVolume({ minigameDefIndex = minigameDef.index, volumeLocalIdx = volumeDef.localIndex })
        end
    end
end

---Jogador saiu do volume de minigame (volume global)
---@param volumeDef MinigameVolumeDef
function OnExitMinigamePoint(volumeDef)

    local minigame = GetActiveMinigame()

    if minigame and minigame.isStarted and minigame.volumeDef and minigame.volumeDef.index == volumeDef.index then

        CreateThread(
            function()

                RequestEndMinigame( minigame )
            end
        )
    end

    TriggerEvent('hoverfy:removeHoverfy')
end