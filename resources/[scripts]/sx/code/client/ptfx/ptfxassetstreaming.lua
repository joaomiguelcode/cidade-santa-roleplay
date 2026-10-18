-- Asset holds: refcount the ptfx assets we hold so the streaming request is released once the last entry
-- that needs a dict stops needing it. The hold is acquired when an entry enters 'loading' (NOT when it
-- starts playing), so a request is always matched by a release even if the entry is abandoned mid-load — no
-- orphaned streaming requests. Multiple layers/players can share a dict (e.g. 'core'), hence the count.

---@param dict string
---@return nil
function AcquirePtfxAsset( dict )

    local users = ( gPtfxAssetUsers[ dict ] or 0 ) + 1
    gPtfxAssetUsers[ dict ] = users

    if users == 1 then
        RequestNamedPtfxAsset( dict )
    end
end

---@param dict string
---@return nil
function ReleasePtfxAsset( dict )

    local users = gPtfxAssetUsers[ dict ] - 1

    if users == 0 then
        gPtfxAssetUsers[ dict ] = nil
        RemoveNamedPtfxAsset( dict )
    else
        gPtfxAssetUsers[ dict ] = users
    end
end
