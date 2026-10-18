sx.collectibles = { }

---@param itemKey string
---@return collectibles.CollectibleKey | nil
function sx.collectibles.getCollectibleLookupKeyByItemKey( itemKey )

    return exports.santa_radio:GetCollectibleLookupKeyByItemKey( itemKey )
end