---@type table<string, table<string, boolean>>
RANKING_CITIES = {
    Santa       = { social = true,  orgs = true  },
    Grande      = { social = true,  orgs = true  },
    Kingdom     = { social = true,  orgs = true  },
    Malta       = { social = true,  orgs = true  },
    Royal       = { social = true,  orgs = true  },
    CidadeNobre = { social = true,  orgs = true  },
    District99  = { social = true,  orgs = true  },
    Maresia     = { social = true,  orgs = true  },
    Orizon      = { social = true,  orgs = true  },
    Liberty99   = { social = true,  orgs = true  },
    Prime       = { social = true,  orgs = true  },
    Krown       = { social = true,  orgs = true  },
    Fronteira   = { social = true,  orgs = true  },
    Real        = { social = true,  orgs = true  },
    Boomerang   = { social = true,  orgs = true  },
    GoatRP      = { social = true,  orgs = true  },
    Universo    = { social = true,  orgs = true  },
}

---@param cityName? string -- default: a convar `cityName` deste servidor
---@return table<string, boolean>
local function DomainsFor( cityName )
    return RANKING_CITIES[ cityName or GetConvar( 'cityName', '' ) ] or {}
end

---@param cityName? string -- default: a convar `cityName` deste servidor
---@return boolean enabled
function IsSocialRankingCityEnabled( cityName )
    return DomainsFor( cityName ).social == true
end

---@param cityName? string -- default: a convar `cityName` deste servidor
---@return boolean enabled
function IsOrgRankingCityEnabled( cityName )
    return DomainsFor( cityName ).orgs == true
end

---@return string
function SocialRankingLanguage()
    return string.lower( string.sub( GetConvar( 'language', 'pt-br' ), 1, 2 ) )
end

---@param byLanguage table<string, string>
---@return string
function SocialRankingText( byLanguage )
    return byLanguage[ SocialRankingLanguage() ] or byLanguage.pt
end
