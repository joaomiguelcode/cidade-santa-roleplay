local T_CONFIRMED = "Confirmed"
local T_WARNING = "Warning"
local T_INFORMATION = "Information"

local vehicleRewindNotifies = {
    ["pt-br"] = {
        ["#vehicleRewindInvalidSeconds"] = { title = "Rebobinagem", message = "Use uma duração entre 1 e 15 segundos.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNotDriver"] = { title = "Rebobinagem", message = "Você precisa estar dirigindo um veículo para rebobiná-lo.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNetworkUnavailable"] = { title = "Rebobinagem", message = "Não foi possível sincronizar o veículo. Tente novamente em instantes.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoHistory"] = { title = "Rebobinagem", message = "Ainda não há histórico suficiente desse veículo.", type = T_INFORMATION, duration = 5000 },
        ["#vehicleRewindInProgress"] = { title = "Rebobinagem", message = "Já existe uma rebobinagem em andamento.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoControl"] = { title = "Rebobinagem", message = "Não foi possível assumir o controle do veículo.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindInterrupted"] = { title = "Rebobinagem", message = "A rebobinagem do veículo foi interrompida.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindComplete"] = { title = "Rebobinagem", message = "Rebobinagem do veículo concluída.", type = T_CONFIRMED, duration = 5000 },
    },
    ["en-us"] = {
        ["#vehicleRewindInvalidSeconds"] = { title = "Vehicle rewind", message = "Use a rewind duration between 1 and 15 seconds.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNotDriver"] = { title = "Vehicle rewind", message = "You need to be driving a vehicle to rewind it.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNetworkUnavailable"] = { title = "Vehicle rewind", message = "The vehicle could not be synchronized. Please try again shortly.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoHistory"] = { title = "Vehicle rewind", message = "There is not enough vehicle history yet.", type = T_INFORMATION, duration = 5000 },
        ["#vehicleRewindInProgress"] = { title = "Vehicle rewind", message = "A vehicle rewind is already in progress.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoControl"] = { title = "Vehicle rewind", message = "Unable to take control of this vehicle.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindInterrupted"] = { title = "Vehicle rewind", message = "Vehicle rewind was interrupted.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindComplete"] = { title = "Vehicle rewind", message = "Vehicle rewind complete.", type = T_CONFIRMED, duration = 5000 },
    },
    ["es-es"] = {
        ["#vehicleRewindInvalidSeconds"] = { title = "Rebobinado", message = "Usa una duración entre 1 y 15 segundos.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNotDriver"] = { title = "Rebobinado", message = "Debes estar conduciendo un vehículo para rebobinarlo.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNetworkUnavailable"] = { title = "Rebobinado", message = "No se pudo sincronizar el vehículo. Inténtalo de nuevo en unos instantes.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoHistory"] = { title = "Rebobinado", message = "Aún no hay suficiente historial de este vehículo.", type = T_INFORMATION, duration = 5000 },
        ["#vehicleRewindInProgress"] = { title = "Rebobinado", message = "Ya hay un rebobinado de vehículo en curso.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoControl"] = { title = "Rebobinado", message = "No se pudo tomar el control de este vehículo.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindInterrupted"] = { title = "Rebobinado", message = "El rebobinado del vehículo fue interrumpido.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindComplete"] = { title = "Rebobinado", message = "Rebobinado del vehículo completado.", type = T_CONFIRMED, duration = 5000 },
    },
    ["pt-pt"] = {
        ["#vehicleRewindInvalidSeconds"] = { title = "Retrocesso", message = "Utilize uma duração entre 1 e 15 segundos.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNotDriver"] = { title = "Retrocesso", message = "Tem de estar a conduzir um veículo para o fazer recuar.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNetworkUnavailable"] = { title = "Retrocesso", message = "Não foi possível sincronizar o veículo. Tente novamente dentro de instantes.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoHistory"] = { title = "Retrocesso", message = "Ainda não existe histórico suficiente deste veículo.", type = T_INFORMATION, duration = 5000 },
        ["#vehicleRewindInProgress"] = { title = "Retrocesso", message = "Já existe um retrocesso de veículo em curso.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoControl"] = { title = "Retrocesso", message = "Não foi possível assumir o controlo do veículo.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindInterrupted"] = { title = "Retrocesso", message = "O retrocesso do veículo foi interrompido.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindComplete"] = { title = "Retrocesso", message = "Retrocesso do veículo concluído.", type = T_CONFIRMED, duration = 5000 },
    },
    ["fr-fr"] = {
        ["#vehicleRewindInvalidSeconds"] = { title = "Retour véhicule", message = "Utilisez une durée entre 1 et 15 secondes.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNotDriver"] = { title = "Retour véhicule", message = "Vous devez conduire un véhicule pour le rembobiner.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNetworkUnavailable"] = { title = "Retour véhicule", message = "Le véhicule n'a pas pu être synchronisé. Réessayez dans un instant.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoHistory"] = { title = "Retour véhicule", message = "L'historique de ce véhicule n'est pas encore suffisant.", type = T_INFORMATION, duration = 5000 },
        ["#vehicleRewindInProgress"] = { title = "Retour véhicule", message = "Un retour de véhicule est déjà en cours.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoControl"] = { title = "Retour véhicule", message = "Impossible de prendre le contrôle de ce véhicule.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindInterrupted"] = { title = "Retour véhicule", message = "Le retour du véhicule a été interrompu.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindComplete"] = { title = "Retour véhicule", message = "Retour du véhicule terminé.", type = T_CONFIRMED, duration = 5000 },
    },
    ["ar-sa"] = {
        ["#vehicleRewindInvalidSeconds"] = { title = "إرجاع المركبة", message = "استخدم مدة بين ثانية واحدة و15 ثانية.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNotDriver"] = { title = "إرجاع المركبة", message = "يجب أن تكون تقود مركبة لإرجاعها.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNetworkUnavailable"] = { title = "إرجاع المركبة", message = "تعذر مزامنة المركبة. حاول مرة أخرى بعد لحظات.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoHistory"] = { title = "إرجاع المركبة", message = "لا يوجد سجل كافٍ لهذه المركبة بعد.", type = T_INFORMATION, duration = 5000 },
        ["#vehicleRewindInProgress"] = { title = "إرجاع المركبة", message = "توجد عملية إرجاع للمركبة قيد التنفيذ بالفعل.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindNoControl"] = { title = "إرجاع المركبة", message = "تعذر التحكم بهذه المركبة.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindInterrupted"] = { title = "إرجاع المركبة", message = "تمت مقاطعة إرجاع المركبة.", type = T_WARNING, duration = 5000 },
        ["#vehicleRewindComplete"] = { title = "إرجاع المركبة", message = "اكتملت عملية إرجاع المركبة.", type = T_CONFIRMED, duration = 5000 },
    },
}

assert(notifyConfig, "zz_vehicle_rewind.lua must load after shared/notify/shared.lua")

for lang, entries in pairs(vehicleRewindNotifies) do
    if notifyConfig[lang] then
        for key, data in pairs(entries) do
            notifyConfig[lang][key] = {
                ["title"] = data.title,
                ["message"] = data.message,
                ["type"] = data.type,
                ["duration"] = data.duration,
            }
        end
    end
end
