cityName = GetConvar("cityName", "")

---@type table<string, table<integer, table<integer, boolean>>>
-- Regra por grupo: [nível do espectador] = { [nível do alvo] = true }.
-- A matriz é explícita para comportar exceções; por exemplo, Afiliado 2 pode
-- espectar apenas Afiliado 4 e 5 com [2] = { [4] = true, [5] = true }.
CAN_SPEC_IN_AFFILIATE_WORLD_CONFIG = {
    ["Afiliado"] = {
        [1] = { [2] = true, [3] = true, [4] = true, [5] = true }, -- Afiliado 1 → 2, 3, 4 e 5.
        [2] = { [3] = true, [4] = true, [5] = true },             -- Afiliado 2 → 3, 4 e 5.
    },
}

---@class VehicleRewindConfig
---@field command string
---@field defaultSeconds number
---@field minSeconds number
---@field maxSeconds number
---@field sampleIntervalMs number
---@field speedMultiplier number
---@field requestTimeoutMs number
---@field controlTimeoutMs number
---@field networkIdRetryTimeoutMs number
---@field vehicleLeaveResetDelayMs number
---@field historySampleGapResetDelayMs number
gVehicleRewindConfig = {
    command = "rewind",
    defaultSeconds = 5,
    minSeconds = 1,
    maxSeconds = 15,
    sampleIntervalMs = 33,
    speedMultiplier = 1.25,
    requestTimeoutMs = 2000,
    controlTimeoutMs = 1500,
    networkIdRetryTimeoutMs = 1000,
    vehicleLeaveResetDelayMs = 2000,
    historySampleGapResetDelayMs = 500,
}

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

banConfig = {
    ["ADV"] = {
        ["Heading"] = _t("warn_user"),
        ["Button"] = _t("warn_button"),
        ["Info"] = {
            { name = _t("select_option"), value = "1", fine = 5000 },
            { name = _t("warn_looting"), value = "120", fine = 5000 },
            { name = _t("warn_force_rp"), value = "120", fine = 5000 },
            { name = _t("warn_anti_rp"), value = "720", fine = 5000 },
            { name = _t("warn_no_faction"), value = "120", fine = 5000 },
            { name = _t("warn_rdm"), value = "720", fine = 5000 },
            { name = _t("warn_toxic"), value = "720", fine = 5000 },
            { name = _t("warn_vdm"), value = "720", fine = 5000 },
            { name = _t("warn_no_value_life"), value = "250", fine = 5000 },
            { name = _t("warn_combat_logging"), value = "720", fine = 5000 },
            { name = _t("warn_meta_gaming"), value = "600", fine = 5000 },
            { name = _t("warn_cop_bait"), value = "600", fine = 5000 },
            { name = _t("warn_revenge_kill"), value = "600", fine = 5000 },
            { name = _t("warn_return_action"), value = "600", fine = 5000 },
            { name = _t("warn_bug_abuse"), value = "600", fine = 5000 },
        },

    },
    ["BAN"] = {
        ["Heading"] = _t("ban_user"),
        ["Button"] = _t("ban_button"),
        ["Info"] = {
            { name = _t("select_option"), value = "1" },
            { name = _t("ban_swearing"), value = "99999" },
            { name = _t("ban_disrespect"), value = "99999" },
            { name = _t("ban_illegal_programs"), value = "99999" },
            { name = _t("ban_dark_rp"), value = "99999" },
            { name = _t("ban_hacker"), value = "99999" },
        }
    }
}

if cityName == "Santa" then
    banConfig["ADV"]["Info"] = {
        { name = _t("select_option"), value = "1", fine = 5000 },
        { name = _t("warn_force_rp"), value = "120", fine = 5000 },
        { name = _t("warn_anti_rp"), value = "720", fine = 5000 },
        { name = _t("warn_no_faction"), value = "120", fine = 5000 },
        { name = _t("warn_rdm"), value = "720", fine = 5000 },
        { name = _t("warn_toxic"), value = "720", fine = 5000 },
        { name = _t("warn_vdm"), value = "720", fine = 5000 },
        { name = _t("warn_no_value_life"), value = "250", fine = 5000 },
        { name = _t("warn_combat_logging"), value = "720", fine = 5000 },
        { name = _t("warn_meta_gaming"), value = "600", fine = 5000 },
        { name = _t("warn_cop_bait"), value = "600", fine = 5000 },
        { name = _t("warn_revenge_kill"), value = "600", fine = 5000 },
        { name = _t("warn_return_action"), value = "600", fine = 5000 },
        { name = _t("warn_bug_abuse"), value = "600", fine = 5000 },
    }

elseif cityName == "Nobre" then
    banConfig["ADV"]["Info"] = {
        { name = _t("select_option"), value = "1", fine = 5000 },
        { name = _t("warn_force_rp"), value = "120", fine = 5000 },
        { name = _t("warn_anti_rp"), value = "720", fine = 5000 },
        { name = _t("warn_no_faction"), value = "120", fine = 5000 },
        { name = _t("warn_rdm"), value = "720", fine = 5000 },
        { name = _t("warn_toxic"), value = "720", fine = 5000 },
        { name = _t("warn_vdm"), value = "720", fine = 5000 },
        { name = _t("warn_no_value_life"), value = "250", fine = 5000 },
        { name = _t("warn_combat_logging"), value = "720", fine = 5000 },
        { name = _t("warn_meta_gaming"), value = "600", fine = 5000 },
        { name = _t("warn_cop_bait"), value = "600", fine = 5000 },
        { name = _t("warn_revenge_kill"), value = "600", fine = 5000 },
        { name = _t("warn_return_action"), value = "600", fine = 5000 },
        { name = _t("warn_bug_abuse"), value = "600", fine = 5000 },
    }
elseif cityName == "Malta" then
    banConfig["ADV"]["Info"] = {
        { name = _t("select_option"), value = "1", fine = 5000 },
        { name = _t("warn_looting"), value = "120", fine = 5000 },
        { name = _t("warn_force_rp"), value = "120", fine = 5000 },
        { name = _t("warn_anti_rp"), value = "720", fine = 5000 },
        { name = _t("warn_no_faction"), value = "120", fine = 5000 },
        { name = _t("warn_rdm"), value = "720", fine = 5000 },
        { name = _t("warn_toxic"), value = "720", fine = 5000 },
        { name = _t("warn_vdm"), value = "720", fine = 5000 },
        { name = _t("warn_no_value_life"), value = "250", fine = 5000 },
        { name = _t("warn_combat_logging"), value = "720", fine = 5000 },
        { name = _t("warn_meta_gaming"), value = "600", fine = 5000 },
        { name = _t("warn_cop_bait"), value = "600", fine = 5000 },
        { name = _t("warn_revenge_kill"), value = "600", fine = 5000 },
        { name = _t("warn_return_action"), value = "600", fine = 5000 },
        { name = _t("warn_bug_abuse"), value = "600", fine = 5000 },
        { name = "Fuzil sul", value = "120", fine = 5000 },
    }

elseif cityName == "Alexandria" then
    banConfig["ADV"]["Info"] = {
        { name = _t("select_option"), value = "1", fine = 5000 },
        { name = _t("warn_rdm"), value = "240", fine = 5000 },
        { name = _t("warn_vdm"), value = "240", fine = 5000 },
        { name = "CL", value = "360", fine = 5000 },
        { name = "Horário pacificado", value = "120", fine = 5000 },
        { name = "Quebra de regras", value = "120", fine = 5000 },
        { name = "Ação sem identificação", value = "120", fine = 5000 },
        { name = "Fuzil sul", value = "120", fine = 5000 },
        { name = _t("warn_toxic"), value = "360", fine = 5000 },
        { name = "Quebra de regras FacXFac", value = "180", fine = 5000 },
        { name = "Nível 5", value = "720", fine = 5000 },
    }
end
