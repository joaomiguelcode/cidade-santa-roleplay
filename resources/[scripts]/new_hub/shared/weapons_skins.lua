cityName = GetConvar("cityName", "")
weapons_rarity = setmetatable({}, {
    __index = function(t, k)
        return rawget(t, "Santa") or rawget(t, "Base") or {
            ["legendary"] = 70,
            ["epic"] = 70,
            ["normal"] = 70,
        }
    end
})
weapons_rarity.Base = {
    ["legendary"] = 70,
    ["epic"] = 70,
    ["normal"] = 70,
}


weapons_rarity.Universo = {
    ["legendary"] = 110,
    ["epic"] = 80,
    ["normal"] = 55,
}

weapons_rarity.CidadeNobre = {
    ["legendary"] = 70,
    ["epic"] = 70,
    ["normal"] = 70,
}

weapons_rarity.Boomerang = {
    ["legendary"] = 110,
    ["epic"] = 80,
    ["normal"] = 55,
}

weapons_rarity.Grande = {
    ["legendary"] = 70,
    ["epic"] = 70,
    ["normal"] = 70,
}

weapons_rarity.Santa = {
    ["legendary"] = 70,
    ["epic"] = 70,
    ["normal"] = 70,
}

weapons_rarity.Maresia = {
    ["legendary"] = 70,
    ["epic"] = 70,
    ["normal"] = 70,
}

weapons_rarity.Alexandria = {
    ["legendary"] = 110,
    ["epic"] = 80,
    ["normal"] = 55,
}

weapons_rarity.Malta = {
    ["legendary"] = 20,
    ["epic"] = 15,
    ["normal"] = 10,
}

-- !Todo: AJUSTAR VALORES
weapons_rarity.Kingdom = {
    ["legendary"] = 40,
    ["epic"] = 30,
    ["normal"] = 15,
}
weapons_rarity.District99 = {
    ["legendary"] = 40,
    ["epic"] = 30,
    ["normal"] = 15,
}
weapons_rarity.Krown = {
    ["legendary"] = 0,
    ["epic"] = 0,
    ["normal"] = 0,
}
weapons_rarity.Orizon = {
    ["legendary"] = 0,
    ["epic"] = 0,
    ["normal"] = 0,
}
weapons_rarity.Liberty99 = {
    ["legendary"] = 0,
    ["epic"] = 0,
    ["normal"] = 0,
}
weapons_rarity.GoatRP = {
    ["legendary"] = 12,
    ["epic"] = 12,
    ["normal"] = 12,
}
weapons_rarity.Royal = {
    ["legendary"] = 40,
    ["epic"] = 30,
    ["normal"] = 15,
}

weapons_rarity.Boomerang = {
    ["legendary"] = 60,
    ["epic"] = 45,
    ["normal"] = 23,
}

weapons_rarity.Real = {
    ["legendary"] = 40,
    ["epic"] = 30,
    ["normal"] = 15,
}
weapons_rarity.Prime = {
    ["legendary"] = 40,
    ["epic"] = 30,
    ["normal"] = 15,
}

weapons_rarity.Fronteira = {
    ["legendary"] = 30,
    ["epic"] = 30,
    ["normal"] = 30,
}

weapons_skins = {
    ["WEAPON_ASSAULTRIFLE_MK2"] = {
        {
            name = "GOLD",
            description = "A skin Gold do Assault Rifle é o troféu definitivo dos chefões do crime. Banhada a ouro puro com gravuras detalhadas e coronha em madeira nobre escura, esta skin exala poder e opulência. Mostre quem manda na cidade e faça cada disparo valer um milhão. Ostentação e letalidade em um único armamento.",
            component = "COMPONENT_PL_ASSAULTRIFLE_GOLD",
            customOffset = vec3(0.055, 0.0, -0.16),
            price = weapons_rarity[cityName]["epic"],
            color = 'D4AF37',
            weapon_type = 'rifle'
        },
        {
            name = "AQUA",
            description = "Dê um banho de realidade nos seus adversários com a skin AQUA do Assault Rifle. Com um design descontraído que remete a armamentos de pressão, esta skin esconde um poder letal por trás das cores vibrantes e bolhas. É a peça perfeita para quem mantém a calma sob pressão enquanto domina as ruas da cidade.",
            component = "COMPONENT_PL_ASSAULTRIFLE_AGUA",
            customOffset = vec3(0.0, 0.0, -0.25),
            price = weapons_rarity[cityName]["legendary"],
            color = '00BD35',
            weapon_type = 'rifle'
        },
        {
            name = "GAMER",
            description = "Eleve seu nível no RP com a skin GAMER do Assault Rifle. Com estética retrogamer em tons de neon, botões de console e barras de loading, esta skin transforma cada confronto em uma partida decisiva. No comando da cidade ou da sua facção, mostre que você não está aqui para brincar é o Game Over dos seus inimigos.",
            component = "COMPONENT_PL_ASSAULTRIFLE_GAME",
            customOffset = vec3(0.010, 0.0, -0.16),
            price = weapons_rarity[cityName]["normal"],
            color = '765497',
            weapon_type = 'rifle'
        },
        {
            name = "TOXIC V3",
            description = "Eleve o caos urbano com a skin Toxic V3 do Assault Rifle. Com estampas de quarentena, grafismos de máscaras de gás e um banho de lodo radioativo, esta skin é o pesadelo de qualquer oposição. Ela sinaliza que a área está sob controle biológico e letal. Domine as ruas com um visual corrosivo e implacável.",
            component = "COMPONENT_PL_ASSAULTRIFLE_TOXIC_V3",
            customOffset = vec3(-0.020, 0.0, -0.16),
            price = weapons_rarity[cityName]["epic"],
            color = '21AB25',
            weapon_type = 'rifle'
        },
        {
            name = "UNICORN",
            description = "Traga o deboche para o confronto com a skin UNICORN do Assault Rifle. Com cores pastéis, arco-íris e um chifre frontal, esta skin é para quem não tem medo de ser o centro das atenções enquanto elimina a concorrência. É a assinatura perfeita para o membro da facção que domina com sarcasmo e precisão letal.",
            component = "COMPONENT_PL_ASSAULTRIFLE_UNI",
            customOffset = vec3(0.055, 0.0, -0.16),
            price = weapons_rarity[cityName]["epic"],
            color = 'FF87F9',
            weapon_type = 'rifle'
        },
        {
            name = "BAD RABBIT",
            description = "Espalhe o terror com a skin BAD RABBIT do Assault Rifle. Misturando tons de rosa vibrante com um grafismo insano de coelho psicopata, esta skin é o pesadelo de qualquer oposição. O acabamento com efeitos de tinta escorrendo reforça o visual caótico de quem não segue regras e domina o território com pura agressividade.",
            component = "COMPONENT_PL_ASSAULTRIFLE_PUDDIN_PASCOA",
            customOffset = vec3(0.010, 0.0, -0.16),
            price = weapons_rarity[cityName]["normal"],
            color = 'E75480',
            weapon_type = 'rifle'
        },
        {
            name = "WOLF",
            description = "Domine a noite com a skin WOLF do Assault Rifle. Com uma arte que retrata o uivo sob o luar em tons de azul glacial e roxo, esta skin representa a astúcia e a ferocidade dos lobos solitários. Ideal para membros de facções que operam nas sombras, garantindo que cada disparo ecoe como um aviso de que o predador está à solta.",
            component = "COMPONENT_PL_ASSAULTRIFLE_WOLF",
            customOffset = vec3(0.010, 0.0, -0.16),
            price = weapons_rarity[cityName]["normal"],
            color = '54617E',
            weapon_type = 'rifle'
        },
        {
            name = "ASSAULT RIFLE MK2 DE FERRO",
            component = "WEAPON_ASSAULTRIFLEDEFERRO_RELIKIASHOP",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "ASSAULT RIFLE MK2 TERROR DA PENHA",
            component = "WEAPON_ASSAULTRIFLETERRORDAPENHA",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "ASSAULT RIFLE MK2 PENTE ALONGADO",
            component = "WEAPON_AKPENTEDE90_RELIKIASHOP",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        -- {
        --     name = "ASSAULT RIFLE MK2 PACK 2",
        --     component = "COMPONENT_ASSAULTRIFLE_MK2_PACK_2",
        --     weapon = "WEAPON_ASSAULTRIFLE_MK2_2",
        --     customOffset = vec3(0.0, 0.0, -0.14),
        --     price = weapons_rarity[cityName]["epic"],
        --     color = '15D795',
        --     weapon_type = 'rifle',
        --     custom_weapon = true
        -- },
    },
    ["WEAPON_CARBINERIFLE_MK2"] = {
        {
            name = "ANIME",
            description = "Destaque-se com a skin Anime do Combat Rifle MK2. Misturando tons vibrantes de rosa e verde com ilustrações de estética oriental, esta skin é o equilíbrio perfeito entre o deboche e o poder de fogo. Seja o protagonista da sua facção e domine as ruas com um visual único que impõe respeito através da originalidade e estilo.",
            component = "COMPONENT_PL_CARBINERIFLE_ANIME",
            customOffset = vec3(0.0, 0.0, -0.16),
            price = weapons_rarity[cityName]["epic"],
            color = '2FFF5C',
            weapon_type = 'rifle'
        },
        {
            name = "FADE",
            description = "A skin Fade do Combat Rifle MK2 é a definição de luxo e performance no asfalto. Com um gradiente metálico que transita entre o roxo profundo, rosa vibrante e dourado, esta skin reflete status e autoridade em cada ângulo. É a escolha definitiva para quem já conquistou o topo e quer que todos vejam o brilho da sua vitória enquanto domina o território.",
            component = "COMPONENT_PL_CARBINERIFLE_FADE",
            customOffset = vec3(0.0, 0.0, -0.18),
            price = weapons_rarity[cityName]["epic"],
            color = '8E02CE',
            weapon_type = 'rifle'
        },
        {
            name = "BLOCKS",
            description = "Construa sua vitória peça por peça com a skin BLOCKS do Combat Rifle MK2. Com um visual inspirado em blocos de montar coloridos e uma textura que simula o encaixe de brinquedos, esta skin traz um ar lúdico e nostálgico para o combate. É a escolha ideal para quem gosta de \"brincar\" com a sorte dos adversários enquanto mantém uma precisão cirúrgica no controle do mapa.",
            component = "COMPONENT_PL_CARBINERIFLE_BLOCKS",
            customOffset = vec3(0.050, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            color = '9F383B',
            weapon_type = 'rifle'
        },
        {
            name = "MEDIC",
            description = "A skin MEDIC do Combat Rifle MK2 é o equipamento essencial para quem opera na linha de frente do suporte. Com um design clínico em branco e verde água, a skin apresenta detalhes de monitor cardíaco, selos de \"Lifeline Support\" e uma textura hexagonal moderna. Ela é a escolha perfeita para unidades de resgate ou combatentes que priorizam a sobrevivência do grupo, garantindo que a ordem seja mantida com precisão e estilo profissional.",
            component = "COMPONENT_PL_CARBINERIFLE_MEDIC",
            customOffset = vec3(0.0, 0.0, -0.18),
            price = weapons_rarity[cityName]["epic"],
            color = '068B73',
            weapon_type = 'rifle'
        },
        {
            name = "TOXIC V1",
            description = "A skin TOXIC V1 do Combat Rifle MK2 é a escolha definitiva para quem opera em zonas de exclusão e cenários de combate químico. Com um padrão de camuflagem desgastado em tons de amarelo e preto, esta skin destaca-se pelos tubos externos que injetam uma substância neon brilhante diretamente no mecanismo da arma. Ela simboliza o perigo radioativo e a resistência bruta, ideal para facções que dominam territórios industriais ou pós-apocalípticos com uma presença intimidadora e letal.",
            component = "COMPONENT_PL_CARBINERIFLE_MK2_TOXIC",
            customOffset = vec3(0.050, 0.0, -0.16),
            price = weapons_rarity[cityName]["legendary"],
            color = 'B58E40',
            weapon_type = 'rifle'
        },
        {
            name = "LOVE",
            description = "A skin LOVE do Combat Rifle MK2 traz um contraste irônico e marcante para o campo de batalha, combinando a precisão de uma arma de elite com uma estética vibrante e carinhosa. Com um corpo decorado por diversos corações em tons de rosa e detalhes em roxo com padrões de bolinhas, esta skin é a escolha perfeita para quem deseja marcar sua presença com estilo e uma dose de deboche. Mostre que até nos confrontos mais intensos das facções, há espaço para um visual apaixonante e letal.",
            component = "COMPONENT_PL_CARBINERIFLE_ROSA",
            customOffset = vec3(0.0, 0.0, -0.18),
            price = weapons_rarity[cityName]["legendary"],
            color = 'D97ED7',
            weapon_type = 'rifle'
        },
        {
            name = "GAMER",
            description = "Domine a partida com a skin GAMER do Combat Rifle MK2, feita para transformar o campo de batalha em um verdadeiro fliperama de alta performance. Com um acabamento em tons vibrantes de rosa e roxo, esta arma apresenta detalhes nostálgicos como botões de controle, uma tela de \"Insert Coin\" e adesivos de \"Level Up\". Ela é a escolha ideal para o combatente que encara cada confronto como um desafio estratégico, garantindo que você esteja sempre um nível à frente dos seus adversários com muito estilo e personalidade.",
            component = "COMPONENT_PL_CARBINERIFLE_GAME",
            customOffset = vec3(0.070, 0.0, -0.16),
            price = weapons_rarity[cityName]["legendary"],
            color = 'A454C4',
            weapon_type = 'rifle'
        },
        {
            name = "CUPID",
            description = "Faça cada disparo atingir o coração com a skin CUPID do Combat Rifle MK2. Com tons de rosa e roxo, traz um Cupido e a mensagem \"Te amo\". É o deboche perfeito: prove que o confronto mais intenso pode ter um visual apaixonante e letal.",
            component = "COMPONENT_PL_CARBINERIFLE_LOVE",
            customOffset = vec3(0.070, 0.0, -0.16),
            price = weapons_rarity[cityName]["normal"],
            color = 'E1749C',
            weapon_type = 'rifle'
        },
        {
            name = "CARBINE RIFLE MK2 CPX",
            component = "WEAPON_RIFLEPRETO_RELIKIASHOP",
            customOffset = vec3(0.0, 0.02, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 TROIA",
            component = "WEAPON_RIFLEBEGE_RELIKIASHOP",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 FOGAO",
            component = "WEAPON_RIFLEBOTA",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 BTL",
            component = "WEAPON_RIFLEDUBTL",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 LUNETA",
            component = "WEAPON_RIFLEDELUNETA_RELIKIASHOP",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 SEM FREIO",
            component = "WEAPON_RIFLEFLA",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 FLA",
            component = "WEAPON_RIFLEFLA2",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 FLU",
            component = "WEAPON_RIFLEFLU",
            customOffset = vec3(0.0, 0.0, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 LUNETA PRATA",
            component = "WEAPON_RIFLELUNETAPRATA",
            customOffset = vec3(0.0, 0.02, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 MILITAR",
            component = "WEAPON_RIFLEMILI",
            customOffset = vec3(0.0, 0.02, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 ALTA",
            component = "WEAPON_RIFLETERRORDAALTA",
            customOffset = vec3(0.0, 0.02, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "CARBINE RIFLE MK2 GAMA",
            component = "WEAPON_RIFLEVA",
            customOffset = vec3(0.0, 0.02, -0.14),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
    },
    ["WEAPON_SPECIALCARBINE_MK2"] = {
        {
            name = "ULTRAVIOLET",
            description = "Domine o campo de batalha com a Skin ULTRAVIOLET, uma fusão eletrizante de estilo e tecnologia de ponta. Seu acabamento em gradiente púrpura neon e azul ciano simula a radiação de espectro total, garantindo uma presença imponente sob qualquer iluminação. Detalhes em polímero fosco contrastam com as marcações de energia ativa, conferindo um visual de protótipo experimental de alta frequência. Ideal para operadores que buscam precisão com um toque de letalidade futurista.",
            component = "COMPONENT_BATTLERIFLE_PENHASHOP_04",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["normal"],
            color = 'AE05A3',
            weapon_type = 'rifle'
        },
        {
            name = "SPECIAL CARBINE MK2 PRN",
            component = "COMPONENT_SPECIALCARBINE_PRN",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["normal"],
            private = true,
            weapon_type = 'rifle'
        },
        {
            name = "SPECIAL CARBINE MK2 MEXICO",
            component = "COMPONENT_SPECIALCARBINEMK2_MEXICO",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["normal"],
            private = true,
            weapon_type = 'rifle'
        },
        {
            name = "ANIME",
            description = "Prepare-se para deixar sua marca no campo de batalha com a Skin ANIME, uma expressão vibrante de estilo e cultura pop. Seu design exclusivo combina tons pastéis de roxo e rosa com ilustrações detalhadas de personagens icônicos, criando um visual impactante e cheio de energia. Inscrições em japonês e grafismos dinâmicos complementam o acabamento, garantindo que você se destaque como um verdadeiro protagonista. Uma escolha audaciosa para quem busca originalidade.",
            component = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_ANIME",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["epic"],
            color = '9883F7',
            weapon_type = 'rifle'
        },
        {
            name = "BIO-WAR",
            description = "Imponha medo nas ruas com a BIO-WAR. Com padrões de alerta industrial e tubulações de reagentes químicos, esta skin é o símbolo das facções que controlam o submundo. Um armamento rústico e letal, perfeito para quem dita as regras na cidade com força bruta e tecnologia instável.",
            component = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_BIOHAZARD",
            customOffset = vec3(0.06, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            color = '6D655E',
            weapon_type = 'rifle'
        },
        {
            name = "TOXIC V1",
            description = "A Toxic V1 é a escolha definitiva para quem domina o território. Com acabamento desgastado e fluído radioativo exposto, ela carrega a essência das guerras urbanas. Mostre sua soberania com um visual corrosivo que deixa claro: onde você pisa, ninguém mais cresce. Dominância pura.",
            component = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_TOXIC_V1",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            color = 'BC8939',
            weapon_type = 'rifle'
        },
        {
            name = "WOLF",
            description = "Lidere a alcateia com a skin WOLF do Special Carbine. Exibindo o instinto predador em tons de vermelho sangue e cinza metálico, esta skin foi feita para quem não caça sozinho. No topo da hierarquia das facções, o lobo não pede permissão ele toma o território. Estilo agressivo para quem é alfa no asfalto.",
            component = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_WOLF",
            customOffset = vec3(0.06, 0.0, -0.15),
            price = weapons_rarity[cityName]["normal"],
            color = 'CF5E74',
            weapon_type = 'rifle'
        },
        {
            name = "AQUA",
            description = "Dê um banho de realidade nos seus adversários com a skin AQUA do Special Carbine. Com um design descontraído que remete a armamentos de pressão, esta skin esconde um poder letal por trás das cores vibrantes e bolhas. É a peça perfeita para quem mantém a calma sob pressão enquanto domina as ruas da cidade.",
            component = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_AGUA",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            color = '00BD35',
            weapon_type = 'rifle'
        },
        {
            name = "GAMER",
            description = "Eleve seu nível no RP com a skin GAMER do Special Carbine. Com estética retrogamer em tons de neon, botões de console e barras de loading, esta skin transforma cada confronto em uma partida decisiva. No comando da cidade ou da sua facção, mostre que você não está aqui para brincar é o Game Over dos seus inimigos.",
            component = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_GAME",
            customOffset = vec3(0.06, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            color = 'A454C4',
            weapon_type = 'rifle'
        },
        {
            name = "CARDBOARD",
            description = "Não se engane pela aparência frágil: a skin CARDBOARD do Special Carbine é pura estratégia. Com textura de papelão reforçado e selos de \"Cuidado\", essa skin é perfeita para quem faz o corre passar despercebido. Ela representa a improvisação das ruas e a astúcia de quem sabe que a verdadeira força não precisa de brilho.",
            component = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_PAPELAO",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["epic"],
            color = 'B3A090',
            weapon_type = 'rifle'
        },
        {
            name = "TOXIN",
            description = "A skin TOXIN do Special Carbine é o ápice da engenharia clandestina para facções de elite. Com um design futurista em branco fosco e tubulações de soro químico neon, ela representa o perigo silencioso das ruas. Use esta peça experimental para infectar o território inimigo com medo e autoridade absoluta.",
            component = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_TOXIC_PUDDIN",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            color = '26D226',
            weapon_type = 'rifle'
        },
        {
            name = "WOLF",
            component = "COMPONENT_SPECIALCARBINE_G36WOLF",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            private = true,
            weapon_type = 'rifle'
        },
        {
            name = "PCJ",
            component = "COMPONENT_G3_PCJ",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            private = true,
            weapon_type = 'rifle'
        },
        {
            name = 'ELITESINTONIA',
            component = 'COMPONENT_EO_SPECIALCARBINEMK2_ELITESINTONIA',
            weapon = 'WEAPON_SPECIALCARBINE_MK2_2',
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]['legendary'],
            private = true,
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "SPECIAL CARBINE MK2 ISRAEL",
            component = "WEAPON_RIFLETP3",
            customOffset = vec3(0.08, 0.02, -0.15),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "SPECIAL CARBINE MK2 LUNETA",
            component = "WEAPON_SPECIALCARBINELUNETA_RELIKIASHOP",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "DRAGON ANIM",
            component = "COMPONENT_SPECIALCARBINE_DRAGON_ANIM",
            weapon = "WEAPON_SPECIALCARBINE_DRAGON",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            private = true,
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "AZUKAY",
            component = "COMPONENT_SPECIALCARBINE_MK2_AZUKAY",
            weapon = "WEAPON_SPECIALCARBINE_MK2_AZUKAY",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            private = true,
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "SHINOBI",
            component = "COMPONENT_SPECIALCARBINE_SHINOBI",
            weapon = "WEAPON_SPECIALCARBINE_MK2_SHINOBI",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            private = true,
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "SPECIAL CARBINE MK2 GUERRA",
            component = "WEAPON_SPECIALCARBINEZAO",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'rifle',
            custom_weapon = true
        },
        {
            name = "SPECIAL CARBINE MK2 MCX",
            component = "WEAPON_MCX",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'fuzil',
            custom_weapon = true
        },
        {
            name = "SPECIAL CARBINE MK2 PENTE DUPLO",
            component = "WEAPON_PENTEDUPLO1",
            customOffset = vec3(0.08, 0.0, -0.15),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'fuzil',
            custom_weapon = true
        },
    },
    ["WEAPON_PISTOL_MK2"] = {
        {
            name = "AQUA",
            description = "Refresque o combate com a skin AQUA do Pistol MK2. Com um design divertido inspirado em arma d'água em tons de verde, amarelo e azul, ela inclui detalhes como um selo de promoção e o logo da Penha Shop. É a escolha perfeita para quem quer manter o humor ácido enquanto \"molha\" os adversários com uma precisão surpreendente e letal.",
            component = "COMPONENT_PL_PISTOLA_AGUA",
            customOffset = vec3(0.09, 0.0, -0.12),
            price = weapons_rarity[cityName]["legendary"],
            color = '00BD35',
            weapon_type = 'pistol'
        },
        {
            name = "BLOCKS",
            description = "Monte sua estratégia com a skin BLOCKS do Pistol MK2. Com um visual inspirado em blocos de montar e cores vibrantes, ela traz um bonequinho clássico acoplado ao design. É a peça que faltava para quem quer construir sua reputação com um toque de nostalgia e diversão letal.",
            component = "COMPONENT_PL_PISTOLA_BLOCKS",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            color = 'BE4B4F',
            weapon_type = 'pistol'
        },
        {
            name = "TOXIC V1",
            description = "A skin TOXIN V1 do Pistol MK2 é projetada para operações em ambientes contaminados e zonas de risco biológico. Com um visual agressivo em amarelo e preto, apresenta texturas de desgaste e um núcleo interno preenchido por um líquido verde tóxico. Ela é o símbolo de perigo iminente, ideal para quem domina territórios industriais e quer deixar um aviso claro: a presença é letal e o aviso de \"Warning\" não é apenas decorativo.",
            component = "COMPONENT_PL_PISTOLMK2_GIH_TOXIC",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["epic"],
            color = 'C09D29',
            weapon_type = 'pistol'
        },
        {
            name = "ARRAIÁ",
            description = "Celebre as tradições com a skin ARRAIÁ do Pistol MK2. Decorada com bandeirolas coloridas, fogueira e milho, traz o espírito das festas juninas para o combate. É a peça ideal para marcar presença em eventos temáticos, unindo a alegria da celebração a um poder de fogo festivo e surpreendente.",
            component = "COMPONENT_PL_PISTOL_FJ",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            color = '73A260',
            weapon_type = 'pistol'
        },
        {
            name = "URBAN",
            description = "Domine as ruas com a skin URBAN do Pistol MK2. Com uma estética grafite marcante, apresenta a frase \"Estilo Vagabundo\" e ilustrações da cultura de rua em tons vibrantes de laranja, roxo e azul. É a escolha definitiva para quem representa a essência da cidade, unindo a arte do spray ao poder de fogo urbano.",
            component = "COMPONENT_PL_PISTOL_GRA",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            color = '2BA8B5',
            weapon_type = 'pistol'
        },
        {
            name = "LOVE",
            description = "Espalhe carinho com a skin LOVE do Pistol MK2. Com um design delicado em tons de rosa e branco, esta skin é decorada com padrões de corações e poás charmosos. É a escolha perfeita para quem quer manter a elegância e um toque de ironia, provando que até o confronto mais sério pode ter um visual adorável e impactante.",
            component = "COMPONENT_PL_PISTOL_AL",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            color = 'D97ED7',
            weapon_type = 'pistol'
        },
        {
            name = "BAD RABBIT",
            description = "Adoce o perigo com a skin BAD RABBIT do Pistol MK2. Com um visual inspirado em sorvete, traz uma cobertura rosa derretida sobre um corpo de chocolate granulado e empunhadura de casquinha. É a escolha perfeita para quem quer um estilo doce, mas letal, com um coelho raivoso que mostra que a brincadeira acabou.",
            component = "COMPONENT_PL_PISTOL_PASCOA_PUDDIN",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            color = 'E75480',
            weapon_type = 'pistol'
        },
        {
            name = "PISTOL DRAGON ANIM",
            component = "COMPONENT_PISTOL_DRAGON_ANIM",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            private = true,
            color = 'E75480',
            weapon_type = 'pistol'
        },
        {
            name = "AZUKAY",
            component = "COMPONENT_PISTOL_MK2_AZUKAY",
            weapon = "WEAPON_PISTOL_MK2_AZUKAY",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["legendary"],
            private = true,
            color = 'E75480',
            weapon_type = 'pistol',
            custom_weapon = true
        },
    },
    ["WEAPON_COMBATPISTOL"] = {
        {
            name = "GAMER",
            description = "Zere o jogo com a skin GAMER do Combat Pistol. Com tons de rosa e roxo, traz o visual de arcades retrô, botões e telas de \"Insert Coin\". É o equipamento perfeito para quem encara cada confronto como um desafio estratégico e quer subir de nível com muito estilo.",
            component = "COMPONENT_PL_COMBATPISTOL_GAME",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["legendary"],
            color = 'A454C4',
            weapon_type = 'pistol'
        },
        {
            name = "ANIME",
            description = "Domine com a skin ANIME do Combat Pistol. Com um design limpo em branco e roxo, apresenta uma estética oriental marcante e ilustrações cativantes. É a escolha ideal para quem quer unir o poder de fogo à personalidade dos protagonistas, garantindo destaque e estilo único nas ruas.",
            component = "COMPONENT_PL_COMBATPISTOL_ANIME",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["epic"],
            color = '9883F7',
            weapon_type = 'pistol'
        },
        {
            name = "FADE",
            description = "Eleve seu status com a skin FADE do Combat Pistol. O ferrolho apresenta um gradiente metálico impecável que transita entre o roxo, rosa e dourado, contrastando com o corpo preto fosco. É a escolha definitiva para quem busca luxo, autoridade e um visual premium em cada confronto.",
            component = "COMPONENT_PL_COMBATPISTOL_FADE",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            color = '8E02CE',
            weapon_type = 'pistol'
        },
        {
            name = "ABSTRACT",
            description = "Imponha sua presença com a skin ABSTRACT do Combat Pistol. O ferrolho apresenta uma arte psicodélica vibrante em tons de azul, verde e roxo, criando um visual dinâmico sobre o corpo preto fosco. É a escolha perfeita para quem busca originalidade e um estilo artístico único em cada confronto.",
            component = "COMPONENT_PL_COMBATPISTOL_GRAFITE",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            color = '15A8E2',
            weapon_type = 'pistol'
        },
        {
            name = "GOLD",
            description = "Demonstre poder absoluto com a skin GOLD do Combat Pistol. O ferrolho possui um banho de ouro polido com reflexos profundos, contrastando com a empunhadura preta tática. É o símbolo máximo de ostentação e liderança, feita para quem não aceita nada menos que o topo da hierarquia.",
            component = "COMPONENT_PL_COMBATPISTOL_OURO_P",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            color = 'D4AF37',
            weapon_type = 'pistol'
        },
        {
            name = "TOY",
            description = "Traga um ar lúdico e perigoso para as ruas com a skin TOY do Combat Pistol. Com cores vibrantes em tons de roxo e verde neon, esta skin simula a estética de um brinquedo de plástico, completa com detalhes de código de barras. É a escolha ideal para quem gosta de subestimar os adversários, provando que, nas mãos certas, até um visual divertido pode ser letal.",
            component = "COMPONENT_PL_COMBATPISTOL_TOY",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["normal"],
            color = '8B5BE6',
            weapon_type = 'pistol'
        },
        {
            name = "COMBAT PISTOL PENTE DUPLO",
            component = "WEAPON_COMBATPISTOL_R",
            customOffset = vec3(0.09, 0.0, -0.07),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'pistol',
            custom_weapon = true
        },
        {
            name = "COMBAT PISTOL LASER OURO",
            component = "WEAPON_COMBATPISTOLLASEROURO",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'pistol',
            custom_weapon = true
        },
        {
            name = "COMBAT PISTOL LASER PRATA",
            component = "WEAPON_COMBATPISTOLLASERPRATA",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'pistol',
            custom_weapon = true
        },
        {
            name = "COMBAT PISTOL RUBRO",
            component = "WEAPON_COMBATPISTOLFLA",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'pistol',
            custom_weapon = true
        },
        {
            name = "COMBAT PISTOL CUSTOM",
            component = "WEAPON_COMBATPISTOLP",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'pistol',
            custom_weapon = true
        },
        {
            name = "COMBAT PISTOL RAJADA",
            component = "WEAPON_GRAJADA",
            customOffset = vec3(0.09, 0.0, -0.09),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'pistol',
            custom_weapon = true
        },
    },
    ["WEAPON_SNIPERRIFLE"] = {
        {
            name = "LOVE",
            description = "Marque seus alvos com um toque de ironia usando a skin LOVE do Sniper. Com um design vibrante repleto de corações e tons de rosa e roxo, esta skin é a assinatura perfeita para o atirador de elite que mantém o sarcasmo em dia. No submundo das facções, mostre que até a morte pode ter um visual apaixonante antes do disparo final.",
            component = "COMPONENT_PL_SNIPER_AL",
            customOffset = vec3(-0.20, 0.0, -0.15),
            price = weapons_rarity[cityName]["epic"],
            color = 'D97ED7',
            weapon_type = 'sniper'
        },
        {
            name = "CUTI SHOT",
            description = "A CUTI SHOT redefine o conceito de perigo com sua estética \"kawaii\" e personagens carismáticos. No contexto de facção, esta skin é o ápice do deboche, permitindo que você neutralize alvos com precisão cirúrgica enquanto mantém um visual leve e colorido. Ideal para o atirador que domina o território com carisma e uma letalidade implacável.",
            component = "COMPONENT_PL_SNIPER_CUTI",
            customOffset = vec3(-0.20, 0.0, -0.15),
            price = weapons_rarity[cityName]["normal"],
            color = 'A18EE2',
            weapon_type = 'sniper'
        },
        {
            name = "GAMER",
            description = "Zere o jogo com a skin GAMER do Sniper. Unindo a nostalgia dos arcades com o poder de fogo de uma facção, esta skin apresenta acabamento em neon, ícones de \"Level Up\" e barras de progresso. É a ferramenta perfeita para quem domina o mapa com visão estratégica, transformando cada eliminação à distância em um High Score absoluto.",
            component = "COMPONENT_PL_SNIPER_GAME",
            customOffset = vec3(-0.20, 0.0, -0.15),
            price = weapons_rarity[cityName]["legendary"],
            color = 'A454C4',
            weapon_type = 'sniper'
        },
        {
            name = "SNIPER TROIA",
            component = "WEAPON_50_RELIKIASHOP",
            customOffset = vec3(-0.20, 0.0, -0.15),
            price = weapons_rarity[cityName]["epic"],
            color = '15D795',
            weapon_type = 'sniper',
            custom_weapon = true
        },
    }
}

weapons_dimentions = {
    ["WEAPON_ASSAULTRIFLE_MK2"] = {
        min=	vec3(-0.341886, -0.037729, -0.094935),
        max=	vec3(0.634631, 0.028148, 0.105537)
    },
    ["WEAPON_CARBINERIFLE_MK2"] = {
        min=	vec3(-0.284180, -0.065817, -0.131934),
        max=	vec3(0.513829, 0.029797, 0.114541)
    },
    ["WEAPON_SPECIALCARBINE_MK2"] = {
        min=	vec3(-0.382703, -0.027603, -0.131934),
        max=	vec3(0.531452, 0.049010, 0.113576)
    },
    ["WEAPON_PISTOL_MK2"] = {
        min=	vec3(-0.167428, -0.028898, -0.083496),
        max=	vec3(0.129759, 0.032131, 0.090110)
    },
    ["WEAPON_COMBATPISTOL"] = {
        min=	vec3(-0.167428, -0.028898, -0.083496),
        max=	vec3(0.129759, 0.032131, 0.090110)
    },
    ["WEAPON_SNIPERRIFLE"] = {
        min=	vec3(-0.316782, -0.060875, -0.098605),
        max=	vec3(1.084502, 0.038993, 0.119882)
    }
}

weapons_categories_custom = {}
weapons_categories_custom.Kingdom = {
    ["WEAPON_ASSAULTRIFLE_MK2"] = "Assault Rifle",
    ["WEAPON_CARBINERIFLE_MK2"] = "Combat Rifle MK2",
    ["WEAPON_SPECIALCARBINE_MK2"] = "Special Carbine",
    ["WEAPON_PISTOL_MK2"] = "Pistol MK2",
    ["WEAPON_COMBATPISTOL"] = "Combat Pistol",
}

weapons_categories_custom.District99 = {
    ["WEAPON_ASSAULTRIFLE_MK2"] = "Assault Rifle",
    ["WEAPON_CARBINERIFLE_MK2"] = "Combat Rifle MK2",
    ["WEAPON_SPECIALCARBINE_MK2"] = "Special Carbine",
    ["WEAPON_PISTOL_MK2"] = "Pistol MK2",
    ["WEAPON_COMBATPISTOL"] = "Combat Pistol",
}

weapons_categories_custom.Orizon = {
    ["WEAPON_ASSAULTRIFLE_MK2"] = "Assault Rifle",
    ["WEAPON_CARBINERIFLE_MK2"] = "Combat Rifle MK2",
    ["WEAPON_SPECIALCARBINE_MK2"] = "Special Carbine",
    ["WEAPON_PISTOL_MK2"] = "Pistol MK2",
    ["WEAPON_COMBATPISTOL"] = "Combat Pistol",
}

weapons_categories_custom.Royal = {
    ["WEAPON_ASSAULTRIFLE_MK2"] = "Assault Rifle",
    ["WEAPON_CARBINERIFLE_MK2"] = "Combat Rifle MK2",
    ["WEAPON_SPECIALCARBINE_MK2"] = "Special Carbine",
    ["WEAPON_PISTOL_MK2"] = "Pistol MK2",
    ["WEAPON_COMBATPISTOL"] = "Combat Pistol",
}

weapons_categories_custom.GoatRP = {
    ["WEAPON_ASSAULTRIFLE_MK2"] = "Assault Rifle",
    ["WEAPON_CARBINERIFLE_MK2"] = "Combat Rifle MK2",
    ["WEAPON_SPECIALCARBINE_MK2"] = "Special Carbine",
    ["WEAPON_PISTOL_MK2"] = "Pistol MK2",
    ["WEAPON_COMBATPISTOL"] = "Combat Pistol",
}

weapons_categories_custom.Liberty99 = {
    ["WEAPON_ASSAULTRIFLE_MK2"] = "Assault Rifle",
    ["WEAPON_CARBINERIFLE_MK2"] = "Combat Rifle MK2",
    ["WEAPON_SPECIALCARBINE_MK2"] = "Special Carbine",
    ["WEAPON_PISTOL_MK2"] = "Pistol MK2",
    ["WEAPON_COMBATPISTOL"] = "Combat Pistol",
}

weapons_categories = {
    ["WEAPON_ASSAULTRIFLE_MK2"] = weapons_categories_custom[cityName] and weapons_categories_custom[cityName]["WEAPON_ASSAULTRIFLE_MK2"] or "Assault Rifle",
    ["WEAPON_CARBINERIFLE_MK2"] = weapons_categories_custom[cityName] and weapons_categories_custom[cityName]["WEAPON_CARBINERIFLE_MK2"] or "Combat Rifle MK2",
    ["WEAPON_SPECIALCARBINE_MK2"] = weapons_categories_custom[cityName] and weapons_categories_custom[cityName]["WEAPON_SPECIALCARBINE_MK2"] or "Special Carbine",
    ["WEAPON_PISTOL_MK2"] = weapons_categories_custom[cityName] and weapons_categories_custom[cityName]["WEAPON_PISTOL_MK2"] or "Pistol MK2",
    ["WEAPON_COMBATPISTOL"] = weapons_categories_custom[cityName] and weapons_categories_custom[cityName]["WEAPON_COMBATPISTOL"] or "Combat Pistol",
    ["WEAPON_SNIPERRIFLE"] = weapons_categories_custom[cityName] and weapons_categories_custom[cityName]["WEAPON_SNIPERRIFLE"] or "Sniper",
}

local weaponSkinTranslations = GetWeaponSkinTranslations()

for weapon, categoryName in pairs(weaponSkinTranslations.categories) do
    weapons_categories[weapon] = categoryName
end

for _, skins in pairs(weapons_skins) do
    for _, skin in pairs(skins) do
        skin.description = weaponSkinTranslations.descriptions[skin.component] or skin.description
    end
end

function GetWeaponSkins(weapon)
    return weapons_skins[weapon]
end
exports("GetWeaponSkins", GetWeaponSkins)

-- Skins antigas (component/id antigo) gravadas em player_weapons_skins antes do rename.
-- Mapeia o id antigo -> id novo para que GetSkinWeapon resolva registros legados.
SkinMigration = {
    -- M4 -> CARBINE RIFLE
    ["COMPONENT_PL_M4_ANIME"]              = "COMPONENT_PL_CARBINERIFLE_ANIME",
    ["COMPONENT_PL_M4_FADE"]               = "COMPONENT_PL_CARBINERIFLE_FADE",
    ["COMPONENT_PL_M4_LEGO"]               = "COMPONENT_PL_CARBINERIFLE_LEGO",
    ["COMPONENT_PL_M4_MEDIC"]              = "COMPONENT_PL_CARBINERIFLE_MEDIC",
    ["COMPONENT_PL_M4_MK2_TOXIC"]          = "COMPONENT_PL_CARBINERIFLE_MK2_TOXIC",
    ["COMPONENT_PL_M4_ROSA"]               = "COMPONENT_PL_CARBINERIFLE_ROSA",
    ["COMPONENT_PL_M4_GAME"]               = "COMPONENT_PL_CARBINERIFLE_GAME",
    ["COMPONENT_PL_M4_LOVE"]               = "COMPONENT_PL_CARBINERIFLE_LOVE",
    ["WEAPON_AR10PRETO_RELIKIASHOP"]       = "WEAPON_RIFLEPRETO_RELIKIASHOP",
    ["WEAPON_AR15BEGE_RELIKIASHOP"]        = "WEAPON_RIFLEBEGE_RELIKIASHOP",
    ["WEAPON_ARBOTAFOGO"]                  = "WEAPON_RIFLEBOTA",
    ["WEAPON_ARCVDUBTL"]                   = "WEAPON_RIFLEDUBTL",
    ["WEAPON_ARDELUNETA_RELIKIASHOP"]      = "WEAPON_RIFLEDELUNETA_RELIKIASHOP",
    ["WEAPON_ARFLAMENGO"]                  = "WEAPON_RIFLEFLA",
    ["WEAPON_ARFLAMENGO2"]                 = "WEAPON_RIFLEFLA2",
    ["WEAPON_ARFLUMINENSE"]                = "WEAPON_RIFLEFLU",
    ["WEAPON_ARLUNETAPRATA"]               = "WEAPON_RIFLELUNETAPRATA",
    ["WEAPON_ARMILICIA"]                   = "WEAPON_RIFLEMILI",
    ["WEAPON_ARTERRORDAALTA"]              = "WEAPON_RIFLETERRORDAALTA",
    ["WEAPON_ARVASCO"]                     = "WEAPON_RIFLEVA",
    -- G3 -> SPECIAL CARBINE
    ["COMPONENT_FAL_PENHASHOP_04"]              = "COMPONENT_BATTLERIFLE_PENHASHOP_04",
    ["COMPONENT_PL_PENHASHOP_G3_ANIME"]         = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_ANIME",
    ["COMPONENT_PL_PENHASHOP_G3_BIOHAZARD"]     = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_BIOHAZARD",
    ["COMPONENT_PL_PENHASHOP_G3_TOXIC_V1"]      = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_TOXIC_V1",
    ["COMPONENT_PL_PENHASHOP_G3_WOLF"]          = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_WOLF",
    ["COMPONENT_PL_PENHASHOP_G3_AGUA"]          = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_AGUA",
    ["COMPONENT_PL_PENHASHOP_G3_GAME"]          = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_GAME",
    ["COMPONENT_PL_PENHASHOP_G3_PAPELAO"]       = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_PAPELAO",
    ["COMPONENT_PL_PENHASHOP_G3_TOXIC_PUDDIN"]  = "COMPONENT_BATTLERIFLE_PENHASHOP_SPECIALCARBINE_TOXIC_PUDDIN",
    ["WEAPON_ARTCP3"]                           = "WEAPON_RIFLETP3",
    ["WEAPON_G3LUNETA_RELIKIASHOP"]             = "WEAPON_SPECIALCARBINELUNETA_RELIKIASHOP",
    ["WEAPON_G3ZAO"]                            = "WEAPON_SPECIALCARBINEZAO",
    -- AK -> ASSAULT RIFLE
    ["COMPONENT_PL_AK_GOLD"]               = "COMPONENT_PL_ASSAULTRIFLE_GOLD",
    ["COMPONENT_PL_AK_AGUA"]               = "COMPONENT_PL_ASSAULTRIFLE_AGUA",
    ["COMPONENT_PL_AK_GAME"]               = "COMPONENT_PL_ASSAULTRIFLE_GAME",
    ["COMPONENT_PL_AK_TOXIC_V3"]           = "COMPONENT_PL_ASSAULTRIFLE_TOXIC_V3",
    ["COMPONENT_PL_AK_UNI"]                = "COMPONENT_PL_ASSAULTRIFLE_UNI",
    ["COMPONENT_PL_AK_PUDDIN_PASCOA"]      = "COMPONENT_PL_ASSAULTRIFLE_PUDDIN_PASCOA",
    ["COMPONENT_PL_AK_WOLF"]               = "COMPONENT_PL_ASSAULTRIFLE_WOLF",
    ["WEAPON_AKDEFERRO_RELIKIASHOP"]       = "WEAPON_ASSAULTRIFLEDEFERRO_RELIKIASHOP",
    -- Os dois ids da planilha apontam para o hash real do pack.
    ["WEAPON_AKPENTE90_RELIKIASHOP"]       = "WEAPON_AKPENTEDE90_RELIKIASHOP",
    ["WEAPON_ASSAULTRIFLEPENTE90_RELIKIASHOP"] = "WEAPON_AKPENTEDE90_RELIKIASHOP",
    ["WEAPON_AKTERRORDAPENHA"]             = "WEAPON_ASSAULTRIFLETERRORDAPENHA",
    -- GLOCK -> COMBAT PISTOL
    ["COMPONENT_PL_GLOCK_GAME"]            = "COMPONENT_PL_COMBATPISTOL_GAME",
    ["COMPONENT_PL_GLOCK_ANIME"]           = "COMPONENT_PL_COMBATPISTOL_ANIME",
    ["COMPONENT_PL_GLOCK_FADE"]            = "COMPONENT_PL_COMBATPISTOL_FADE",
    ["COMPONENT_PL_GLOCK_GRAFITE"]         = "COMPONENT_PL_COMBATPISTOL_GRAFITE",
    ["COMPONENT_PL_GLOCK_OURO_P"]          = "COMPONENT_PL_COMBATPISTOL_OURO_P",
    ["COMPONENT_PL_GLOCK_TOY"]             = "COMPONENT_PL_COMBATPISTOL_TOY",
    ["WEAPON_GLOCK_R"]                     = "WEAPON_COMBATPISTOL_R",
    ["WEAPON_GLOCKLASEROURO"]              = "WEAPON_COMBATPISTOLLASEROURO",
    ["WEAPON_GLOCKLASERPRATA"]             = "WEAPON_COMBATPISTOLLASERPRATA",
    ["WEAPON_GLOCKMENGO"]                  = "WEAPON_COMBATPISTOLFLA",
    ["WEAPON_GLOCKP"]                      = "WEAPON_COMBATPISTOLP",
    -- FIVE SEVEN -> PISTOL MK2
    ["COMPONENT_PL_PISTOL_1911_FJ"]        = "COMPONENT_PL_PISTOL_FJ",
    ["COMPONENT_PL_PISTOL_1911_GRA"]       = "COMPONENT_PL_PISTOL_GRA",
    ["COMPONENT_PL_PISTOL_1911_AL"]        = "COMPONENT_PL_PISTOL_AL",
}

function MigrateSkin(skin)
    return SkinMigration[skin] or skin
end
exports("MigrateSkin", MigrateSkin)

function GetSkinWeapon(skin)
    local skin = MigrateSkin(skin)
    local selectedWeapon = false
    for weapon, skins in pairs(weapons_skins) do
        for _, skinInfo in pairs(skins) do
            if skinInfo.component == skin or skinInfo.weapon == skin then
                selectedWeapon = weapon
            end
        end
    end
    return selectedWeapon
end
exports("GetSkinWeapon", GetSkinWeapon)

function GetSkinOffset(skin)
    local selectedOffset = vec3(0.0,0.0,0.0)
    for weapon, skins in pairs(weapons_skins) do
        for _, skinInfo in pairs(skins) do
            if skinInfo.component == skin then
                selectedOffset = skinInfo.customOffset or vec3(0.0,0.0,0.0)
            end
        end
    end
    return selectedOffset
end
exports("GetSkinOffset", GetSkinOffset)

function CheckWeaponSkins(weapon)
    if not weapons_skins[weapon] then
        return false
    end
    for _, skin in pairs(weapons_skins[weapon]) do
        if skin.equipped then
            return skin.component
        end
    end
    return false
end
exports("CheckWeaponSkins", CheckWeaponSkins)

cityColor = '6f6f6f'

function GetWeaponSkins(weapon)
    return weapons_skins[weapon]
end

exports("GetWeaponSkins", GetWeaponSkins)

function GetWeaponBackgroundColor(skin)
    local color = false
    for weapon, skins in pairs(weapons_skins) do
        for _, skinInfo in pairs(skins) do
            if skinInfo.component == skin then
                return skinInfo.color
            end
        end
    end
    return color
end
exports("GetWeaponBackgroundColor", GetWeaponBackgroundColor)

function GetSkinConfig(skin)
    local customConfig = false
    for weapon, skins in pairs(weapons_skins) do
        for _, skinInfo in pairs(skins) do
            if skinInfo.component == skin or skinInfo.weapon == skin then
                customConfig = skinInfo
            end
        end
    end
    return customConfig
end
exports("GetSkinConfig", GetSkinConfig)

function GetSkinWeaponName(skin)
    local skinConfig = GetSkinConfig(skin)
    return skinConfig and (skinConfig.weapon or skinConfig.component) or skin
end
exports("GetSkinWeaponName", GetSkinWeaponName)


function IsCustomWeapon(skin)
    local customWeapon = false
    for weapon, skins in pairs(weapons_skins) do
        for _, skinInfo in pairs(skins) do
            if skinInfo.custom_weapon and (skinInfo.component == skin or skinInfo.weapon == skin) then
                customWeapon = weapon
                break
            end
        end
    end
    return customWeapon
end
exports("IsCustomWeapon", IsCustomWeapon)
