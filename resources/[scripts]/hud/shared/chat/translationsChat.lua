cityName = GetConvar("cityName", "")
language = GetConvar("language", "") or false

chatConfig = {
    ["en-us"] = {
        ["#applyBan"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg8}}h was banned. | Reason: {{msg4}} | Description: {{msg5}} | By: {{msg6}} | {{msg7}} [{{msg9}}]",
            ['mode'] = "🚫 Ban",
        },
        ["#applyBan2"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg7}}h was banned. | Reason: {{msg4}} | Description: {{msg5}} | By: {{msg5}} | {{msg6}} [{{msg8}}]",
            ['mode'] = "🚫 Ban",
        },
        ["#consoleCommand"] = {
            ['author'] = "ID: ",
            ['message'] = "{{msg1}}", 
            ['mode'] = "warning",  
        },        
        ["#warningNoti"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} {{msg3}} | {{msg9}}h was warned. | Time: {{msg4}} minutes. | Reason: {{msg5}} | Description: {{msg6}} | By: {{msg7}} | {{msg8}} [{{msg10}}]",
            ['mode'] = "🚫 Warning",
        },        
        ["#remAdv"] = {
            ['author'] = "",
            ['message'] = "Passport: {{msg1}} | {{msg2}} removed adv from {{msg3}} | {{msg4}}",
            ['mode'] = "⛔️ RemoveAdv",
        },        
        ["#vipStoree"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#arrivedNow"] = {
            ['author'] = "Just arrived?",
            ['message'] = "{{msg}}",
            ['mode'] = "👑 BE A LEADER",
        },        
        ["#playerKStreak"] = {
            ['author'] = "Player",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} is on a kill streak of {{msg4}}.",
            ['mode'] = "arena",
        },        
        ["#playerKStreakStop"] = {
            ['author'] = "Player",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} is on a kill streak of {{msg4}}, can anyone stop this machine?",
            ['mode'] = "arena",
        },        
        ["#ffaMap1Min"] = {
            ['author'] = "",
            ['message'] = "The FFA map will change in 1 minute",
            ['mode'] = "FFA",
        },        
        ["#ffaMap3Min"] = {
            ['author'] = "",
            ['message'] = "The FFA map will change in 3 minutes",
            ['mode'] = "FFA",
        },        
        ["#ffaMap5Min"] = {
            ['author'] = "",
            ['message'] = "The FFA map will change in 5 minutes",
            ['mode'] = "FFA",
        },        
        ["#playerWinFfa"] = {
            ['author'] = "",
            ['message'] = "ID [{{msg1}}] {{msg2}} has just won the FFA {{msg3}} with {{msg4}} Kills",
            ['mode'] = "FFA",
        },        
        ["#playerOneKStreak"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} is on a kill streak of {{msg4}}, is the ScreenShare team on?",
            ['mode'] = "arena",
        },        
        ["#playerOneKStreakCall"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} is on a kill streak of {{msg4}}, call the ScreenShare team",
            ['mode'] = "arena",
        },        
        ["#playerOneKStreakPuro"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} is on a kill streak of {{msg4}}, are you sure it's not pure?",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakTelem"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} is on a kill streak of {{msg4}}, teleport him urgently!!!",
            ['mode'] = "arena",
        },        
        ["#beguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "A beginner just entered the city, ID: {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Beginner",
        },
        ["#admReport"] = {
            ['author'] = "Administrator",
            ['message'] = "{{msg}}",
            ['mode'] = "Reports",
        },
        ["#admTicket"] = {
            ['author'] = "Administrator",
            ['message'] = "{{msg}}",
            ['mode'] = "Tickets",
        },
        ["#playerAhiv"] = {
            ['author'] = "Player: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} completed the achievement [{{msg4}}]",
            ['mode'] = "",
        },
        ["#aliasOrgani"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Panel",
        },
        ["#startRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} started dating {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relationship",
        },
        ["#startEngaged"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} got engaged to {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relationship",
        },
        ["#startMarried"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} got married to {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relationship",
        },
        ["#endRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} and {{msg3}} {{msg4}} broke up, you can now say Hi to the ex!",
            ['mode'] = "🤲 Relationship",
        },
        ["#newStartRelationship"] = {
            ['author'] = "",
            ['message'] = "💙 {{msg1}} {{msg2}} and {{msg3}} {{msg4}} started dating! Congratulations to the new couple!",
            ['mode'] = "❤️ Relationship",
        },
        ["#newStartEngaged"] = {
            ['author'] = "",
            ['message'] = "💍 {{msg1}} {{msg2}} got engaged to {{msg3}} {{msg4}}!",
            ['mode'] = "❤️ Relationship",
        },
        ["#newStartMarried"] = {
            ['author'] = "",
            ['message'] = "🕊 {{msg1}} {{msg2}} & {{msg3}} {{msg4}} got MARRIED! May their union be eternal! 💞",
            ['mode'] = "❤️ Relationship",
        },
        ["#newEndRelationship"] = {
            ['author'] = "",
            ['message'] = "💔 {{msg1}} {{msg2}} and {{msg3}} {{msg4}} are no longer together. Someone to console in private?",
            ['mode'] = "🤲 Relationship",
        },
        ["#newCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "🐂 Hey {{msg1}} {{msg2}} cheater, {{msg3}} {{msg4}} is trying to cheat on you. {{msg1}} {{msg2}} started a new relationship with {{msg5}} {{msg6}}.",
            ['mode'] = "🐂 Relationship",
        },
        ["#cheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Hello {{msg1}} {{msg2}} cheater, {{msg3}} {{msg4}} is trying to cheat on you.",
            ['mode'] = "🐂 Relationship",
        },
        ["#tryCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Hello {{msg1}} {{msg2}} cheater, {{msg3}} {{msg4}} tried to cheat on you.",
            ['mode'] = "🐂 Relationship",
        },
        ["#flirtingAlert"] = {
            ['author'] = "",
            ['message'] = "Hello {{msg1}} {{msg2}}, be careful! {{msg3}} {{msg4}} is flirting with {{msg5}} {{msg6}}",
            ['mode'] = "💔 Relationship",
        },
        ["#lojaVip"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🏷️ VIP STORE",
        },
        ["#theDomi"] = {
            ['author'] = "",
            ['message'] = "THE DOMINATION [{{msg1}}] Was [STARTED] by the group {{msg2}} for [R${{msg3}}]",
            ['mode'] = "DOMINATION",
        },
        ["#cancelDomi"] = {
            ['author'] = "",
            ['message'] = "THE DOMINATION [{{msg}}] was [CANCELLED].",
            ['mode'] = "DOMINATION",
        },
        ["#accumulatedDomi"] = {
            ['author'] = "",
            ['message'] = "THE DOMINATION [{{msg1}}] has accumulated [$ {{msg2}}]",
            ['mode'] = "DOMINATION",
        },        
        ["#domiCompleted"] = {
            ['author'] = "",
            ['message'] = "THE DOMINATION [{{msg1}}] was [COMPLETED] by the group [{{msg2}}].",
            ['mode'] = "DOMINATION",
        },
        ["#teamWinEvent"] = {
            ['author'] = "",
            ['message'] = "The team {{msg1}} won the event {{msg2}}.",
            ['mode'] = "FFA",
        },
        ["#statusWar"] = {
            ['author'] = "WAR",
            ['message'] = "{{msg1}} {{msg2}} x {{msg3}} {{msg4}}",
            ['mode'] = "WAR",
        },
        ["#boughtCar"] = {
            ['author'] = "ID: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} bought the car {{msg4}} at the dealership.",
            ['mode'] = "🚗 Dealership",
        },        
        ["#contratOrg"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Panel",
        },
        ["#megaPhone"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "📢 Megaphone",
        },
        ["#breakupNotice"] = {
            ['author'] = "",
            ['message'] = "Hello {{msg1}} {{msg2}}, apparently {{msg3}} {{msg4}} just broke up. It's time to ask if everything is okay, pm on instagram.",
            ['mode'] = "🤲 Relationship",
        },
        ["#algumNome"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#chatBlack"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatPuroPrime"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatTutor"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatDefault"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome2"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome3"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#gotCard"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Tirou {{msg3}}{{msg4}} do baralho.",
            ['mode'] = "jogo",
        },
        ["#gotCard2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Tirou {{msg3}}{{msg4}} do baralho.",
            ['mode'] = "jogo",
        },
        ["#slideCoin"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "jogo",
        },
        ["#slideCoin2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "jogo",
        },
        ["#policeServ"] = {
            ['author'] = "{{msg1}} | {{msg2}} ",
            ['message'] = "{{msg3}}",
            ['mode'] = "chamado",
        },



        
    },
    ["pt-br"] = {
        ["#applyBan"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg8}}h foi banido. | Motivo: {{msg4}} | Descrição: {{msg5}} | Por: {{msg6}} | {{msg7}} [{{msg9}}]",
            ['mode'] = "🚫Ban",
        },
        ["#applyBan2"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg7}}h foi banido. | Motivo: {{msg4}} | Descrição: {{msg5}} | Por: {{msg5}} | {{msg6}} [{{msg8}}]",
            ['mode'] = "🚫 Ban",
        },
        ["#consoleCommand"] = {
            ['author'] = "ID: ",
            ['message'] = "{{msg1}}", 
            ['mode'] = "aviso",  
        },
        ["#warningNoti"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} {{msg3}} | {{msg9}}h foi advertido. | Por: {{msg4}} minutos. | Motivo: {{msg5}} | Descrição: {{msg6}} | Por: {{msg7}} | {{msg8}} [{{msg10}}]",
            ['mode'] = "🚫 Advertência",
        },
        ["#remAdv"] = {
            ['author'] = "",
            ['message'] = "Passaporte: {{msg1}} | {{msg2}} retirou adv de {{msg3}} | {{msg4}}",
            ['mode'] = "⛔️ RemAdv",
        },
        ["#vipStoree"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#arrivedNow"] = {
            ['author'] = "Chegou agora?",
            ['message'] = "{{msg}}",
            ['mode'] = "👑 SEJA LIDER",
        },
        ["#playerKStreak"] = {
            ['author'] = "Jogador",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} Está com um kill streak de {{msg4}}.",
            ['mode'] = "arena",
        },
        ["#playerKStreakStop"] = {
            ['author'] = "Jogador",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} Está com um kill streak de {{msg4}}, Será que alguem consegue parar essa maquina ?",
            ['mode'] = "arena",
        },
        ["#ffaMap1Min"] = {
            ['author'] = "",
            ['message'] = "O mapa do FFA vai mudar em 1 minuto",
            ['mode'] = "FFA",
        },
        ["#ffaMap3Min"] = {
            ['author'] = "",
            ['message'] = "O mapa do FFA vai mudar em 3 minutos",
            ['mode'] = "FFA",
        },
        ["#ffaMap5Min"] = {
            ['author'] = "",
            ['message'] = "O mapa do FFA vai mudar em 5 minutos",
            ['mode'] = "FFA",
        },
        ["#playerWinFfa"] = {
            ['author'] = "",
            ['message'] = "O ID [{{msg1}}] {{msg2}} acabou de vencer o FFA {{msg3}} com {{msg4}} Kills",
            ['mode'] = "FFA",
        },
        ["#playerOneKStreak"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} Está com um kill streak de {{msg4}}, equipe Telagem tá on?",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakCall"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} Está com um kill streak de {{msg4}}, chamem a Equipe Telagem",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakPuro"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} Está com um kill streak de {{msg4}}, certeza que não tá puro!",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakTelem"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} Está com um kill streak de {{msg4}}, telem ele urgente!!!",
            ['mode'] = "arena",
        },
        ["#bguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "Acabou de entrar um iniciante na cidade, ID: {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Iniciante",
        },
        ["#admReport"] = {
            ['author'] = "Administrador",
            ['message'] = "{{msg}}",
            ['mode'] = "Denuncias",
        },
        ["#admTicket"] = {
            ['author'] = "Administrador",
            ['message'] = "{{msg}}",
            ['mode'] = "Chamados",
        },
        ["#playerAhiv"] = {
            ['author'] = "O Jogador: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} concluiu a conquista [{{msg4}}]",
            ['mode'] = "",
        },
        ["#aliasOrgani"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Painel",
        },
        ["#startRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} começou a namorar com {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#startEngaged"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} Noivou com {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#startMarried"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} se casou com {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#endRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} e {{msg3}} {{msg4}} se separaram, já podem mandar um Oi sumida(o)",
            ['mode'] = "🤲 Relacionamento",
        },
        ["#newStartRelationship"] = {
            ['author'] = "",
            ['message'] = "💙 {{msg1}} {{msg2}} e {{msg3}} {{msg4}} começaram a namorar! Felicidades ao novo casal!",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#newStartEngaged"] = {
            ['author'] = "",
            ['message'] = "💍 {{msg1}} {{msg2}} pediu {{msg3}} {{msg4}} em NOIVADO e recebeu um SIM!",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#newStartMarried"] = {
            ['author'] = "",
            ['message'] = "🕊 {{msg1}} {{msg2}} & {{msg3}} {{msg4}} se CASARAM! Que a união seja eterna! 💞",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#newEndRelationship"] = {
            ['author'] = "",
            ['message'] = "💔 {{msg1}} {{msg2}} e {{msg3}} {{msg4}} NÃO estão mais juntos. Alguém pra consolar no privado?",
            ['mode'] = "🤲 Relacionamento",
        },
        ["#newCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "🐂 Opa Opa, {{msg1}} {{msg2}} está TRAINDO {{msg3}} {{msg4}}. {{msg1}} {{msg2}} Começou uma nova relação com {{msg5}} {{msg6}}.",
            ['mode'] = "🐂 Relacionamento",
        },
        ["#cheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Alo {{msg1}} {{msg2}} chifrudo(a), {{msg3}} {{msg4}} ta tentando te trair.",
            ['mode'] = "🐂 Relacionamento",
        },
        ["#tryCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Alo {{msg1}} {{msg2}} chifrudo(a), {{msg3}} {{msg4}} tentou te meter gaia.",
            ['mode'] = "🐂 Relacionamento",
        },
        ["#flirtingAlert"] = {
            ['author'] = "",
            ['message'] = "Alô {{msg1}} {{msg2}}, fique atento! {{msg3}} {{msg4}} está dando em cima de {{msg5}} {{msg6}}",
            ['mode'] = "💔 Relacionamento",
        },
        ["#lojaVip"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🏷️ LOJA VIP",
        },
        ["#theDomi"] = {
            ['author'] = "",
            ['message'] = "A DOMINAÇÃO [{{msg1}}] Foi [INÍCIADA] pelo grupo {{msg2}} valendo [R${{msg3}}]",
            ['mode'] = "DOMINAÇÃO",
        },
        ["#cancelDomi"] = {
            ['author'] = "",
            ['message'] = "A DOMINAÇÃO [{{msg}}] foi [CANCELADA].",
            ['mode'] = "DOMINAÇÃO",
        },
        ["#accumulatedDomi"] = {
            ['author'] = "",
            ['message'] = "A DOMINAÇÃO [{{msg1}}] está acumulada em [$ {{msg2}}]",
            ['mode'] = "DOMINAÇÃO",
        },
        ["#domiCompleted"] = {
            ['author'] = "",
            ['message'] = "A DOMINAÇÃO [{{msg1}}] foi [CONCLUÍDA] pelo grupo [{{msg2}}].",
            ['mode'] = "DOMINAÇÃO",
        },
        ["#teamWinEvent"] = {
            ['author'] = "",
            ['message'] = "O time {{msg1}} venceu o evento {{msg2}}.",
            ['mode'] = "FFA",
        },
        ["#statusWar"] = {
            ['author'] = "GUERRA",
            ['message'] = "{{msg1}} {{msg2}} x {{msg3}} {{msg4}}",
            ['mode'] = "GUERRA",
        },
        ["#boughtCar"] = {
            ['author'] = "ID: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} comprou o carro {{msg4}} na concessionária.",
            ['mode'] = "🚗Concessionária",
        },
        ["#contratOrg"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Painel",
        },
        ["#megaPhone"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "📢 Megaphone",
        },
        ["#breakupNotice"] = {
            ['author'] = "",
            ['message'] = "Oi sumida(o)! Aparentemente o {{msg1}} {{msg2}} acabou de separar de {{msg3}} {{msg4}}. É hora de perguntar se tá tudo bem no pv do insta.",
            ['mode'] = "🤲 Relacionamento",
        },
        ["#algumNome"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#chatBlack"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatPuroPrime"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatTutor"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatDefault"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome2"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome3"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#gotCard"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Tirou {{msg3}}{{msg4}} do baralho.",
            ['mode'] = "jogo",
        },
        ["#gotCard2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Tirou {{msg3}}{{msg4}} do baralho.",
            ['mode'] = "jogo",
        },
        ["#slideCoin"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "jogo",
        },
        ["#slideCoin2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "jogo",
        },
        ["#policeServ"] = {
            ['author'] = "{{msg1}} | {{msg2}} ",
            ['message'] = "{{msg3}}",
            ['mode'] = "chamado",
        },
        ["#beguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "Acabou de entrar um iniciante na cidade, ID: {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Iniciante",
        },
       
    },
    ["fr-fr"] = {
        ["#applyBan"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg8}}h a été banni. | Raison : {{msg4}} | Description : {{msg5}} | Par : {{msg6}} | {{msg7}} [{{msg9}}]",
            ['mode'] = "🚫 Ban",
        },
        ["#applyBan2"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg7}}h a été banni. | Raison : {{msg4}} | Description : {{msg5}} | Par : {{msg5}} | {{msg6}} [{{msg8}}]",
            ['mode'] = "🚫 Ban",
        },
        ["#consoleCommand"] = {
            ['author'] = "ID : ",
            ['message'] = "{{msg1}}",
            ['mode'] = "avertissement",
        },
        ["#warningNoti"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} {{msg3}} | {{msg9}}h a été averti. | Durée : {{msg4}} minutes. | Raison : {{msg5}} | Description : {{msg6}} | Par : {{msg7}} | {{msg8}} [{{msg10}}]",
            ['mode'] = "🚫 Avertissement",
        },
        ["#remAdv"] = {
            ['author'] = "",
            ['message'] = "Passeport : {{msg1}} | {{msg2}} a retiré l'avertissement de {{msg3}} | {{msg4}}",
            ['mode'] = "⛔️ RemAdv",
        },
        ["#vipStoree"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#arrivedNow"] = {
            ['author'] = "Venez d'arriver ?",
            ['message'] = "{{msg}}",
            ['mode'] = "👑 SOYEZ LEADER",
        },
        ["#playerKStreak"] = {
            ['author'] = "Joueur",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} est sur une série de {{msg4}} kills.",
            ['mode'] = "arena",
        },
        ["#playerKStreakStop"] = {
            ['author'] = "Joueur",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} est sur une série de {{msg4}} kills, qui peut arrêter cette machine ?",
            ['mode'] = "arena",
        },
        ["#ffaMap1Min"] = {
            ['author'] = "",
            ['message'] = "La carte FFA change dans 1 minute",
            ['mode'] = "FFA",
        },
        ["#ffaMap3Min"] = {
            ['author'] = "",
            ['message'] = "La carte FFA change dans 3 minutes",
            ['mode'] = "FFA",
        },
        ["#ffaMap5Min"] = {
            ['author'] = "",
            ['message'] = "La carte FFA change dans 5 minutes",
            ['mode'] = "FFA",
        },
        ["#playerWinFfa"] = {
            ['author'] = "",
            ['message'] = "L'ID [{{msg1}}] {{msg2}} vient de remporter le FFA {{msg3}} avec {{msg4}} kills",
            ['mode'] = "FFA",
        },
        ["#playerOneKStreak"] = {
            ['author'] = "",
            ['message'] = "ID : [{{msg1}}] {{msg2}} {{msg3}} est sur une série de {{msg4}} kills, l'équipe ScreenShare est là ?",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakCall"] = {
            ['author'] = "",
            ['message'] = "ID : [{{msg1}}] {{msg2}} {{msg3}} est sur une série de {{msg4}} kills, appelez l'équipe ScreenShare",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakPuro"] = {
            ['author'] = "",
            ['message'] = "ID : [{{msg1}}] {{msg2}} {{msg3}} est sur une série de {{msg4}} kills, c'est sûr que c'est pas du propre ?",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakTelem"] = {
            ['author'] = "",
            ['message'] = "ID : [{{msg1}}] {{msg2}} {{msg3}} est sur une série de {{msg4}} kills, téléportez-le d'urgence !!!",
            ['mode'] = "arena",
        },
        ["#bguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "Un débutant vient d'entrer en ville, ID : {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Débutant",
        },
        ["#admReport"] = {
            ['author'] = "Administrateur",
            ['message'] = "{{msg}}",
            ['mode'] = "Signalements",
        },
        ["#admTicket"] = {
            ['author'] = "Administrateur",
            ['message'] = "{{msg}}",
            ['mode'] = "Appels",
        },
        ["#playerAhiv"] = {
            ['author'] = "Le joueur : ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} a accompli le succès [{{msg4}}]",
            ['mode'] = "",
        },
        ["#aliasOrgani"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Panneau",
        },
        ["#startRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} sort avec {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relation",
        },
        ["#startEngaged"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} s'est fiancé à {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relation",
        },
        ["#startMarried"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} s'est marié avec {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relation",
        },
        ["#endRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} et {{msg3}} {{msg4}} ont rompu, vous pouvez dire bonjour à l'ex !",
            ['mode'] = "🤲 Relation",
        },
        ["#newStartRelationship"] = {
            ['author'] = "",
            ['message'] = "💙 {{msg1}} {{msg2}} et {{msg3}} {{msg4}} sortent ensemble ! Félicitations au nouveau couple !",
            ['mode'] = "❤️ Relation",
        },
        ["#newStartEngaged"] = {
            ['author'] = "",
            ['message'] = "💍 {{msg1}} {{msg2}} a demandé {{msg3}} {{msg4}} en mariage et a reçu un OUI !",
            ['mode'] = "❤️ Relation",
        },
        ["#newStartMarried"] = {
            ['author'] = "",
            ['message'] = "🕊 {{msg1}} {{msg2}} & {{msg3}} {{msg4}} se sont MARIÉS ! Que leur union soit éternelle ! 💞",
            ['mode'] = "❤️ Relation",
        },
        ["#newEndRelationship"] = {
            ['author'] = "",
            ['message'] = "💔 {{msg1}} {{msg2}} et {{msg3}} {{msg4}} ne sont plus ensemble. Quelqu'un pour consoler en privé ?",
            ['mode'] = "🤲 Relation",
        },
        ["#newCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "🐂 Hé {{msg1}} {{msg2}} tricheur, {{msg3}} {{msg4}} essaie de te tromper. {{msg1}} {{msg2}} a commencé une nouvelle relation avec {{msg5}} {{msg6}}.",
            ['mode'] = "🐂 Relation",
        },
        ["#cheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Allô {{msg1}} {{msg2}} cocu, {{msg3}} {{msg4}} essaie de te tromper.",
            ['mode'] = "🐂 Relation",
        },
        ["#tryCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Allô {{msg1}} {{msg2}} cocu, {{msg3}} {{msg4}} a essayé de te tromper.",
            ['mode'] = "🐂 Relation",
        },
        ["#flirtingAlert"] = {
            ['author'] = "",
            ['message'] = "Allô {{msg1}} {{msg2}}, attention ! {{msg3}} {{msg4}} drague {{msg5}} {{msg6}}",
            ['mode'] = "💔 Relation",
        },
        ["#lojaVip"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🏷️ BOUTIQUE VIP",
        },
        ["#theDomi"] = {
            ['author'] = "",
            ['message'] = "LA DOMINATION [{{msg1}}] a été [LANCÉE] par le groupe {{msg2}} pour [{{msg3}} €]",
            ['mode'] = "DOMINATION",
        },
        ["#cancelDomi"] = {
            ['author'] = "",
            ['message'] = "La domination [{{msg}}] a été [ANNULÉE].",
            ['mode'] = "DOMINATION",
        },
        ["#accumulatedDomi"] = {
            ['author'] = "",
            ['message'] = "La domination [{{msg1}}] a accumulé [{{msg2}} €]",
            ['mode'] = "DOMINATION",
        },
        ["#domiCompleted"] = {
            ['author'] = "",
            ['message'] = "La domination [{{msg1}}] a été [TERMINÉE] par le groupe [{{msg2}}].",
            ['mode'] = "DOMINATION",
        },
        ["#teamWinEvent"] = {
            ['author'] = "",
            ['message'] = "L'équipe {{msg1}} a remporté l'événement {{msg2}}.",
            ['mode'] = "FFA",
        },
        ["#statusWar"] = {
            ['author'] = "GUERRE",
            ['message'] = "{{msg1}} {{msg2}} x {{msg3}} {{msg4}}",
            ['mode'] = "GUERRE",
        },
        ["#boughtCar"] = {
            ['author'] = "ID : ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} a acheté la voiture {{msg4}} chez le concessionnaire.",
            ['mode'] = "🚗 Concession",
        },
        ["#contratOrg"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Panneau",
        },
        ["#megaPhone"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "📢 Mégaphone",
        },
        ["#breakupNotice"] = {
            ['author'] = "",
            ['message'] = "Coucou ! Apparemment {{msg1}} {{msg2}} vient de rompre avec {{msg3}} {{msg4}}. C'est le moment d'aller prendre des nouvelles en MP.",
            ['mode'] = "🤲 Relation",
        },
        ["#algumNome"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#chatBlack"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatPuroPrime"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatTutor"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatDefault"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome2"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome3"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#gotCard"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "A tiré {{msg3}}{{msg4}} du jeu.",
            ['mode'] = "jeu",
        },
        ["#gotCard2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "A tiré {{msg3}}{{msg4}} du jeu.",
            ['mode'] = "jeu",
        },
        ["#slideCoin"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "jeu",
        },
        ["#slideCoin2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "jeu",
        },
        ["#policeServ"] = {
            ['author'] = "{{msg1}} | {{msg2}} ",
            ['message'] = "{{msg3}}",
            ['mode'] = "appel",
        },
        ["#beguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "Un débutant vient d'entrer en ville, ID : {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Débutant",
        },
    },
    ["es-es"] = {
        ["#applyBan"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg8}}h fue baneado. | Razón: {{msg4}} | Descripción: {{msg5}} | Por: {{msg6}} | {{msg7}} [{{msg9}}]",
            ['mode'] = "🚫Baneo",
        },
        ["#applyBan2"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg7}}h fue baneado. | Razón: {{msg4}} | Descripción: {{msg5}} | Por: {{msg5}} | {{msg6}} [{{msg8}}]",
            ['mode'] = "🚫Baneo",
        },
        ["#consoleCommand"] = {
            ['author'] = "ID: ",
            ['message'] = "{{msg1}}", 
            ['mode'] = "aviso",  
        },
        ["#warningNoti"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} {{msg3}} | {{msg9}}h fue advertido. | Por: {{msg4}} minutos. | Motivo: {{msg5}} | Descripción: {{msg6}} | Por: {{msg7}} | {{msg8}} [{{msg10}}}",
            ['mode'] = "🚫 Advertencia",
        },
        ["#remAdv"] = {
            ['author'] = "",
            ['message'] = "Pasaporte: {{msg1}} | {{msg2}} retiró adv de {{msg3}} | {{msg4}}",
            ['mode'] = "⛔️ RemAdv",
        },
        ["#vipStoree"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#arrivedNow"] = {
            ['author'] = "¿Acabas de llegar?",
            ['message'] = "{{msg}}",
            ['mode'] = "👑 SÉ LÍDER",
        },
        ["#playerKStreak"] = {
            ['author'] = "Jugador",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} Tiene una racha de {{msg4}} kills.",
            ['mode'] = "arena",
        },
        ["#playerKStreakStop"] = {
            ['author'] = "Jugador",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} Tiene una racha de {{msg4}} kills, ¿Será que alguien puede parar esta máquina?",
            ['mode'] = "arena",
        },
        ["#ffaMap1Min"] = {
            ['author'] = "",
            ['message'] = "El mapa del FFA va a cambiar en 1 minuto",
            ['mode'] = "FFA",
        },
        ["#ffaMap3Min"] = {
            ['author'] = "",
            ['message'] = "El mapa del FFA va a cambiar en 3 minutos",
            ['mode'] = "FFA",
        },
        ["#ffaMap5Min"] = {
            ['author'] = "",
            ['message'] = "El mapa del FFA va a cambiar en 5 minutos",
            ['mode'] = "FFA",
        },
        ["#playerWinFfa"] = {
            ['author'] = "",
            ['message'] = "El ID [{{msg1}}] {{msg2}} acaba de ganar el FFA {{msg3}} con {{msg4}} Kills",
            ['mode'] = "FFA",
        },
        ["#playerOneKStreak"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} Tiene una racha de {{msg4}} kills, ¿el equipo Telagem está conectado?",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakCall"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} Tiene una racha de {{msg4}} kills, llamad al Equipo Telagem",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakPuro"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} Tiene una racha de {{msg4}} kills, ¡seguro que no está limpio!",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakTelem"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} Tiene una racha de {{msg4}} kills, ¡teletransportadle urgente!!!",
            ['mode'] = "arena",
        },
        ["#bguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "Acaba de entrar un principiante en la ciudad, ID: {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Principiante",
        },
        ["#admReport"] = {
            ['author'] = "Administrador",
            ['message'] = "{{msg}}",
            ['mode'] = "Denuncias",
        },
        ["#admTicket"] = {
            ['author'] = "Administrador",
            ['message'] = "{{msg}}",
            ['mode'] = "Tickets",
        },
        ["#playerAhiv"] = {
            ['author'] = "El Jugador: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} completó el logro [{{msg4}}]",
            ['mode'] = "",
        },
        ["#aliasOrgani"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Panel",
        },
        ["#startRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} empezó a salir con {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relación",
        },
        ["#startEngaged"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} se comprometió con {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relación",
        },
        ["#startMarried"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} se casó con {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relación",
        },
        ["#endRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} y {{msg3}} {{msg4}} se separaron, ya podéis mandar un Hola desconocido(a)",
            ['mode'] = "🤲 Relación",
        },
        ["#newStartRelationship"] = {
            ['author'] = "",
            ['message'] = "💙 {{msg1}} {{msg2}} empezó a salir con {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relación",
        },
        ["#newStartEngaged"] = {
            ['author'] = "",
            ['message'] = "💍 {{msg1}} {{msg2}} se comprometió con {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relación",
        },
        ["#newStartMarried"] = {
            ['author'] = "",
            ['message'] = "🕊 {{msg1}} {{msg2}} & {{msg3}} {{msg4}} se casaron! Que su unión sea eterna! 💞",
            ['mode'] = "❤️ Relación",
        },
        ["#newEndRelationship"] = {
            ['author'] = "",
            ['message'] = "💔 {{msg1}} {{msg2}} y {{msg3}} {{msg4}} ya no están juntos. ¿Alguien para consolar en privado?",
            ['mode'] = "🤲 Relación",
        },
        ["#newCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "🐂 Oye {{msg1}} {{msg2}} cornudo(a), {{msg3}} {{msg4}} está intentando engañarte. {{msg1}} {{msg2}} empezó a salir con {{msg5}} {{msg6}}.",
            ['mode'] = "🐂 Relación",
        },
        ["#cheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Oye {{msg1}} {{msg2}} cornudo(a), {{msg3}} {{msg4}} está intentando engañarte.",
            ['mode'] = "🐂 Relación",
        },
        ["#tryCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Oye {{msg1}} {{msg2}} cornudo(a), {{msg3}} {{msg4}} intentó ponerte los cuernos.",
            ['mode'] = "🐂 Relación",
        },
        ["#flirtingAlert"] = {
            ['author'] = "",
            ['message'] = "¡Hola {{msg1}} {{msg2}}, ten cuidado! {{msg3}} {{msg4}} está coqueteando con {{msg5}} {{msg6}}",
            ['mode'] = "💔 Relación",
        },
        ["#lojaVip"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🏷️ TIENDA VIP",
        },
        ["#theDomi"] = {
            ['author'] = "",
            ['message'] = "LA DOMINACIÓN [{{msg1}}] Fue [INICIADA] por el grupo {{msg2}} por valor de [€{{msg3}}]",
            ['mode'] = "DOMINACIÓN",
        },
        ["#cancelDomi"] = {
            ['author'] = "",
            ['message'] = "LA DOMINACIÓN [{{msg}}] fue [CANCELADA].",
            ['mode'] = "DOMINACIÓN",
        },
        ["#accumulatedDomi"] = {
            ['author'] = "",
            ['message'] = "LA DOMINACIÓN [{{msg1}}] está acumulada en [€ {{msg2}}]",
            ['mode'] = "DOMINACIÓN",
        },
        ["#domiCompleted"] = {
            ['author'] = "",
            ['message'] = "LA DOMINACIÓN [{{msg1}}] fue [COMPLETADA] por el grupo [{{msg2}}].",
            ['mode'] = "DOMINACIÓN",
        },
        ["#teamWinEvent"] = {
            ['author'] = "",
            ['message'] = "El equipo {{msg1}} ganó el evento {{msg2}}.",
            ['mode'] = "FFA",
        },
        ["#statusWar"] = {
            ['author'] = "GUERRA",
            ['message'] = "{{msg1}} {{msg2}} x {{msg3}} {{msg4}}",
            ['mode'] = "GUERRA",
        },
        ["#boughtCar"] = {
            ['author'] = "ID: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} compró el coche {{msg4}} en el concesionario.",
            ['mode'] = "🚗Concesionario",
        },
        ["#contratOrg"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Panel",
        },
        ["#megaPhone"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "📢 Megáfono",
        },
        ["#breakupNotice"] = {
            ['author'] = "",
            ['message'] = "¡Hola desconocido(a)! Aparentemente {{msg1}} {{msg2}} acaba de separarse de {{msg3}} {{msg4}}. Es hora de preguntar si está todo bien en el MD de Insta.",
            ['mode'] = "🤲 Relación",
        },
        ["#algumNome"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#chatBlack"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatPuroPrime"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatTutor"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatDefault"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome2"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome3"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#gotCard"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Sacó {{msg3}}{{msg4}} de la baraja.",
            ['mode'] = "juego",
        },
        ["#gotCard2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Sacó {{msg3}}{{msg4}} de la baraja.",
            ['mode'] = "juego",
        },
        ["#slideCoin"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "juego",
        },
        ["#slideCoin2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "juego",
        },
        ["#policeServ"] = {
            ['author'] = "{{msg1}} | {{msg2}} ",
            ['message'] = "{{msg3}}",
            ['mode'] = "llamada",
        },
        ["#beguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "Acaba de entrar un principiante en la ciudad, ID: {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Principiante",
        },
    },
    ["pt-pt"] = {
        ["#applyBan"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} {{msg3}} | {{msg8}}h foi banido. | Motivo: {{msg4}} | Descrição: {{msg5}} | Por: {{msg6}} | {{msg7}} [{{msg9}}]",
            ['mode'] = "🚫Ban",
        },
        ["#applyBan2"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg7}}h foi banido. | Motivo: {{msg4}} | Descrição: {{msg5}} | Por: {{msg5}} | {{msg6}} [{{msg8}}]",
            ['mode'] = "🚫 Ban",
        },
        ["#consoleCommand"] = {
            ['author'] = "ID: ",
            ['message'] = "{{msg1}}", 
            ['mode'] = "aviso",  
        },
        ["#warningNoti"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} {{msg3}} | {{msg9}}h foi advertido. | Por: {{msg4}} minutos. | Motivo: {{msg5}} | Descrição: {{msg6}} | Por: {{msg7}} | {{msg8}} [{{msg10}}",
            ['mode'] = "🚫 Advertência",
        },
        ["#remAdv"] = {
            ['author'] = "",
            ['message'] = "Passaporte: {{msg1}} | {{msg2}} removeu advertência de {{msg3}} | {{msg4}}",
            ['mode'] = "⛔️ RemAdv",
        },
        ["#vipStoree"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#arrivedNow"] = {
            ['author'] = "Acabou de chegar?",
            ['message'] = "{{msg}}",
            ['mode'] = "👑 SEJA LÍDER",
        },
        ["#playerKStreak"] = {
            ['author'] = "Jogador",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} está com uma sequência de {{msg4}} eliminações.",
            ['mode'] = "arena",
        },
        ["#playerKStreakStop"] = {
            ['author'] = "Jogador",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} está com uma sequência de {{msg4}} eliminações, será que alguém consegue parar esta máquina?",
            ['mode'] = "arena",
        },
        ["#ffaMap1Min"] = {
            ['author'] = "",
            ['message'] = "O mapa do FFA vai mudar em 1 minuto",
            ['mode'] = "FFA",
        },
        ["#ffaMap3Min"] = {
            ['author'] = "",
            ['message'] = "O mapa do FFA vai mudar em 3 minutos",
            ['mode'] = "FFA",
        },
        ["#ffaMap5Min"] = {
            ['author'] = "",
            ['message'] = "O mapa do FFA vai mudar em 5 minutos",
            ['mode'] = "FFA",
        },
        ["#playerWinFfa"] = {
            ['author'] = "",
            ['message'] = "O ID [{{msg1}}] {{msg2}} acabou de vencer o FFA {{msg3}} com {{msg4}} eliminações",
            ['mode'] = "FFA",
        },
        ["#playerOneKStreak"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} está com uma sequência de {{msg4}} eliminações, a equipa SS está online?",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakCall"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} está com uma sequência de {{msg4}} eliminações, chamem a equipa de SS",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakPuro"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} está com uma sequência de {{msg4}} eliminações, de certeza que não está a fazer batota?",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakTelem"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} está com uma sequência de {{msg4}} eliminações, teletransportem-no urgente!!!",
            ['mode'] = "arena",
        },
        ["#bguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "Acabou de entrar um principiante na cidade, ID: {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Principiante",
        },
        ["#admReport"] = {
            ['author'] = "Administrador",
            ['message'] = "{{msg}}",
            ['mode'] = "Denúncias",
        },
        ["#admTicket"] = {
            ['author'] = "Administrador",
            ['message'] = "{{msg}}",
            ['mode'] = "Chamados",
        },
        ["#playerAhiv"] = {
            ['author'] = "O Jogador: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} concluiu a conquista [{{msg4}}]",
            ['mode'] = "",
        },
        ["#aliasOrgani"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Painel",
        },
        ["#startRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} começou a namorar com {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#startEngaged"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} ficou noivo de {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#startMarried"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} casou-se com {{msg3}} {{msg4}}",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#endRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} e {{msg3}} {{msg4}} separaram-se, já podem mandar um olá desaparecido(a)",
            ['mode'] = "🤲 Relacionamento",
        },
        ["#newStartRelationship"] = {
            ['author'] = "",
            ['message'] = "💙 {{msg1}} {{msg2}} e {{msg3}} {{msg4}} começaram a namorar! Felicidades ao novo casal!",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#newStartEngaged"] = {
            ['author'] = "",
            ['message'] = "💍 {{msg1}} {{msg2}} pediu {{msg3}} {{msg4}} em NOIVADO e recebeu um SIM!",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#newStartMarried"] = {
            ['author'] = "",
            ['message'] = "🕊 {{msg1}} {{msg2}} & {{msg3}} {{msg4}} se CASARAM! Que a união seja eterna! 💞",
            ['mode'] = "❤️ Relacionamento",
        },
        ["#newEndRelationship"] = {
            ['author'] = "",
            ['message'] = "💔 {{msg1}} {{msg2}} e {{msg3}} {{msg4}} NÃO estão mais juntos. Alguém pra consolar no privado?",
            ['mode'] = "🤲 Relacionamento",
        },
        ["#newCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "🐂 Opa Opa, {{msg1}} {{msg2}} está TRAINDO {{msg3}} {{msg4}}. {{msg1}} {{msg2}} Começou uma nova relação com {{msg5}} {{msg6}}.",
            ['mode'] = "🐂 Relacionamento",
        },
        ["#cheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Olá {{msg1}} {{msg2}} cornudo(a), {{msg3}} {{msg4}} está a tentar trair-te.",
            ['mode'] = "🐂 Relacionamento",
        },
        ["#tryCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Olá {{msg1}} {{msg2}} cornudo(a), {{msg3}} {{msg4}} tentou trair-te.",
            ['mode'] = "🐂 Relacionamento",
        },
        ["#flirtingAlert"] = {
            ['author'] = "",
            ['message'] = "Olá {{msg1}} {{msg2}}, fica atento! {{msg3}} {{msg4}} está a dar em cima de {{msg5}} {{msg6}}",
            ['mode'] = "💔 Relacionamento",
        },
        ["#lojaVip"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🏷️ LOJA VIP",
        },
        ["#theDomi"] = {
            ['author'] = "",
            ['message'] = "A DOMINAÇÃO [{{msg1}}] foi [INICIADA] pelo grupo {{msg2}} no valor de [€{{msg3}}]",
            ['mode'] = "DOMINAÇÃO",
        },
        ["#cancelDomi"] = {
            ['author'] = "",
            ['message'] = "A DOMINAÇÃO [{{msg}}] foi [CANCELADA].",
            ['mode'] = "DOMINAÇÃO",
        },
        ["#accumulatedDomi"] = {
            ['author'] = "",
            ['message'] = "A DOMINAÇÃO [{{msg1}}] está acumulada em [€ {{msg2}}]",
            ['mode'] = "DOMINAÇÃO",
        },
        ["#domiCompleted"] = {
            ['author'] = "",
            ['message'] = "A DOMINAÇÃO [{{msg1}}] foi [CONCLUÍDA] pelo grupo [{{msg2}}].",
            ['mode'] = "DOMINAÇÃO",
        },
        ["#teamWinEvent"] = {
            ['author'] = "",
            ['message'] = "A equipa {{msg1}} venceu o evento {{msg2}}.",
            ['mode'] = "FFA",
        },
        ["#statusWar"] = {
            ['author'] = "GUERRA",
            ['message'] = "{{msg1}} {{msg2}} x {{msg3}} {{msg4}}",
            ['mode'] = "GUERRA",
        },
        ["#boughtCar"] = {
            ['author'] = "ID: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} comprou o carro {{msg4}} no stand.",
            ['mode'] = "🚗Stand",
        },
        ["#contratOrg"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Painel",
        },
        ["#megaPhone"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "📢 Megafone",
        },
        ["#breakupNotice"] = {
            ['author'] = "",
            ['message'] = "Olá desaparecido(a)! Aparentemente {{msg1}} {{msg2}} acabou de se separar de {{msg3}} {{msg4}}. É altura de perguntar se está tudo bem por mensagem privada no Instagram.",
            ['mode'] = "🤲 Relacionamento",
        },
        ["#algumNome"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#chatBlack"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatPuroPrime"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatTutor"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatDefault"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome2"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome3"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#gotCard"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Tirou {{msg3}}{{msg4}} do baralho.",
            ['mode'] = "jogo",
        },
        ["#gotCard2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Tirou {{msg3}}{{msg4}} do baralho.",
            ['mode'] = "jogo",
        },
        ["#slideCoin"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "jogo",
        },
        ["#slideCoin2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "jogo",
        },
        ["#policeServ"] = {
            ['author'] = "{{msg1}} | {{msg2}} ",
            ['message'] = "{{msg3}}",
            ['mode'] = "chamado",
        },
        ["#beguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "Acabou de entrar um principiante na cidade, ID: {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Principiante",
        },
    },

    ["de-de"] = {
        ["#applyBan"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg8}}h wurde gebannt. | Grund: {{msg4}} | Beschreibung: {{msg5}} | Von: {{msg6}} | {{msg7}} [{{msg9}}]",
            ['mode'] = "🚫 Ban",
        },
        ["#applyBan2"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg7}}h wurde gebannt. | Grund: {{msg4}} | Beschreibung: {{msg5}} | Von: {{msg5}} | {{msg6}} [{{msg8}}]",
            ['mode'] = "🚫 Ban",
        },
        ["#consoleCommand"] = {
            ['author'] = "ID: ",
            ['message'] = "{{msg1}}",
            ['mode'] = "warning",
        },
        ["#warningNoti"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} {{msg3}} | {{msg9}}h wurde verwarnt. | Dauer: {{msg4}} Minuten. | Grund: {{msg5}} | Beschreibung: {{msg6}} | Von: {{msg7}} | {{msg8}} [{{msg10}}]",
            ['mode'] = "🚫 Verwarnung",
        },
        ["#remAdv"] = {
            ['author'] = "",
            ['message'] = "Pass: {{msg1}} | {{msg2}} hat die Verwarnung von {{msg3}} | {{msg4}} entfernt.",
            ['mode'] = "⛔️ RemoveAdv",
        },
        ["#vipStoree"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#arrivedNow"] = {
            ['author'] = "Gerade angekommen?",
            ['message'] = "{{msg}}",
            ['mode'] = "👑 SEI EIN LEADER",
        },
        ["#playerKStreak"] = {
            ['author'] = "Spieler",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} hat eine Kill-Serie von {{msg4}}.",
            ['mode'] = "arena",
        },
        ["#playerKStreakStop"] = {
            ['author'] = "Spieler",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} hat eine Kill-Serie von {{msg4}}, kann jemand diese Maschine stoppen?",
            ['mode'] = "arena",
        },
        ["#ffaMap1Min"] = {
            ['author'] = "",
            ['message'] = "Die FFA-Karte wechselt in 1 Minute",
            ['mode'] = "FFA",
        },
        ["#ffaMap3Min"] = {
            ['author'] = "",
            ['message'] = "Die FFA-Karte wechselt in 3 Minuten",
            ['mode'] = "FFA",
        },
        ["#ffaMap5Min"] = {
            ['author'] = "",
            ['message'] = "Die FFA-Karte wechselt in 5 Minuten",
            ['mode'] = "FFA",
        },
        ["#playerWinFfa"] = {
            ['author'] = "",
            ['message'] = "ID [{{msg1}}] {{msg2}} hat gerade das FFA {{msg3}} mit {{msg4}} Kills gewonnen",
            ['mode'] = "FFA",
        },
        ["#playerOneKStreak"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} hat eine Kill-Serie von {{msg4}}, ist das ScreenShare-Team da?",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakCall"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} hat eine Kill-Serie von {{msg4}}, ruft das ScreenShare-Team",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakPuro"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} hat eine Kill-Serie von {{msg4}}, ist das wirklich clean?",
            ['mode'] = "arena",
        },
        ["#playerOneKStreakTelem"] = {
            ['author'] = "",
            ['message'] = "ID: [{{msg1}}] {{msg2}} {{msg3}} hat eine Kill-Serie von {{msg4}}, sofort teleportieren!!!",
            ['mode'] = "arena",
        },
        ["#beguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "Ein Anfänger ist gerade in die Stadt gekommen, ID: {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 Anfänger",
        },
        ["#admReport"] = {
            ['author'] = "Administrator",
            ['message'] = "{{msg}}",
            ['mode'] = "Meldungen",
        },
        ["#admTicket"] = {
            ['author'] = "Administrator",
            ['message'] = "{{msg}}",
            ['mode'] = "Tickets",
        },
        ["#playerAhiv"] = {
            ['author'] = "Spieler: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} hat den Erfolg [{{msg4}}] abgeschlossen",
            ['mode'] = "",
        },
        ["#aliasOrgani"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Panel",
        },
        ["#startRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} ist jetzt mit {{msg3}} {{msg4}} zusammen",
            ['mode'] = "❤️ Beziehung",
        },
        ["#startEngaged"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} hat sich mit {{msg3}} {{msg4}} verlobt",
            ['mode'] = "❤️ Beziehung",
        },
        ["#startMarried"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} hat {{msg3}} {{msg4}} geheiratet",
            ['mode'] = "❤️ Beziehung",
        },
        ["#endRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} und {{msg3}} {{msg4}} haben sich getrennt, du kannst der Ex jetzt Hallo sagen!",
            ['mode'] = "🤲 Beziehung",
        },
        ["#newStartRelationship"] = {
            ['author'] = "",
            ['message'] = "💙 {{msg1}} {{msg2}} und {{msg3}} {{msg4}} sind jetzt zusammen! Glückwunsch an das neue Paar!",
            ['mode'] = "❤️ Beziehung",
        },
        ["#newStartEngaged"] = {
            ['author'] = "",
            ['message'] = "💍 {{msg1}} {{msg2}} hat sich mit {{msg3}} {{msg4}} verlobt!",
            ['mode'] = "❤️ Beziehung",
        },
        ["#newStartMarried"] = {
            ['author'] = "",
            ['message'] = "🕊 {{msg1}} {{msg2}} & {{msg3}} {{msg4}} haben GEHEIRATET! Möge ihre Verbindung ewig sein! 💞",
            ['mode'] = "❤️ Beziehung",
        },
        ["#newEndRelationship"] = {
            ['author'] = "",
            ['message'] = "💔 {{msg1}} {{msg2}} und {{msg3}} {{msg4}} sind nicht mehr zusammen. Jemand zum Trösten per PN?",
            ['mode'] = "🤲 Beziehung",
        },
        ["#newCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "🐂 Hey {{msg1}} {{msg2}} Betrüger, {{msg3}} {{msg4}} versucht dich zu betrügen. {{msg1}} {{msg2}} hat eine neue Beziehung mit {{msg5}} {{msg6}} angefangen.",
            ['mode'] = "🐂 Beziehung",
        },
        ["#cheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Hallo {{msg1}} {{msg2}} Betrüger, {{msg3}} {{msg4}} versucht dich zu betrügen.",
            ['mode'] = "🐂 Beziehung",
        },
        ["#tryCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "Hallo {{msg1}} {{msg2}} Betrüger, {{msg3}} {{msg4}} hat versucht dich zu betrügen.",
            ['mode'] = "🐂 Beziehung",
        },
        ["#flirtingAlert"] = {
            ['author'] = "",
            ['message'] = "Hallo {{msg1}} {{msg2}}, Vorsicht! {{msg3}} {{msg4}} flirten mit {{msg5}} {{msg6}}",
            ['mode'] = "💔 Beziehung",
        },
        ["#lojaVip"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🏷️ VIP-SHOP",
        },
        ["#theDomi"] = {
            ['author'] = "",
            ['message'] = "Die DOMINATION [{{msg1}}] wurde von der Gruppe {{msg2}} für [{{msg3}}€] [GESTARTET]",
            ['mode'] = "DOMINATION",
        },
        ["#cancelDomi"] = {
            ['author'] = "",
            ['message'] = "Die DOMINATION [{{msg}}] wurde [ABGESAGT].",
            ['mode'] = "DOMINATION",
        },
        ["#accumulatedDomi"] = {
            ['author'] = "",
            ['message'] = "Die DOMINATION [{{msg1}}] hat [{{msg2}}€] angesammelt",
            ['mode'] = "DOMINATION",
        },
        ["#domiCompleted"] = {
            ['author'] = "",
            ['message'] = "Die DOMINATION [{{msg1}}] wurde von der Gruppe [{{msg2}}] [ABGESCHLOSSEN].",
            ['mode'] = "DOMINATION",
        },
        ["#teamWinEvent"] = {
            ['author'] = "",
            ['message'] = "Das Team {{msg1}} hat das Event {{msg2}} gewonnen.",
            ['mode'] = "FFA",
        },
        ["#statusWar"] = {
            ['author'] = "KRIEG",
            ['message'] = "{{msg1}} {{msg2}} x {{msg3}} {{msg4}}",
            ['mode'] = "WAR",
        },
        ["#boughtCar"] = {
            ['author'] = "ID: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} hat das Fahrzeug {{msg4}} beim Händler gekauft.",
            ['mode'] = "🚗 Händler",
        },
        ["#contratOrg"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 Panel",
        },
        ["#megaPhone"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "📢 Megafon",
        },
        ["#breakupNotice"] = {
            ['author'] = "",
            ['message'] = "Hallo {{msg1}} {{msg2}}, anscheinend haben sich {{msg3}} {{msg4}} gerade getrennt. Zeit nachzufragen ob alles okay ist, PN auf Instagram.",
            ['mode'] = "🤲 Beziehung",
        },
        ["#algumNome"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#chatBlack"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatPuroPrime"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatTutor"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatDefault"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome2"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome3"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#gotCard"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Hat {{msg3}}{{msg4}} vom Stapel gezogen.",
            ['mode'] = "Spiel",
        },
        ["#gotCard2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "Hat {{msg3}}{{msg4}} vom Stapel gezogen.",
            ['mode'] = "Spiel",
        },
        ["#slideCoin"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "Spiel",
        },
        ["#slideCoin2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "Spiel",
        },
        ["#policeServ"] = {
            ['author'] = "{{msg1}} | {{msg2}} ",
            ['message'] = "{{msg3}}",
            ['mode'] = "Anruf",
        },
    },
    ["ar-sa"] = {
        ["#applyBan"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg8}}h تم حظره. | السبب: {{msg4}} | الوصف: {{msg5}} | بواسطة: {{msg6}} | {{msg7}} [{{msg9}}]",
            ['mode'] = "🚫 حظر",
        },
        ["#applyBan2"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} | {{msg7}}h تم حظره. | السبب: {{msg4}} | الوصف: {{msg5}} | بواسطة: {{msg5}} | {{msg6}} [{{msg8}}]",
            ['mode'] = "🚫 حظر",
        },
        ["#consoleCommand"] = {
            ['author'] = "معرف: ",
            ['message'] = "{{msg1}}",
            ['mode'] = "تحذير",
        },
        ["#warningNoti"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} | {{msg2}} {{msg3}} | {{msg9}}h تم تحذيره. | المدة: {{msg4}} دقيقة. | السبب: {{msg5}} | الوصف: {{msg6}} | بواسطة: {{msg7}} | {{msg8}} [{{msg10}}]",
            ['mode'] = "🚫 تحذير",
        },
        ["#remAdv"] = {
            ['author'] = "",
            ['message'] = "جواز السفر: {{msg1}} | {{msg2}} قام بإزالة التحذير من {{msg3}} | {{msg4}}",
            ['mode'] = "⛔️ إزالة التحذير",
        },
        ["#vipStoree"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#arrivedNow"] = {
            ['author'] = "هل وصلت للتو؟",
            ['message'] = "{{msg}}",
            ['mode'] = "👑 كن قائداً",
        },
        ["#playerKStreak"] = {
            ['author'] = "اللاعب",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} في سلسلة قتل من {{msg4}}.",
            ['mode'] = "ساحة المعركة",
        },
        ["#playerKStreakStop"] = {
            ['author'] = "اللاعب",
            ['message'] = "{{msg1}} {{msg2}} {{msg3}} في سلسلة قتل من {{msg4}}، هل يستطيع أحد إيقاف هذه الآلة؟",
            ['mode'] = "ساحة المعركة",
        },
        ["#ffaMap1Min"] = {
            ['author'] = "",
            ['message'] = "ستتغير خريطة FFA خلال دقيقة واحدة",
            ['mode'] = "FFA",
        },
        ["#ffaMap3Min"] = {
            ['author'] = "",
            ['message'] = "ستتغير خريطة FFA خلال 3 دقائق",
            ['mode'] = "FFA",
        },
        ["#ffaMap5Min"] = {
            ['author'] = "",
            ['message'] = "ستتغير خريطة FFA خلال 5 دقائق",
            ['mode'] = "FFA",
        },
        ["#playerWinFfa"] = {
            ['author'] = "",
            ['message'] = "المعرف [{{msg1}}] {{msg2}} فاز للتو بـ FFA {{msg3}} بـ {{msg4}} قتلات",
            ['mode'] = "FFA",
        },
        ["#playerOneKStreak"] = {
            ['author'] = "",
            ['message'] = "المعرف: [{{msg1}}] {{msg2}} {{msg3}} في سلسلة قتل من {{msg4}}، هل فريق فحص الشاشة متاح؟",
            ['mode'] = "ساحة المعركة",
        },
        ["#playerOneKStreakCall"] = {
            ['author'] = "",
            ['message'] = "المعرف: [{{msg1}}] {{msg2}} {{msg3}} في سلسلة قتل من {{msg4}}، اتصلوا بفريق فحص الشاشة",
            ['mode'] = "ساحة المعركة",
        },
        ["#playerOneKStreakPuro"] = {
            ['author'] = "",
            ['message'] = "المعرف: [{{msg1}}] {{msg2}} {{msg3}} في سلسلة قتل من {{msg4}}، هل أنت متأكد أنه نظيف؟",
            ['mode'] = "ساحة المعركة",
        },
        ["#playerOneKStreakTelem"] = {
            ['author'] = "",
            ['message'] = "المعرف: [{{msg1}}] {{msg2}} {{msg3}} في سلسلة قتل من {{msg4}}، انقله على الفور!!!",
            ['mode'] = "ساحة المعركة",
        },
        ["#beguinnerEntered"] = {
            ['author'] = "",
            ['message'] = "لقد دخل مبتدئ إلى المدينة للتو، المعرف: {{msg1}} | {{msg2}}",
            ['mode'] = "🚀 مبتدئ",
        },
        ["#admReport"] = {
            ['author'] = "المسؤول",
            ['message'] = "{{msg}}",
            ['mode'] = "البلاغات",
        },
        ["#admTicket"] = {
            ['author'] = "المسؤول",
            ['message'] = "{{msg}}",
            ['mode'] = "التذاكر",
        },
        ["#playerAhiv"] = {
            ['author'] = "اللاعب: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} أكمل الإنجاز [{{msg4}}]",
            ['mode'] = "",
        },
        ["#aliasOrgani"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 اللوحة",
        },
        ["#startRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} بدأ علاقة مع {{msg3}} {{msg4}}",
            ['mode'] = "❤️ علاقة",
        },
        ["#startEngaged"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} خطب {{msg3}} {{msg4}}",
            ['mode'] = "❤️ علاقة",
        },
        ["#startMarried"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} تزوج من {{msg3}} {{msg4}}",
            ['mode'] = "❤️ علاقة",
        },
        ["#endRelationship"] = {
            ['author'] = "",
            ['message'] = "{{msg1}} {{msg2}} و {{msg3}} {{msg4}} انفصلا، يمكنك الآن إرسال تحية للطرف الآخر!",
            ['mode'] = "🤲 علاقة",
        },
        ["#newStartRelationship"] = {
            ['author'] = "",
            ['message'] = "💙 {{msg1}} {{msg2}} و {{msg3}} {{msg4}} بدأا علاقة! مبروك للزوج الجديد!",
            ['mode'] = "❤️ علاقة",
        },
        ["#newStartEngaged"] = {
            ['author'] = "",
            ['message'] = "💍 {{msg1}} {{msg2}} تقدم لـ {{msg3}} {{msg4}} وقبلت!",
            ['mode'] = "❤️ علاقة",
        },
        ["#newStartMarried"] = {
            ['author'] = "",
            ['message'] = "🕊 {{msg1}} {{msg2}} و {{msg3}} {{msg4}} تزوجا! لتكن علاقتهما أبدية! 💞",
            ['mode'] = "❤️ علاقة",
        },
        ["#newEndRelationship"] = {
            ['author'] = "",
            ['message'] = "💔 {{msg1}} {{msg2}} و {{msg3}} {{msg4}} لم يعودا معاً. هل من شخص للمواساة؟",
            ['mode'] = "🤲 علاقة",
        },
        ["#newCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "🐂 مهلاً {{msg1}} {{msg2}} الخائن، {{msg3}} {{msg4}} يحاول خيانتك. {{msg1}} {{msg2}} بدأ علاقة جديدة مع {{msg5}} {{msg6}}.",
            ['mode'] = "🐂 علاقة",
        },
        ["#cheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "مرحباً {{msg1}} {{msg2}} الخائن، {{msg3}} {{msg4}} يحاول خيانتك.",
            ['mode'] = "🐂 علاقة",
        },
        ["#tryCheatingRelationship"] = {
            ['author'] = "",
            ['message'] = "مرحباً {{msg1}} {{msg2}} الخائن، {{msg3}} {{msg4}} حاول خيانتك.",
            ['mode'] = "🐂 علاقة",
        },
        ["#flirtingAlert"] = {
            ['author'] = "",
            ['message'] = "مرحباً {{msg1}} {{msg2}}، احذر! {{msg3}} {{msg4}} يغازل {{msg5}} {{msg6}}",
            ['mode'] = "💔 علاقة",
        },
        ["#lojaVip"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🏷️ متجر VIP",
        },
        ["#theDomi"] = {
            ['author'] = "",
            ['message'] = "السيطرة [{{msg1}}] تم [بدءها] من قبل المجموعة {{msg2}} بقيمة [{{msg3}}]",
            ['mode'] = "السيطرة",
        },
        ["#cancelDomi"] = {
            ['author'] = "",
            ['message'] = "السيطرة [{{msg}}] تم [إلغاؤها].",
            ['mode'] = "السيطرة",
        },
        ["#accumulatedDomi"] = {
            ['author'] = "",
            ['message'] = "السيطرة [{{msg1}}] تراكمت بـ [{{msg2}}]",
            ['mode'] = "السيطرة",
        },
        ["#domiCompleted"] = {
            ['author'] = "",
            ['message'] = "السيطرة [{{msg1}}] تم [إكمالها] من قبل المجموعة [{{msg2}}].",
            ['mode'] = "السيطرة",
        },
        ["#teamWinEvent"] = {
            ['author'] = "",
            ['message'] = "الفريق {{msg1}} فاز بالحدث {{msg2}}.",
            ['mode'] = "FFA",
        },
        ["#statusWar"] = {
            ['author'] = "حرب",
            ['message'] = "{{msg1}} {{msg2}} ضد {{msg3}} {{msg4}}",
            ['mode'] = "حرب",
        },
        ["#boughtCar"] = {
            ['author'] = "معرف: ",
            ['message'] = "[{{msg1}}] {{msg2}} {{msg3}} اشترى السيارة {{msg4}} من الوكالة.",
            ['mode'] = "🚗 الوكالة",
        },
        ["#contratOrg"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "🧲 اللوحة",
        },
        ["#megaPhone"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "📢 مكبر الصوت",
        },
        ["#breakupNotice"] = {
            ['author'] = "",
            ['message'] = "مرحباً {{msg1}} {{msg2}}، يبدو أن {{msg3}} {{msg4}} قد انفصلا للتو. حان الوقت للسؤال عما إذا كان كل شيء على ما يرام في الرسائل الخاصة.",
            ['mode'] = "🤲 علاقة",
        },
        ["#algumNome"] = {
            ['author'] = "",
            ['message'] = "{{msg}}",
            ['mode'] = "",
        },
        ["#chatBlack"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatPuroPrime"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatTutor"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#chatDefault"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome2"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#algumNome3"] = {
            ['author'] = "{{msg1}}",
            ['message'] = "{{msg2}}",
            ['mode'] = "{{msg3}}",
        },
        ["#gotCard"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "سحب {{msg3}}{{msg4}} من الرزمة.",
            ['mode'] = "لعبة",
        },
        ["#gotCard2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "سحب {{msg3}}{{msg4}} من الرزمة.",
            ['mode'] = "لعبة",
        },
        ["#slideCoin"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "لعبة",
        },
        ["#slideCoin2"] = {
            ['author'] = "{{msg1}} {{msg2}}",
            ['message'] = "{{msg3}}",
            ['mode'] = "لعبة",
        },
        ["#policeServ"] = {
            ['author'] = "{{msg1}} | {{msg2}} ",
            ['message'] = "{{msg3}}",
            ['mode'] = "مكالمة",
        },
    }

}

function parseString(str,args)
    local parsed = str
    if args then
        for k, v in pairs( args ) do
            parsed = parsed:gsub('{{'..k..'}}',v)
        end
    end
    return parsed
end
