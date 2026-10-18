-- RegisterNUICallback("Convergence", function(data, cb)
--     print("Convergence")
--     cb(vSERVER.GetUserInfo())
-- end)

-- RegisterCommand("convergence", function()
--     Wait(100)
--     print("Convergence")
--     Wait(50)
--     SendNUIMessage({
--         action = "Convergence",
--         data = vSERVER.GetUserInfo()
--     })
--     Wait(50)
--     SendNUIMessage({
--         action = "setVisible",
--         data = "converge"
--     })
--     Wait(50)
--     SendNUIMessage({
--         action = "convergeType",
--         data = "diamond"
--     })
--     SetNuiFocus(true, true)
-- end) 

AddEventHandler("convergence:Open",function(Type)
    --print("Convergence",Type)
    SendNUIMessage({
        action = "Convergence",
        data = {
            info = vSERVER.GetUserInfo(),
            Type = Type,
        }
    })
    SendNUIMessage({
        action = "convergeType",
        data = Type
    })
    Wait(50)
    SendNUIMessage({
        action = "setVisible",
        data = "converge"
    })

    SetNuiFocus(true, true)
end)

RegisterNUICallback("ConvergenceResult", function(data, cb)
    vSERVER.FinishConvergence(data["type"],parseInt(data["value"]))
    SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })
end)

RegisterNetEvent("convergence:Close")
AddEventHandler("convergence:Close",function()
    SendNUIMessage({
        action = "setVisible",
        data = "false"
    })
    SetNuiFocus(false, false)
end)