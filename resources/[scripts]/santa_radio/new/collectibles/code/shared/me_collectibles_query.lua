-- TODO: FIXME, remover a necessidade de experar pelo sx carregar antes de usar uma funcao dele!
while not createCollection do
    Wait( 50 )
end

---@type Collection<collectibles.Collectible, void>
gMeCollectiblesCollection = createCollection( 'me.collectibles' )