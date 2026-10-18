MAX_MINUTES_TO_TRIGGER_NPS = 30

cityName = GetConvar("cityName", "")

OnGoingEventsClick = {
    "arena:FFAPistola",
    "x1:Start",
    "WorldPVP:Start",
}

Rules = {
    ["Maresia"]     = "https://docs.google.com/document/d/1Aa4ADwydr45_yDh-gKYN1z73ZFzxumlDcoA-4x0x7ls/edit",
    ["Galaxy"]      = "https://docs.google.com/document/d/17ARcMrkeBj0NGmok5kVRPmKs21tdxH5BiVjTjpaI5xw/edit?usp=sharing",
    ["Universo"]    = "https://docs.google.com/document/d/17ARcMrkeBj0NGmok5kVRPmKs21tdxH5BiVjTjpaI5xw/edit?usp=sharing",
    ["Grande"]      = "https://docs.google.com/document/d/15xJG1ZgVOHRJAGNYDCegl25NGQ1jzv3UktZlHYDkuJU/edit?usp=sharing",
    ["Fronteira"]   = "",
    ["Santa"]       = "https://docs.google.com/document/d/1_1axI7xaWrle7vk_Zohz-juDbFgoPz6RhIDaZy_uNFY/edit#",
    ["Alexandria"]  = "https://docs.google.com/document/d/1KHdQlPT5Tbgvdjh4W0UisVxjsG1pZZYLiZCnGGvNSFk/edit?usp=sharing",
    ["CidadeNobre"] = "https://docs.google.com/document/d/12ogw9JR-txTfRaBWcHiRsPZt4wGkq5ndACVy8coOAPY/edit?usp=sharing",
    ["Boomerang"]   = "",
    ["Malta"]       = "",
    ["Krown"]       = "",
    ["Kingdom"]     = "https://docs.google.com/document/d/1I1hZqitRovTBARxkdlnVpPw3LkmXrx5ideVAXvWHDjk/edit?tab=t.0",
    ["Imperium"]    = "",
    ["GoatRP"]      = "",
    ["District99"]  = "",
    ["Orizon"]  = "",
    ["Royal"]       = "",
    ["Real"]        = "",
    ["Prime"]       = "",
}

--[[

O que é?

Configuração de imagens, cores, videos, backgrounds, textos do modal da promoção de VIP que aparece na segunda vez ao abrir o HUB
ou ao pressionar o botão VIP ( quem um icone de diamante ) no canto superior direito.

- videoSrc              — O vídeo da promoção que toca no modal de VIP.                                                                                                                                                                           
- backgroundImageSrc    — A imagem de fundo do modal.                                                                                                                                                                                   
- themeRgb              — A cor tema do modal (botão e detalhes).                                                                                                                                                                                   - ctaText — O texto do botão de comprar.
- linkPromotion         — O link da loja que abre ao clicar no botão.                                                                                                                                                                        
- videoPoster           — A imagem que aparece antes do vídeo começar.

]]
offerVipModal = {
    ["Maresia"] = {
        {
            videoSrc = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/BR-Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            themeRgb = "37,150,190",
            ctaText = "Compre agora o VIP Halloween 🕷️",
            linkPromotion = "https://loja.maresiarp.com/category/vip-lancamento?currency=BRL",
            videoPoster = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/BR-Halloween.mp4",
        },
    },
    ["Grande"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/BR-Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/BR-Halloween.mp4",
            themeRgb           = "37,150,190",
            ctaText            = "Compre agora o VIP Halloween 🕷️",
            linkPromotion      = "https://loja.cidadegrande.com/category/vip-lancamento?currency=BRL",
        },
    },
    ["Santa"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/BR-Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/PT%20-%20Halloween.mp4",
            themeRgb           = "37,150,190",
            ctaText            = "Compre agora o VIP Halloween 🕷️",
            linkPromotion      = "https://loja.cidadesantarp.com/category/vip-lancamento?currency=BRL",
        },
    },
    ["CidadeNobre"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/BR-Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/BR-Halloween.mp4",
            themeRgb           = "37,150,190",
            ctaText            = "Compre agora o VIP Halloween 🕷️",
            linkPromotion      = "https://loja.cidadenobre.com/category/vip-lancamento?currency=BRL",
        },
    },
    ["Malta"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/PT%20-%20Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/PT%20-%20Halloween.mp4",
            themeRgb           = "37,150,190",
            ctaText            = "Compre agora o VIP Halloween 🕷️",
            linkPromotion      = "https://loja.maltarp.com/category/Lancamento?currency=EUR",
        },
    },
    ["Real"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/ES%20-%20Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/ES%20-%20Halloween.mp4",
            themeRgb           = "37,150,190",
            ctaText            = "Compra ahora el VIP Halloween 🕷️",
            linkPromotion      = "https://tienda.realrp.es/category/lanzamiento?currency=EUR",
        },
    },
    ["Prime"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/ES%20-%20Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/ES%20-%20Halloween.mp4",
            themeRgb           = "171,5,35",
            ctaText            = "Compra ahora el VIP Halloween 🕷️",
            linkPromotion      = "https://tienda.primerp.gg/category/lanzamiento?currency=EUR",
        },
    },
    ["Kingdom"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/UK%20-%20Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/UK%20-%20Halloween.mp4",
            themeRgb           = "171,5,35",
            ctaText            = "Buy the Halloween VIP now 🕷️",
            linkPromotion      = "https://storee.royalukrp.com/category/launch-vip?currency=GBP",
        },
    },
    ["Royal"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/UK%20-%20Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/UK%20-%20Halloween.mp4",
            themeRgb           = "171,5,35",
            ctaText            = "Buy the Halloween VIP now 🕷️",
            linkPromotion      = "https://storee.royalukrp.com/category/launch-vip?currency=GBP",
        },
    },
    ["District99"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/US%20-%20Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/US%20-%20Halloween.mp4",
            themeRgb           = "171,5,35",
            ctaText            = "Buy the Halloween VIP now 🕷️",
            linkPromotion      = "https://store.district99.gg/category/launch-vip?currency=USD",
        },
    },
    ["Liberty99"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/US%20-%20Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/US%20-%20Halloween.mp4",
            themeRgb           = "171,5,35",
            ctaText            = "Buy the Halloween VIP now 🕷️",
            linkPromotion      = "https://store.liberty99rp.com/category/launch-vip?currency=USD",
        },
    },
    ["Orizon"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/AR%20-%20Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/AR%20-%20Halloween.mp4",
            themeRgb           = "171,5,35",
            ctaText            = "⁦🕷️ ⁧الان⁩ ⁧الهلاوين⁩ VIP ⁧اشتروا⁩",
            linkPromotion      = "https://store.orizonrp.gg/category/%D9%8A%D8%B7%D9%84%D9%82",
        },
    },
    ["Krown"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/US%20-%20Halloween.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/com_mascara_1.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/new_outubro/US%20-%20Halloween.mp4",
            themeRgb           = "171,5,35",
            ctaText            = "Buy the Halloween VIP now 🕷️",
            linkPromotion      = "https://store.krownrp.com/category/launch-vip?currency=USD",
        },
    },
    ["Fronteira"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/SG-CopaBRFront.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/af_artebase_brasil_modal_hub.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/SG-CopaBRFront.mp4",
            themeRgb           = "254,189,1",
            ctaText            = "Compre agora o VIP Copa do Mundo ⚽",
            linkPromotion      = "https://loja.fronteirarp.com.br/package/7482966",
        },
    },
    ["Universo"] = {
        {
            videoSrc           = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/1080-SG-DeadlyVIP-BR.mp4",
            backgroundImageSrc = "https://cdn.santagroup.gg/vips/af_artebase_lutasmortais_modal_hub.webp",
            videoPoster        = "https://santaimagens.roleplayrp.com/img/imagens_variadas/hub/new/1080-SG-DeadlyVIP-BR.mp4",
            themeRgb           = "225,239,240",
            ctaText            = "Compre agora o VIP Lutas Mortais 💀",
            linkPromotion      = "https://loja.universoroleplay.com/package/7320186",
        },
    },
}

-- Offset UTC de cada cidade (em horas).
-- As datas em workAtDate devem ser configuradas no horário local da cidade.
local CITY_TIMEZONES_MAP = {
    ["Maresia"]     = "brazil",   -- BRT  (UTC-3)
    ["Universo"]    = "brazil",   -- BRT  (UTC-3)
    ["Grande"]      = "brazil",   -- BRT  (UTC-3)
    ["Fronteira"]   = "brazil",   -- BRT  (UTC-3)
    ["Santa"]       = "brazil",   -- BRT  (UTC-3)
    ["CidadeNobre"] = "brazil",   -- BRT  (UTC-3)
    ["Malta"]       = "portugal", -- WET  (UTC+0)
    ["Real"]        = "spain",    -- CET  (UTC+1)
    ["Prime"]       = "spain",    -- CET  (UTC+1)
    ["Boomerang"]   = "uk",       -- GMT  (UTC+0)
    ["Kingdom"]     = "uk",       -- GMT  (UTC+0)
    ["Royal"]       = "uk",       -- GMT  (UTC+0)
    ["District99"]  = "usa",      -- EST  (UTC-5)
    ["Krown"]  = "usa",      -- EST  (UTC-5)
    ["Orizon"]  = "usa",      -- EST  (UTC-5)
    ["Liberty99"] = "usa",      -- EST  (UTC-5) 
}

local TIMEZONE_OFFSETS = {
    ["brazil"] = -3,
    ["portugal"] = 0,
    ["spain"] = 1,
    ["uk"] = 0,
    ["usa"] = -5,
}

function GetCityUtcOffsetSeconds()
    return TIMEZONE_OFFSETS[CITY_TIMEZONES_MAP[cityName] or "brazil"] * 3600
end

local function leapYearsBefore(y)
    y = y - 1
    return math.floor(y / 4) - math.floor(y / 100) + math.floor(y / 400)
end

---@param dateStr string — formato "DD/MM/YYYY HH:MM:SS" no horário local da cidade
---@return number timestamp sem offset (tratado como UTC puro para conversão posterior)
local function parseStringToTimestamp(dateStr)
    local d, m, y, h, mi, s = dateStr:match("(%d%d)/(%d%d)/(%d%d%d%d) (%d%d):(%d%d):(%d%d)")
    if not d then return 0 end

    d               = tonumber(d)
    m               = tonumber(m)
    y               = tonumber(y)
    h               = tonumber(h)
    mi              = tonumber(mi)
    s               = tonumber(s)

    local leapYears = leapYearsBefore(y) - leapYearsBefore(1970)
    local days      = (y - 1970) * 365 + leapYears

    local monthDays = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
    if (y % 4 == 0 and (y % 100 ~= 0 or y % 400 == 0)) then
        monthDays[2] = 29
    end

    for i = 1, m - 1 do
        days = days + monthDays[i]
    end

    days = days + (d - 1)

    return days * 86400 + h * 3600 + mi * 60 + s - GetCityUtcOffsetSeconds()
end

---@param timestamp number — os.time() do servidor (UTC)
---@return table|nil
function GetOfferVipModal(timestamp)
    local promos = offerVipModal[cityName]

    if not promos then return nil end

    -- Monta o timestamp atual como YYYYMMDDHHMMSS para comparação direta
    local bestConfig    = nil
    local bestTimestamp = nil

    for _, promo in ipairs(promos) do
        if promo.workAtDate then
            local promoTs = parseStringToTimestamp(promo.workAtDate)

            if timestamp >= promoTs then                             -- Só considera se a data/hora já passou ou é agora
                if not bestTimestamp or promoTs > bestTimestamp then -- Pega a mais recente entre as disponíveis
                    bestTimestamp = promoTs
                    bestConfig    = promo
                end
            end
        end
    end

    if bestConfig then
        return bestConfig
    end

    -- Fallback: primeira promoção sem workAtDate
    for _, promo in ipairs(promos) do
        if not promo.workAtDate then
            return promo
        end
    end

    return nil
end

if cityName == "Santa" then
end
