---@type number
bProtectionTime = 900 -- 900 - 15 minutes
bProtectionDelay = 1 -- 1 - 1 minutes
bHireProtectionTime = 300 -- ENG-3994: 5 minutes corridos após a contratação

-- ENG-3993: a proteção do iniciante vale em todas as cidades; liste aqui só a cidade que precisar desligar.
-- (A lista de cidades ligadas ficou vazia desde a ENG-3724 e a proteção não iniciava em nenhuma cidade.)
---@type table<string, boolean>
bProtectionDisabledCities = {}
