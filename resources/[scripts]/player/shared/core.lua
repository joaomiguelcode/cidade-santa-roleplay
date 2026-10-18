--- #region ME

local function getCommandTranslation(key, language)
	if type(translations) ~= "table" then
		return nil
	end

	local languageTable = translations[language]
	if type(languageTable) ~= "table" then
		return nil
	end

	return languageTable[key]
end

function RegisterCommandLocalized(key, handler, restricted)
	local currentLang = rawget(_G, "lang") or rawget(_G, "LANGUAGE") or GetConvar("language", "pt-br")
	local primary = getCommandTranslation(key, currentLang) or getCommandTranslation(key, "en-us") or key

	RegisterCommand(primary, handler, restricted)

	local english = getCommandTranslation(key, "en-us")
	if english and english ~= primary then
		RegisterCommand(english, handler, restricted)
	end
end

---@type table<Source, number> // endsAt
local gMeCooldown = { }

---@param source Source
function ClearMeCooldown( source )

    gMeCooldown[source] = nil
end

---@param source Source
---@return boolean
function HasMeCooldown( source )

    if not gMeCooldown[source] then

        -- Não está em cooldown!

        return false
    end

    if GetGameTimer() >= gMeCooldown[source] then

        -- Acabou o cooldown!

        ClearMeCooldown( source )

        return false
    end

    return true
end

---@param source Source
---@return boolean
function ConsumeMeCooldown( source )

    if HasMeCooldown( source ) then

        TriggerEvent( 'Notify', 'negado', _t("me.cooldown") )

        return false
    end

    gMeCooldown[ source ] = GetGameTimer() + 5000

    return true
end

---@param message string
---@return boolean, string | nil
function ValidateMeMessage( message )

    if not message then
        return false, nil
    end

    if type( message ) ~= 'string' then
        return
    end

    if #message <= 0 then
        return false, 'A mensagem não pode estar vazia.'
    end

    if #message > 255 then
        return false, 'A mensagem não pode ter mais de 200 caracteres.'
    end

    return true, nil
end

function GetGroupByAlias(alias)
    local Table = GlobalState["AliasGroup"]
    for Group,Alias in pairs(Table) do
        if Alias:lower() == alias:lower() then
            return Group
        end
    end
    return alias
end

exports("GetGroupByAlias",GetGroupByAlias)

---@class WorldTeleportSide
---@field coords vector4 Ponto e heading da porta.
---@field bucket number Bucket aplicado ao chegar neste lado.
---@field requiredBucket number|nil Bucket exigido para usar este lado.
---@field allowedGroups table<string, number>|nil Grupos e níveis mínimos aceitos pelo vRP.

---@class WorldTeleport
---@field entry WorldTeleportSide
---@field exit WorldTeleportSide

---@type table<string, WorldTeleport[]>
gWorldTeleports = {
    --[[
        ['CityName'] = {
            {
                entry = {
                    coords = vec4( 100.0, 100.0, 100.0, 180.0 ),
                    bucket = 750001,
                    requiredBucket = 1,
                    allowedGroups = { Police = 1, Paramedic = 1 },
                },
                exit = {
                    coords = vec4( 200.0, 200.0, 200.0, 0.0 ),
                    bucket = 1,
                    requiredBucket = 750001,
                    allowedGroups = { Police = 1, Paramedic = 1 },
                },
            },
        },
    ]]
    ['District99'] = {
        {
            entry = {
                coords = vec4( -2379.79, -2249.82, 5.43, 206.93 ),
                bucket = 750001,
            },
            exit = {
                coords = vec4( 67.76, 1922.13, -84.22, 189.93 ),
                bucket = 1,
            },
        },
        {
            entry = {
                coords = vec4( -3482.37, 909.04, 21.18, 102.05 ),
                bucket = 750002,
            },
            exit = {
                coords = vec4( 129.97, -1285.58, -84.22, 181.42 ),
                bucket = 1,
            },
        },
    },
}

--- #endregion
--- 
configChairs = {
    "prop_air_bench_01",
    "hei_heist_stn_benchshort",
    "prop_air_bench_02",
    "prop_bench_01a",
    "prop_bench_01b",
    "prop_bench_01c",
    "prop_bench_02",
    "prop_bench_03",
    "prop_bench_04",
    "prop_bench_05",
    "prop_bench_06",
    "prop_bench_07",
    "prop_bench_08",
    "prop_bench_09",
    "prop_bench_10",
    "prop_bench_11",
    "prop_fib_3b_bench",
    "prop_table_01_chr_a",
    "prop_table_01_chr_b",
    "prop_table_02_chr",
    "prop_table_03_chr",
    "prop_table_03b_chr",
    "prop_table_04_chr",
    "prop_table_05_chr",
    "prop_table_06_chr",
    "prop_table_08_chr",
    "v_ilev_leath_chr",
    "apa_mp_h_din_chair_04",
    "apa_mp_h_din_chair_08",
    "apa_mp_h_din_chair_09",
    "apa_mp_h_din_chair_12",
    "apa_mp_h_stn_chairarm_01",
    "apa_mp_h_stn_chairarm_02",
    "apa_mp_h_stn_chairarm_03",
    "apa_mp_h_stn_chairarm_09",
    "apa_mp_h_stn_chairarm_11",
    "apa_mp_h_stn_chairarm_12",
    "apa_mp_h_stn_chairarm_13",
    "apa_mp_h_stn_chairarm_23",
    "apa_mp_h_stn_chairarm_24",
    "apa_mp_h_stn_chairarm_25",
    "apa_mp_h_stn_chairarm_26",
    "apa_mp_h_stn_chairstool_12",
    "apa_mp_h_stn_chairstrip_01",
    "apa_mp_h_stn_chairstrip_02",
    "apa_mp_h_stn_chairstrip_03",
    "apa_mp_h_stn_chairstrip_04",
    "apa_mp_h_stn_chairstrip_05",
    "apa_mp_h_stn_chairstrip_06",
    "apa_mp_h_stn_chairstrip_07",
    "apa_mp_h_stn_chairstrip_08",
    "apa_mp_h_yacht_armchair_01",
    "apa_mp_h_yacht_armchair_03",
    "apa_mp_h_yacht_armchair_04",
    "apa_mp_h_yacht_strip_chair_01",
    "bkr_prop_biker_boardchair01",
    "bkr_prop_biker_chair_01",
    "bkr_prop_biker_chairstrip_01",
    "bkr_prop_biker_chairstrip_02",
    "bkr_prop_clubhouse_armchair_01a",
    "bkr_prop_clubhouse_chair_01",
    "bkr_prop_clubhouse_offchair_01a",
    "bkr_prop_weed_chair_01a",
    "ex_mp_h_din_chair_04",
    "ex_mp_h_din_chair_08",
    "ex_mp_h_din_chair_09",
    "ex_mp_h_din_chair_12",
    "ex_mp_h_off_chairstrip_01",
    "ex_mp_h_off_easychair_01",
    "ex_mp_h_stn_chairarm_03",
    "ex_mp_h_stn_chairarm_24",
    "ex_mp_h_stn_chairstrip_01",
    "ex_mp_h_stn_chairstrip_010",
    "ex_mp_h_stn_chairstrip_011",
    "ex_mp_h_stn_chairstrip_05",
    "ex_mp_h_stn_chairstrip_07",
    "ex_prop_offchair_exec_01",
    "ex_prop_offchair_exec_02",
    "ex_prop_offchair_exec_03",
    "ex_prop_offchair_exec_04",
    "gr_prop_gr_chair02_ped",
    "gr_prop_gr_offchair_01a",
    "gr_prop_highendchair_gr_01a",
    "hei_heist_din_chair_01",
    "hei_heist_din_chair_02",
    "hei_heist_din_chair_03",
    "hei_heist_din_chair_04",
    "hei_heist_din_chair_05",
    "hei_heist_din_chair_06",
    "hei_heist_din_chair_08",
    "hei_heist_din_chair_09",
    "hei_heist_stn_chairarm_01",
    "hei_heist_stn_chairarm_03",
    "hei_heist_stn_chairarm_04",
    "hei_heist_stn_chairarm_06",
    "hei_heist_stn_chairstrip_01",
    "hei_prop_hei_skid_chair",
    "hei_prop_heist_off_chair",
    "imp_prop_impexp_offchair_01a",
    "p_armchair_01_s",
    "p_clb_officechair_s",
    "p_dinechair_01_s",
    "p_folding_chair_01_s",
    "p_ilev_p_easychair_s",
    "p_soloffchair_s",
    "p_yacht_chair_01_s",
    "prop_armchair_01",
    "prop_chair_01a",
    "prop_chair_01b",
    "prop_chair_02",
    "prop_chair_03",
    "prop_chair_04a",
    "prop_chair_04b",
    "prop_chair_05",
    "prop_chair_06",
    "prop_chair_07",
    "prop_chair_08",
    "prop_chair_09",
    "prop_chair_10",
    "prop_chair_pile_01",
    "prop_chateau_chair_01",
    "prop_clown_chair",
    "prop_cs_folding_chair_01",
    "prop_cs_office_chair",
    "prop_direct_chair_01",
    "prop_direct_chair_02",
    "prop_flipchair_01",
    "prop_gc_chair02",
    "prop_ld_farm_chair01",
    "prop_off_chair_01",
    "prop_off_chair_03",
    "prop_off_chair_04",
    "prop_off_chair_04_s",
    "prop_off_chair_04b",
    "prop_off_chair_05",
    "prop_old_deck_chair",
    "prop_old_deck_chair_02",
    "prop_old_wood_chair",
    "prop_old_wood_chair_lod",
    "prop_rock_chair_01",
    "prop_skid_chair_01",
    "prop_skid_chair_02",
    "prop_skid_chair_03",
    "prop_sol_chair",
    "prop_yaught_chair_01",
    "sm_prop_offchair_smug_01",
    "sm_prop_offchair_smug_02",
    "sm_prop_smug_offchair_01a",
    "v_club_officechair",
    "v_corp_bk_chair3",
    "v_corp_cd_chair",
    "v_corp_offchair",
    "v_ilev_chair02_ped",
    "v_ilev_hd_chair",
    "v_ilev_m_dinechair",
    "v_ilev_p_easychair",
    "v_res_m_l_chair1",
    "v_ret_fh_chair01",
    "v_ret_gc_chair03",
    "xm_base_cia_chair_conf",
    "xm_int_lev_sub_chair_01",
    "xm_int_lev_sub_chair_02",
    "xm_lab_chairarm_02",
    "xm_lab_chairarm_03",
    "xm_lab_chairarm_11",
    "xm_lab_chairarm_12",
    "xm_lab_chairarm_24",
    "xm_lab_chairarm_25",
    "xm_lab_chairarm_26",
    "xm_lab_chairstool_12",
    "xm_lab_easychair_01",
    "xm_mp_h_stn_chairarm_13",
    "xm_prop_x17_avengerchair",
    "xm_prop_x17_avengerchair_02",
    "xm_prop_x17_corp_offchair",
    "p_armchair_01_s_nany",
    "prop_chair_02_bunker",
    "bancodeluxe_gabund"

}
