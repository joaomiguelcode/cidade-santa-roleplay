--- Micro-optimization
local exp_party    = exports[ 'party'    ]
--- Micro-optimization END

---Calculo de computação de recompensas compartilhado
---entre vários tipos de minigames!
---@type MinigameHookBeforeComputeRewards
CommonBeforeComputeRewards = function ( event )

    local source = event.minigame.hostedBySource

    -- Passport já resolvido pelo chamador na mesma execução (sem yield) evita
    -- uma chamada Proxy duplicada; sem ele, resolve como antes.
    local passport = event.passport

    if passport == nil then

        passport = vRP.Passport( source )
    end
    local partyMembers = exp_party:Room( passport, source, 50.0 )

    -- Multiplicador para jogadores em party
    if partyMembers then

        -- Quando houver 4 membros na party
        -- o multiplicador vai ser de 100%

        -- + 25% de items a cada membro na party
        event.config.rewardAmountMultiplier += ( 0.25 * #partyMembers )
        table.insert(event.config.buffs, {
            type = "partybuff",
            amount = 0.25 * #partyMembers
        })
    end

    -- Multiplicador para jogadores com VIP nos farms ilegais diretos.
    if event.minigame.def.allowsVipFarmBuff then
        local vips = vRP.HasVip( passport )
        local rewardMultipliersByVip = sx.vipsystem.GetVipsScriptsConfig("farmer","reward_multipliers")

        if vips then

            for vip, _ in pairs( vips ) do

                -- Aumentar o multiplicador de recompensas enquanto as
                -- as recompensas estiverem sendo calculadas ( criadas/definidas )
                event.config.rewardAmountMultiplier += ( rewardMultipliersByVip[ vip ] or 0.0 )
                table.insert(event.config.buffs, {
                    type = "vip_"..vip,
                    amount = rewardMultipliersByVip[ vip ] or 0.0
                })
            end
        end
    end

    event.config.rewardAmountMultiplier *= event.minigame.def.activeFarmRewardMultiplier or 1.0

end
