---Carrega os comandos das animações ao iniciar o script.
OnLoad(function()
    for index,animDatas in pairs(Config.animsList) do
        if animDatas.actived then
            RegisterCommand(animDatas.command, function()
                if (LocalPlayer.state["minigame:active"] == "deathstatue" or LocalPlayer.state["minigame:active"] == "cargame") then
                    return
                end

                exports["dk"]:playAnimation(index)
            end)
        end
    end
end)