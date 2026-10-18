--[[
  interface HomeData { -> home:getData
    company: {
      name: string;
      level: number;
      owner: string;
    };
    frequency: number;
    employees: [number, number];
    passiveIncome: {
      reward: number;
      nextRewardAt: number;
    };
    performance: {
      dailyEarnings: number;
      chart: [number, number];
    };
    goals: {
      rescuedAmount: number;
      deliveries: number;
    },
    hasUniform: boolean;
  }
]]

local DELAY_TIME_TO_ENTER_RADIO = 500 -- delay pra ficar bonitinho no frontend :D

---@param player number
local function OnCreateProfilePicture(player)
  local handle = RegisterPedheadshotTransparent(player)

  while not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) do
    Wait(0)
  end

  local txd = GetPedheadshotTxdString(handle)

  UnregisterPedheadshot(handle)
  return txd
end

RegisterNUICallback('home:getData', function(data, callback)
  local response = lib.callback.await('enterprise/ui/get-home-data', false, EnterPriseClass.activeEnterprise)

  if not next(response) then
    return callback({})
  end

  response.goals.baseReward = SHARED_SETTINGS.GOALS_REWARDS
  response.goals.perGoalDelivery = SHARED_SETTINGS.GOALS_REQUIREMENT

  callback(response)
end)

RegisterNUICallback('home:wearUniform', function(data, callback)
  lib.callback.await('enterprise/ui/wear-uniform', false, EnterPriseClass.activeEnterprise)
  callback(true)
end)

RegisterNUICallback('home:enterRadio', function(data, callback)
  TriggerEvent('radio:EnterRadioPainel', data.frequency)
  SetTimeout(DELAY_TIME_TO_ENTER_RADIO, function()
    callback(true)
  end)
end)

RegisterNUICallback('user:me', function(data, callback)
  local response = lib.callback.await('enterprise/ui/get-user-me', false, EnterPriseClass.activeEnterprise)
  local picture = OnCreateProfilePicture(PlayerPedId())
  local avatar = ('https://nui-img/%s/%s'):format(picture, picture)

  -- [[ caso por algum motivo ele consiga abrir a nui sem ter permissão para não dar crash no front ]]
  if not next(response) then
    return callback({})
  end

  response.avatar = avatar
  response.permissions = (
    SHARED_SETTINGS.roles[response.role] and SHARED_SETTINGS.roles[response.role].permissions or {}
  )

  callback(response)
end)

RegisterNUICallback('home:claimGoal', function(data, callback)
  local response = lib.callback.await('enterprise/ui/claim-goal', false, EnterPriseClass.activeEnterprise)
  callback(response)
end)