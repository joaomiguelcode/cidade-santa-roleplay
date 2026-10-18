Animation = {}

function Animation.freeze()
    RequestAnimDict(CREATOR_CONFIG.ANIMATION_DICT)
    while not HasAnimDictLoaded(CREATOR_CONFIG.ANIMATION_DICT) do
        Wait(100)
    end

    CreateThread(function()
        while gCreationState.flag do
            local ped = PlayerPedId()

            TaskPlayAnim(ped, CREATOR_CONFIG.ANIMATION_DICT, CREATOR_CONFIG.ANIMATION_NAME, 3.0, -3.0, -1, 1, 0.0, false, false, false)
            SetFacialIdleAnimOverride(ped, "pose_normal_1", 0)
            Wait(100)
        end
    end)
end
