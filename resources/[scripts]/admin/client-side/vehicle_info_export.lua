local KILOMETERS_PER_HOUR_PER_METER_PER_SECOND = 3.6
local VEHICLE_PROCESS_YIELD_INTERVAL = 25
local EXPORT_LANGUAGE_EN_US = "en-US"
local EXPORT_LANGUAGE_PT_BR = "pt-BR"

---@type table<string, string>
local gEnglishExportKeys = {
    exportId = "export_id",
    cityName = "city_name",
    generatedAt = "generated_at",
    displayName = "display_name",
    displayLabel = "display_label",
    estimatedMaxSpeed = "estimated_max_speed",
    metersPerSecond = "meters_per_second",
    kilometersPerHour = "kilometers_per_hour",
    maxKnots = "max_knots",
}

---@type table<string, string>
local gPortugueseExportKeys = {
    metadata = "metadados",
    exportId = "id_exportacao",
    cityName = "cidade",
    generatedAt = "gerado_em",
    language = "idioma",
    successes = "sucessos",
    failures = "falhas",
    vehicles = "veiculos",
    catalog = "catalogo",
    error = "erro",
    displayName = "nome_exibicao",
    displayLabel = "rotulo_exibicao",
    seats = "assentos",
    performance = "desempenho",
    estimatedMaxSpeed = "velocidade_maxima_estimada",
    metersPerSecond = "metros_por_segundo",
    kilometersPerHour = "quilometros_por_hora",
    acceleration = "aceleracao",
    braking = "frenagem",
    traction = "tracao",
    maxKnots = "nos_maximos",
}

---@type table<string, string>
local gPortugueseCatalogKeys = {
    VehicleType = "tipo_veiculo",
    Price = "preco",
    Weight = "tamanho_bau",
    Name = "nome",
    Gems = "gemas",
}

---@class VehicleCatalogEntry
---@field spawn string
---@field catalog table

---@class VehicleInfoExportMetadata
---@field exportId string
---@field cityName string
---@field generatedAt string
---@field language string

---@class VehicleInfoExport: VehicleInfoExportMetadata
---@field total number
---@field successes number
---@field failures number
---@field vehicles table[]

---@class VehicleInfoExportDocumentMetadata: VehicleInfoExportMetadata
---@field total number
---@field successes number
---@field failures number

---@class VehicleInfoExportDocument
---@field metadata VehicleInfoExportDocumentMetadata
---@field vehicles table[]

---@type VehicleInfoExport | nil
local gVehicleInfoExport = nil

---@return string | nil language
local function SelectVehicleInfoExportLanguage()

    local input = lib.inputDialog(_t("vehicle_info_export.language.heading"), {
        {
            type = "select",
            label = _t("vehicle_info_export.language.label"),
            description = _t("vehicle_info_export.language.description"),
            options = {
                { value = EXPORT_LANGUAGE_PT_BR, label = "Português (Brasil)" },
                { value = EXPORT_LANGUAGE_EN_US, label = "English" },
            },
            default = EXPORT_LANGUAGE_PT_BR,
            required = true,
            clearable = false,
        },
    })

    if not input or not input[1] then
        return nil
    end

    return input[1]
end

---@param value number
---@return table
local function GetSpeedInfo(value)

    return {
        metersPerSecond = value,
        kilometersPerHour = value * KILOMETERS_PER_HOUR_PER_METER_PER_SECOND,
    }
end

---@param modelHash number
---@return boolean
local function IsVehicleModelAvailable(modelHash)

    return modelHash ~= 0 and IsModelInCdimage(modelHash) and IsModelValid(modelHash) and IsModelAVehicle(modelHash)
end

---@param spawn string
---@param catalog table
---@return table vehicleInfo
local function GetVehicleInfo(spawn, catalog)

    local modelHash = GetHashKey(spawn)
    local vehicleInfo = {
        spawn = spawn,
        hash = modelHash,
        catalog = {
            VehicleType = catalog.VehicleType,
            Price = catalog.Price,
            Weight = catalog.Weight,
            Name = catalog.Name,
            Gems = catalog.Gems,
        },
    }

    if not IsVehicleModelAvailable(modelHash) then
        vehicleInfo.error = "spawn_not_found"
        return vehicleInfo
    end

    local displayName = GetDisplayNameFromVehicleModel(modelHash)
    local displayLabel = GetLabelText(displayName)

    vehicleInfo.displayName = displayName
    vehicleInfo.displayLabel = displayLabel == "NULL" and nil or displayLabel
    vehicleInfo.seats = GetVehicleModelNumberOfSeats(modelHash)
    vehicleInfo.performance = {
        estimatedMaxSpeed = GetSpeedInfo(GetVehicleModelEstimatedMaxSpeed(modelHash)),
        acceleration = GetVehicleModelAcceleration(modelHash),
        braking = GetVehicleModelMaxBraking(modelHash),
        traction = GetVehicleModelMaxTraction(modelHash),
        maxKnots = catalog.VehicleType == "boat" and GetVehicleModelMaxKnots(modelHash) or nil,
    }

    return vehicleInfo
end

---@return VehicleCatalogEntry[] vehicles
local function GetVehicleInfoExportVehicles()

    local vehicles = {}

    for spawn, catalog in pairs(VehicleGlobal()) do
        vehicles[#vehicles + 1] = {
            spawn = spawn,
            catalog = catalog,
        }
    end

    table.sort(vehicles, function(left, right)

        return left.spawn < right.spawn
    end)

    return vehicles
end

---@param metadata VehicleInfoExportMetadata
---@param total number
---@param language string
---@return VehicleInfoExport vehicleInfoExport
local function CreateVehicleInfoExport(metadata, total, language)

    return {
        exportId = metadata.exportId,
        cityName = metadata.cityName,
        generatedAt = metadata.generatedAt,
        language = language,
        total = total,
        successes = 0,
        failures = 0,
        vehicles = {},
    }
end

---@param vehicleInfoExport VehicleInfoExport
---@param vehicle VehicleCatalogEntry
local function AddVehicleInfoToExport(vehicleInfoExport, vehicle)

    local vehicleInfo = GetVehicleInfo(vehicle.spawn, vehicle.catalog)

    if vehicleInfo.error then
        vehicleInfoExport.failures = vehicleInfoExport.failures + 1
        return
    end

    vehicleInfoExport.successes = vehicleInfoExport.successes + 1
    vehicleInfoExport.vehicles[#vehicleInfoExport.vehicles + 1] = vehicleInfo
end

---@param value any
---@param keyNames table<string, string>
---@param catalogKeyNames table<string, string> | nil
---@return any translatedValue
local function TranslateVehicleInfoExportValue(value, keyNames, catalogKeyNames)

    if type(value) ~= "table" then
        return value
    end

    local translatedValue = {}

    for key, childValue in pairs(value) do
        local translatedKey = keyNames[key] or key

        if key == "catalog" then
            if not catalogKeyNames then
                translatedValue[translatedKey] = childValue
            else
                local translatedCatalog = {}

                for catalogKey, catalogValue in pairs(childValue) do
                    translatedCatalog[catalogKeyNames[catalogKey] or catalogKey] = catalogValue
                end

                translatedValue[translatedKey] = translatedCatalog
            end
        else
            translatedValue[translatedKey] = TranslateVehicleInfoExportValue(childValue, keyNames, catalogKeyNames)
        end
    end

    return translatedValue
end

---@param vehicleInfoExport VehicleInfoExport
---@return VehicleInfoExportDocument document
local function CreateVehicleInfoExportDocument(vehicleInfoExport)

    return {
        metadata = {
            exportId = vehicleInfoExport.exportId,
            cityName = vehicleInfoExport.cityName,
            generatedAt = vehicleInfoExport.generatedAt,
            language = vehicleInfoExport.language,
            total = vehicleInfoExport.total,
            successes = vehicleInfoExport.successes,
            failures = vehicleInfoExport.failures,
        },
        vehicles = vehicleInfoExport.vehicles,
    }
end

---@param vehicleInfoExport VehicleInfoExport
---@return VehicleInfoExportDocument | table content
local function GetVehicleInfoExportContent(vehicleInfoExport)

    local document = CreateVehicleInfoExportDocument(vehicleInfoExport)

    if vehicleInfoExport.language == EXPORT_LANGUAGE_PT_BR then
        return TranslateVehicleInfoExportValue(document, gPortugueseExportKeys, gPortugueseCatalogKeys)
    end

    return TranslateVehicleInfoExportValue(document, gEnglishExportKeys, nil)
end

---@param vehicleInfoExport VehicleInfoExport
local function CompleteVehicleInfoExport(vehicleInfoExport)

    if gVehicleInfoExport ~= vehicleInfoExport then
        sx.logger:warn(("Vehicle info export completion ignored for export %s"):format(vehicleInfoExport.exportId))
        return
    end

    local content = json.encode(GetVehicleInfoExportContent(vehicleInfoExport), { indent = true })
    lib.setClipboard(content)
    lib.notify({
        title = "Exportação de veículos",
        description = ("%d veículos exportados: %d sucesso(s), %d falha(s). O JSON está no clipboard; use Ctrl+C para copiá-lo."):format(vehicleInfoExport.total, vehicleInfoExport.successes, vehicleInfoExport.failures),
        type = "success",
    })
    sx.logger:info(("Vehicle info export %s completed with %d successes and %d failures"):format(vehicleInfoExport.exportId, vehicleInfoExport.successes, vehicleInfoExport.failures))
end

---@param vehicleInfoExport VehicleInfoExport
---@param vehicles VehicleCatalogEntry[]
local function ProcessVehicleInfoExport(vehicleInfoExport, vehicles)

    for index, vehicle in ipairs(vehicles) do
        if gVehicleInfoExport ~= vehicleInfoExport then
            sx.logger:warn(("Vehicle info export processing interrupted for export %s"):format(vehicleInfoExport.exportId))
            return
        end

        AddVehicleInfoToExport(vehicleInfoExport, vehicle)

        if index % VEHICLE_PROCESS_YIELD_INTERVAL == 0 then
            Wait(0)
        end
    end

    CompleteVehicleInfoExport(vehicleInfoExport)
end

---@param metadata VehicleInfoExportMetadata
local function StartVehicleInfoExport(metadata)

    local language = SelectVehicleInfoExportLanguage()

    if not language then
        return
    end

    local vehicles = GetVehicleInfoExportVehicles()
    local vehicleInfoExport = CreateVehicleInfoExport(metadata, #vehicles, language)

    gVehicleInfoExport = vehicleInfoExport

    CreateThread(function()

        ProcessVehicleInfoExport(vehicleInfoExport, vehicles)
    end)
end

RegisterNetEvent("admin:VehicleInfoExport:Start", function(metadata)

    StartVehicleInfoExport(metadata)
end)
