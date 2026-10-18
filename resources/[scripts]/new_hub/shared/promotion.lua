function parseInt(Value)
	local Result = 0
	local Number = tonumber(Value)

	if Number ~= nil then
		if Number > 0 then
			Result = math.floor(Number)
		end
	end

	return Result
end
function generateTimer()
    return parseInt((GetGameTimer() + 1000 * 60 * 60 * 2) / 1000)
end

-- Cada cidade pode definir currencySymbol (ex.: "$", "R$", "€"). Sem ele, a NUI usa currency.symbol da localização.
Promotion = {
    ["CidadeNobre"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/cidadenobre.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 147,
        ["discountPrice"] = 47, -- VALOR COM DESCONTO
        ["discountPercent"] = 68, -- VALOR COM DESCONTO
        ["title"] = 'VIP OURO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/BR2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://loja.cidadenobre.com/package/6935832", -- ID DO ITEM
        ["cupon"] = "VIPOURO" -- CUPOM A SER APLICADO
    },
    ["Boomerang"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/boomerang2.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 30,
        ["discountPrice"] = 20, -- VALOR COM DESCONTO
        ["discountPercent"] = 33, -- % DESCONTO- % DESCONTO
        ["title"] = 'GOLDEN VIP', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/EN2.mp4', -- VIDEO DA PROMOVIDEO DA PROMO
        ["link"] = "https://storee.royalukrp.com/package/7432754", -- ID DO ITEM
        ["cupon"] = "" -- CUPOM A SER APLICADO
    },
    ["Grande"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/grande.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 147,
        ["discountPrice"] = 47, -- VALOR COM DESCONTO
        ["discountPercent"] = 68, -- VALOR COM DESCONTO
        ["title"] = 'VIP OURO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/BR2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://loja.cidadegrande.com/package/6983361?currency=BRL", -- ID DO ITEM
        ["cupon"] = "VIPOURO" -- CUPOM A SER APLICADO
    },
    ["Fronteira"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/grande.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 147,
        ["discountPrice"] = 47, -- VALOR COM DESCONTO
        ["discountPercent"] = 68, -- VALOR COM DESCONTO
        ["title"] = 'VIP OURO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/BR2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://loja.cidadegrande.com/package/6983361?currency=BRL", -- ID DO ITEM
        ["cupon"] = "VIPOURO" -- CUPOM A SER APLICADO
    },
    ["Malta"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://dunb17ur4ymx4.cloudfront.net/packages/images/9faee2c7d8dbe624c7029b6595e215eb103ad578.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 30,
        ["discountPrice"] = 11, -- VALOR COM DESCONTO
        ["discountPercent"] = 68, -- VALOR COM DESCONTO
        ["title"] = 'VIP OURO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/PT2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://loja.maltarp.com/package/6938224", -- ID DO ITEM
        ["cupon"] = "VIPOURO" -- CUPOM A SER APLICADO
    },
    ["Maresia"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/maresia.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 147,
        ["discountPrice"] = 47, -- VALOR COM DESCONTO
        ["discountPercent"] = 68, -- VALOR COM DESCONTO
        ["title"] = 'VIP OURO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/BR2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://loja.maresiarp.com/package/6936581", -- ID DO ITEM
        ["cupon"] = "VIPOURO" -- CUPOM A SER APLICADO
    },
    ["Universo"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/universo2.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 147,
        ["discountPrice"] = 47, -- VALOR COM DESCONTO
        ["discountPercent"] = 68, -- VALOR COM DESCONTO
        ["title"] = 'VIP OURO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/BR2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://loja.universoroleplay.com/package/6935974", -- ID DO ITEM
        ["cupon"] = "VIPOURO" -- CUPOM A SER APLICADO
    },
    ["Kingdom"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/kng.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 30,
        ["discountPrice"] = 20, -- VALOR COM DESCONTO
        ["discountPercent"] = 33, -- % DESCONTO
        ["title"] = 'GOLDEN VIP', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/EN2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://storee.kngestate.com/package/6558961", -- ID DO ITEM
        ["cupon"] = "" -- CUPOM A SER APLICADO
    },
    ["Imperium"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/imperium.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 30,
        ["discountPrice"] = 20, -- VALOR COM DESCONTO
        ["discountPercent"] = 33, -- % DESCONTO
        ["title"] = 'GOLDEN VIP', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/EN2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://store.imperiumrp.com/package/6937982", -- ID DO ITEM
        ["cupon"] = "" -- CUPOM A SER APLICADO
    },
    ["GoatRP"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/goatrp.png",
        ["button_text"] = "ACHETER",
        ["totalPrice"] = 50,
        ["discountPrice"] = 38, -- VALOR COM DESCONTO
        ["discountPercent"] = 24, -- % DESCONTO
        ["title"] = 'VIP OR', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/Fr.mp4', -- VIDEO DA PROMO
        ["link"] = "https://boutique.goatrp.gg/package/7349920", -- ID DO ITEM
        ["cupon"] = "VIPOR" -- CUPOM A SER APLICADO
    },
    ["District99"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/d99.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 30,
        ["discountPrice"] = 20, -- VALOR COM DESCONTO
        ["discountPercent"] = 33, -- % DESCONTO
        ["title"] = 'GOLDEN VIP', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/liberty99.mp4', -- VIDEO DA PROMO
        ["link"] = "https://store.district99.gg/package/6937606", -- ID DO ITEM
        ["cupon"] = "" -- CUPOM A SER APLICADO
    },
    ["Orizon"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/orizon.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 30,
        ["discountPrice"] = 20, -- VALOR COM DESCONTO
        ["discountPercent"] = 33, -- % DESCONTO
        ["title"] = 'GOLDEN VIP', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://drive.google.com/drive/folders/1VeipSUoWR_eGVe4plH6lyKEARYG2Io-c?usp=drive_link', -- VIDEO DA PROMO
        ["link"] = "https://store.orizonrp.gg/package/7452125", -- ID DO ITEM
        ["cupon"] = "" -- CUPOM A SER APLICADO
    },
    ["Liberty99"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/liberty99.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 36,
        ["discountPrice"] = 26, -- VALOR COM DESCONTO
        ["discountPercent"] = 33, -- % DESCONTO
        ["title"] = 'GOLDEN VIP', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/liberty99.mp4', -- VIDEO DA PROMO
        ["link"] = "https://store.liberty99rp.com/package/7406288", -- ID DO ITEM
        ["cupon"] = "" -- CUPOM A SER APLICADO
    },
    ["Royal"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/royal2.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 30,
        ["discountPrice"] = 20, -- VALOR COM DESCONTO
        ["discountPercent"] = 33, -- % DESCONTO
        ["title"] = 'GOLDEN VIP', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/EN2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://storee.royalukrp.com/package/7434751", -- ID DO ITEM
        ["cupon"] = "" -- CUPOM A SER APLICADO
    },
    ["Real"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/real.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 30,
        ["discountPrice"] = 20, -- VALOR COM DESCONTO
        ["discountPercent"] = 33, -- % DESCONTO
        ["title"] = 'VIP ORO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/ES2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://tienda.realrp.es/package/6935924", -- ID DO ITEM
        ["cupon"] = "" -- CUPOM A SER APLICADO
    },
    ["Prime"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/primerp.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 30,
        ["discountPrice"] = 20, -- VALOR COM DESCONTO
        ["discountPercent"] = 33, -- % DESCONTO
        ["title"] = 'VIP ORO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/ES2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://tienda.primerp.gg/package/7301109", -- ID DO ITEM
        ["cupon"] = "" -- CUPOM A SER APLICADO
    },
    ["Alexandria"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/alexandria.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 147,
        ["discountPrice"] = 47, -- VALOR COM DESCONTO
        ["discountPercent"] = 68, -- VALOR COM DESCONTO
        ["title"] = 'VIP OURO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/BR2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://loja.alexandriarp.com/package/6937606", -- ID DO ITEM
        ["cupon"] = "VIPOURO" -- CUPOM A SER APLICADO
    },
    ["Santa"] = {
        ["timer"] = generateTimer(),
        ["hide_timer"] = false,
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/hubsvip/santa.png",
        ["button_text"] = "SAIBA MAIS",
        ["totalPrice"] = 147,
        ["discountPrice"] = 47, -- VALOR COM DESCONTO
        ["discountPercent"] = 68, -- VALOR COM DESCONTO
        ["title"] = 'VIP OURO', -- TITULO INTERNO DA PROMO
        ["video"] = 'https://videos.roleplayrp.com/img/imagens_variadas/hub/vips_videos/BR2.mp4', -- VIDEO DA PROMO
        ["link"] = "https://loja.cidadesantarp.com/package/6935997", -- ID DO ITEM
        ["cupon"] = "VIPOURO" -- CUPOM A SER APLICADO
    },
}

BattlePassLink = {
    ["Santa"] = "https://loja.cidadesantarp.com/package/6549154",
    ["Galaxy"] = "",
    ["Universo"] = "https://loja.universoroleplay.com/?currency=BRL",
    ["CidadeNobre"] = "https://loja.cidadenobre.com/package/6546080",
    ["Boomerang"] = "",
    ["Malta"] = "https://loja.maltarp.com/package/6734251",
    ["Kingdom"] = "https://storee.kngestate.com/package/6553619",
    ["Imperium"] = "https://store.imperium.com/package/6553619",
    ["GoatRP"] = "https://boutique.goatrp.gg/package/6553619",
    ["District99"] = "https://store.district99.gg/package/7106637",
    ["Orizon"] = "https://store.orizonrp.gg/package/7106637",
    ["Liberty99"] = "https://store.liberty99rp.com/package/7106637",
    ["Royal"] = "https://storee.royalukrp.com/package/7273653",
    ["Real"] = "https://tienda.realrp.es/package/6907241",
    ["Prime"] = "https://tienda.primerp.gg/package/6907241",
    ["Grande"] = "https://loja.cidadegrande.com",
    ["Alexandria"] = "",
    ["Maresia"] = "https://loja.maresiarp.com",
    ["Gaules"] = "",
    ["Fronteira"] = "",
}

StoreLink = {
    ["Santa"] = "https://loja.cidadesantarp.com",
    ["Galaxy"] = "https://lojagalaxy.santagroup.gg",
    ["Universo"] = "https://loja.universoroleplay.com",
    ["Malta"] = "https://loja.maltarp.com/",
    ["CidadeNobre"] = "https://loja.cidadenobre.com/category/vip?currency=BRL",
    ["Boomerang"] = "https://storee.boomerangroleplay.com",
    ["Kingdom"] = "https://storee.kngestate.com/category/2818259?currency=GBP",
    ["Imperium"] = "https://store.imperium.com/category/2818259?currency=GBP",
    ["GoatRP"] = "https://boutique.goatrp.gg/category/2818259?currency=GBP",
    ["District99"] = "https://store.district99.gg/category/2818259?currency=GBP",
    ["Orizon"] = "https://store.orizonrp.gg/",
    ["Liberty99"] = "https://store.liberty99rp.com/category/2818259?currency=GBP",
    ["Royal"] = "https://storee.royalukrp.com/category/2818259?currency=GBP",
    ["Real"] = "https://tienda.realrp.es/",
    ["Prime"] = "https://tienda.primerp.gg/",
    ["Grande"] = "https://loja.cidadegrande.com",
    ["Maresia"] = "https://loja.maresiarp.com",
    ["Gaules"] = "https://lojagaules.santagroup.gg",
    ["Fronteira"] = "https://fronteiraroleplay.hydrus.gg",
    ["Alexandria"] = "https://loja.alexandriarp.com",
}

DiamondLink = {
    ["Santa"] = "https://loja.cidadesantarp.com/category/gemas",
    ["Galaxy"] = "https://lojagalaxy.santagroup.gg",
    ["Universo"] = "https://loja.universoroleplay.com",
    ["Malta"] = "https://loja.maltarp.com/category/gemas",
    ["CidadeNobre"] = "https://loja.cidadenobre.com/category/gemas",
    ["Boomerang"] = "https://storee.boomerangroleplay.com",
    ["Kingdom"] = "https://storee.kngestate.com/category/gems",
    ["Imperium"] = "https://store.imperium.com/category/2818259?currency=GBP",
    ["GoatRP"] = "https://boutique.goatrp.gg/category/2818259?currency=GBP",
    ["District99"] = "https://store.district99.gg/category/gems",
    ["Krown"] = "https://store.krownrp.com/category/gems",
    ["Orizon"] = "https://store.orizonrp.gg/category/جواهر",
    ["Liberty99"] = "https://store.liberty99rp.com/category/gems",
    ["Royal"] = "https://storee.royalukrp.com/category/gems",
    ["Real"] = "https://tienda.realrp.es/category/gemas",
    ["Prime"] = "https://tienda.primerp.gg/category/gemas",
    ["Grande"] = "https://loja.cidadegrande.com/category/gemas",
    ["Maresia"] = "https://loja.maresiarp.com/category/gemas",
    ["Gaules"] = "https://lojagaules.santagroup.gg",
    ["Fronteira"] = "https://loja.fronteirarp.com.br/category/gemas?currency=BRL",
    ["Alexandria"] = "https://loja.alexandriarp.com",
}


MothlyVip = {
    ["Universo"] = {
        ["name"] = "VIP Rico bem novinho",
        ["coupon"] = "RICONOVINHO",
        ["description"] = [[
            <b>VIP Rico bem novinho</b>
            <br>
            <br>
            <b>Benefícios:</b>
            <br>
            - 10% de desconto em todos os produtos
            - 10% de desconto em todos os produtos
        ]],
        ["validity"] = "DISPONIVEL APENAS ESTE MÊS",
        ["link"] = "https://loja.cidadesantarp.com/package/6667563",
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/Ouro.png",
    },
    ["Maresia"] = {
        ["name"] = "VIP OURO",
        ["coupon"] = "VIPOURO",
        ["description"] = [[
            <b>VIP Ouro</b>
            <br>
            <br>
            <b>Benefícios:</b>
            <br>
            - 10% de desconto em todos os produtos
            - 10% de desconto em todos os produtos
        ]],
        ["validity"] = "DISPONIVEL APENAS ESTE MÊS",
        ["link"] = "https://loja.maresiarp.com/package/6647093",
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/MaresiaOuro.png'",
    },
}

FlashOffer = {
    ["Universo"] = {
        ["name"] = "VIP Rico bem novinho",
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/Ouro.png",
        ["percent"] = 10,
        ["price"] = 1000,
        ["discount"] = 100,
        ["validity"] = "Oferta valida ate hoje.",
        ["link"] = "https://loja.cidadesantarp.com/package/6667563",
    },
    ["Maresia"] = {
        ["name"] = "VIP OURO",
        ["image"] = "https://santaimagens.roleplayrp.com/img/imagens_variadas/vips/MaresiaOuro.png",
        ["percent"] = 68,
        ["price"] = 147,
        ["discount"] = 47,
        ["validity"] = "Oferta valida ate hoje.",
        ["link"] = "https://loja.maresiarp.com/package/6647093",
    }   
}

ExclusiveLink = {
    ["Universo"] = "https://loja.cidadesantarp.com",
    ["Maresia"] = "https://loja.maresiarp.com/?currency=BRL",
}

---@type number[]
PROMOTIONAL_VIDEO_PLAYING_PROGRESS_CUSTOMER_EVENT_THRESHOLDS =
{
    25, -- 25%
    50, -- 50%
    90, -- 90%
}
