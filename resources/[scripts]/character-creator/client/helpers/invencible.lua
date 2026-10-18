Invencible = {}

---@param invencible boolean
function Invencible.SetPlayer(invencible)
    LocalPlayer["state"]["Invincible"] = invencible
    SetPlayerInvincible(PlayerId(), invencible)
end