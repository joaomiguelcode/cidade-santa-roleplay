config.storeLink = {
    ['alexandria']  = 'https://loja.alexandriarp.com/category/penthouse',
    ['cidadenobre'] = 'https://loja.cidadenobre.com/category/penthouse-1?currency=BRL',
    ['santa']       = 'https://loja.cidadesantarp.com/category/penthouse?currency=BRL',
    ['maresia']     = 'https://loja.maresiarp.com/category/penthouse-1',
    ['universo']    = 'https://loja.universoroleplay.com/category/penthouse-1?currency=BRL',
    ['kingdom']     = 'https://storee.kngestate.com/category/penthouse?currency=GBP',
    ['district99']  = 'https://store.district99.gg/category/penthouse?currency=USD',
    ['orizon']      = 'https://store.orizonrp.gg/category/penthouse?currency=USD',
    ['liberty99']   = 'https://store.liberty99rp.com/category/penthouse',
    ['krown']       = 'https://store.krownrp.com/category/penthouse?currency=USD',
    ['royal']       = 'https://storee.royalukrp.com/category/penthouse?currency=GBP',
    ['real']        = 'https://tienda.realrp.es/category/penthouse?currency=EUR',
    ['prime']       = 'https://tienda.primerp.gg/category/penthouse?currency=EUR',
    ['malta']       = 'https://loja.maltarp.com/category/penthouse?currency=EUR',
    ['boomerang']   = 'https://storee.boomerangroleplay.com/category/penthouse?currency=GBP',
    ['grande']      = 'https://loja.cidadegrande.com/category/penthouse?currency=BRL',
    ['fronteira']   = 'https://fronteirarp.hydrus.gg/category/penthouse?currency=BRL',
}

---@return string?
function GetTebexVoucherLink()
    return config.storeLink[city]
end