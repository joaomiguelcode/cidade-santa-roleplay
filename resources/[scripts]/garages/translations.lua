lang = GetConvar("language", "pt-br") or "pt-br"
translations = {
    ["en-us"] = {
        ["openGarages"] = "Open Garage",
        ["plate"] = "plate",
        ["command.plate"] = "plate",
        ["buyVehicleRequest"] = "Buy %s for $%s?",
        ["buyVehicleYes"] = "Yes, complete payment",
        ["buyVehicleNo"] = "No, changed my mind",
        ["vehicleReleaseRequest"] = "Vehicle release costs $%s dollars, do you want to proceed with the release?",
        ["days"] = "Days",
        ["hours"] = "Hours",
        ["minutes"] = "Minutes",
        ["seconds"] = "Seconds",
        ["privateWorldVehicleCooldown"] = "Wait %d seconds before spawning another vehicle in a private world.",

        ["arrestRequest"] = "Arrest the vehicle?",
        ["arrestYes"] = "Yes, complete arrest",
        ["arrestNo"] = "No, changed my mind",

        ["garages.temp.grant.min_days"] = "Minimum duration for this temporary vehicle assignment is %s day(s). Increase the value to continue.",
        ["garages.temp.grant.max_days"] = "Maximum duration for this temporary vehicle assignment is %s day(s). Lower the value to continue.",
        ["garages.temp.grant.model_not_found"] = "Enter a valid vehicle spawn name.",
        ["garages.temp.grant.success"] = "Temporary vehicle assigned successfully.",
        ["garages.temp.grant.renewed"] = "This vehicle is already in the garage — the deadline has been updated.",
        ["garages.temp.clear.not_found"] = "No temporary vehicle assignment matches this plate — it may have already expired or never been issued.",
        ["garages.temp.clear.success"] = "Temporary vehicle access removed. The player no longer has use of this vehicle until a new assignment is made.",
        ["garages.temp.purchase_unavailable"] = "This vehicle is unavailable for purchase at the moment.",
    },

    ["pt-br"] = {
        ["openGarages"] = "Abrir Garagem",
        ["plate"] = "placa",
        ["command.plate"] = "placa",
        ["buyVehicleRequest"] = "Comprar %s por $%s?",
        ["buyVehicleYes"] = "Sim, concluír pagamento",
        ["buyVehicleNo"] = "Não, mudei de ideia",
        ["vehicleReleaseRequest"] = "A liberação do veículo tem o custo de $%s dólares, deseja prosseguir com a liberação do mesmo?",
        ["days"] = "Dias",
        ["hours"] = "Horas",
        ["minutes"] = "Minutos",
        ["seconds"] = "Segundos",
        ["privateWorldVehicleCooldown"] = "Aguarde %d segundos para spawnar outro veículo em um mundo privado.",

        ["arrestRequest"] = "Apreender o veículo?",
        ["arrestYes"] = "Sim, concluír apreensão",
        ["arrestNo"] = "Não, mudei de ideia",

        ["garages.temp.grant.min_days"] = "O prazo mínimo de cedência deste veículo temporário é de %s dia(s). Aumente o prazo para prosseguir.",
        ["garages.temp.grant.max_days"] = "O prazo máximo de cedência deste veículo temporário é de %s dia(s). Reduza o prazo para prosseguir.",
        ["garages.temp.grant.model_not_found"] = "Indique um nome de spawn de veículo válido.",
        ["garages.temp.grant.success"] = "Veículo temporário atribuído com sucesso.",
        ["garages.temp.grant.renewed"] = "Este veículo já estava na garagem — o prazo foi atualizado.",
        ["garages.temp.clear.not_found"] = "Não há cedência temporária ativa para esta placa — pode já ter vencido ou nunca ter sido atribuída.",
        ["garages.temp.clear.success"] = "Cedência temporária encerrada com sucesso. O veículo deixa de estar disponível para o jogador até uma nova cedência.",
        ["garages.temp.purchase_unavailable"] = "Este veiculo esta indisponivel para venda no momento.",
    },

    ["es-es"] = {
        ["openGarages"] = "Abrir Garaje",
        ["plate"] = "matrícula",
        ["command.plate"] = "matrícula",
        ["buyVehicleRequest"] = "¿Comprar %s por $%s?",
        ["buyVehicleYes"] = "Sí, completar pago",
        ["buyVehicleNo"] = "No, he cambiado de opinión",
        ["vehicleReleaseRequest"] = "La liberación del vehículo tiene un costo de $%s dólares, ¿desea proceder con la liberación?",
        ["days"] = "Días",
        ["hours"] = "Horas",
        ["minutes"] = "Minutos",
        ["seconds"] = "Segundos",
        ["privateWorldVehicleCooldown"] = "Espera %d segundos antes de generar otro vehículo en un mundo privado.",

        ["arrestRequest"] = "Apreender el vehículo?",
        ["arrestYes"] = "Sí, concluir aprehensión",
        ["arrestNo"] = "No, he cambiado de opinión",

        ["garages.temp.grant.min_days"] = "La duración mínima de cesión temporal de este vehículo es de %s día(s). Aumenta el valor para continuar.",
        ["garages.temp.grant.max_days"] = "La duración máxima de cesión temporal de este vehículo es de %s día(s). Reduce el plazo para continuar.",
        ["garages.temp.grant.model_not_found"] = "Indica un nombre de spawn de vehículo válido.",
        ["garages.temp.grant.success"] = "Vehículo temporal asignado correctamente.",
        ["garages.temp.grant.renewed"] = "Este vehículo ya estaba en el garaje — se ha actualizado el plazo.",
        ["garages.temp.clear.not_found"] = "No hay una cesión temporal activa para esta matrícula: puede haber expirado o no haberse asignado.",
        ["garages.temp.clear.success"] = "Cesión temporal revocada correctamente. El vehículo deja de estar disponible para el jugador hasta una nueva asignación.",
        ["garages.temp.purchase_unavailable"] = "Este vehiculo no esta disponible para la venta en este momento.",
    },

    ["pt-pt"] = {
        ["openGarages"] = "Abrir Garagem",
        ["plate"] = "matrícula",
        ["buyVehicleRequest"] = "Comprar %s por $%s?",
        ["buyVehicleYes"] = "Sim, concluir pagamento",
        ["buyVehicleNo"] = "Não, mudei de ideia",
        ["vehicleReleaseRequest"] = "A libertação do veículo tem o custo de $%s dólares, deseja prosseguir com a libertação do mesmo?",
        ["days"] = "Dias",
        ["hours"] = "Horas",
        ["minutes"] = "Minutos",
        ["seconds"] = "Segundos",
        ["privateWorldVehicleCooldown"] = "Aguarda %d segundos antes de gerar outro veículo num mundo privado.",

        ["arrestRequest"] = "Apreender o veículo?",
        ["arrestYes"] = "Sim, concluír apreensão",
        ["arrestNo"] = "Não, mudei de ideia",

        ["garages.temp.grant.min_days"] = "A duração mínima de cedência deste veículo temporário é de %s dia(s). Aumenta o valor para continuar.",
        ["garages.temp.grant.max_days"] = "A duração máxima de cedência deste veículo temporário é de %s dia(s). Reduz o prazo para continuar.",
        ["garages.temp.grant.model_not_found"] = "Indica um nome de spawn de veículo válido.",
        ["garages.temp.grant.success"] = "Veículo temporário atribuído com sucesso.",
        ["garages.temp.grant.renewed"] = "Este veículo já estava na garagem — o prazo foi atualizado.",
        ["garages.temp.clear.not_found"] = "Não existe cedência temporária ativa para esta matrícula — pode já ter expirado ou nunca ter sido atribuída.",
        ["garages.temp.clear.success"] = "Cedência temporária concluída com sucesso. O veículo deixa de estar disponível para o jogador até nova cedência.",
        ["garages.temp.purchase_unavailable"] = "Este veiculo esta indisponivel para venda no momento.",
    },

    ["fr-fr"] = {
        ["openGarages"] = "Ouvrir le garage",
        ["plate"] = "plaque",
        ["command.plate"] = "plaque",
        ["buyVehicleRequest"] = "Acheter %s pour $%s ?",
        ["buyVehicleYes"] = "Oui, finaliser le paiement",
        ["buyVehicleNo"] = "Non, j'ai changé d'avis",
        ["vehicleReleaseRequest"] = "La libération du véhicule coûte $%s dollars, souhaitez-vous procéder à sa libération ?",
        ["days"] = "Jours",
        ["hours"] = "Heures",
        ["minutes"] = "Minutes",
        ["seconds"] = "Secondes",
        ["privateWorldVehicleCooldown"] = "Attendez %d secondes avant de faire apparaître un autre véhicule dans un monde privé.",
    
        ["arrestRequest"] = "Saisir le véhicule ?",
        ["arrestYes"] = "Oui, finaliser la saisie",
        ["arrestNo"] = "Non, j'ai changé d'avis",

        ["garages.temp.grant.min_days"] = "La durée minimale d’attribution temporaire de ce véhicule est de %s jour(s). Augmentez la valeur pour continuer.",
        ["garages.temp.grant.max_days"] = "La durée maximale d’attribution temporaire de ce véhicule est de %s jour(s). Réduisez la durée pour continuer.",
        ["garages.temp.grant.model_not_found"] = "Indiquez un nom de spawn de véhicule valide.",
        ["garages.temp.grant.success"] = "Véhicule temporaire attribué avec succès.",
        ["garages.temp.grant.renewed"] = "Ce véhicule était déjà au garage — la date limite a été mise à jour.",
        ["garages.temp.clear.not_found"] = "Aucune attribution temporaire ne correspond à cette plaque — elle a peut‑être expiré ou n’a jamais été enregistrée.",
        ["garages.temp.clear.success"] = "Attribution temporaire révoquée. Le joueur n’a plus accès à ce véhicule tant qu’une nouvelle attribution n’est pas effectuée.",
        ["garages.temp.purchase_unavailable"] = "Ce vehicule n'est pas disponible a la vente pour le moment.",
    },

    ["de-de"] = {
        ["openGarages"] = "Garage öffnen",
        ["plate"] = "Kennzeichen",
        ["command.plate"] = "Kennzeichen",
        ["buyVehicleRequest"] = "%s für $%s kaufen?",
        ["buyVehicleYes"] = "Ja, Kauf abschließen",
        ["buyVehicleNo"] = "Nein, ich habe mich anders entschieden",
        ["vehicleReleaseRequest"] = "Die Freigabe des Fahrzeugs kostet $%s. Möchtest du fortfahren?",
        ["days"] = "Tage",
        ["hours"] = "Stunden",
        ["minutes"] = "Minuten",
        ["seconds"] = "Sekunden",
        ["privateWorldVehicleCooldown"] = "Warte %d Sekunden, bevor du ein weiteres Fahrzeug in einer privaten Welt spawnst.",
        ["arrestRequest"] = "Fahrzeug beschlagnahmen?",
        ["arrestYes"] = "Ja, Beschlagnahme abschließen",
        ["arrestNo"] = "Nein, ich habe mich anders entschieden",

        ["garages.temp.grant.min_days"] = "Mindestdauer für diese temporäre Fahrzeugzuweisung: %s Tag(e). Erhöhe den Wert, um fortzufahren.",
        ["garages.temp.grant.max_days"] = "Höchstdauer für diese temporäre Fahrzeugzuweisung: %s Tag(e). Reduziere die Dauer, um fortzufahren.",
        ["garages.temp.grant.model_not_found"] = "Gib einen gültigen Fahrzeug-Spawn-Namen ein.",
        ["garages.temp.grant.success"] = "Temporäres Fahrzeug erfolgreich zugewiesen.",
        ["garages.temp.grant.renewed"] = "Dieses Fahrzeug stand bereits in der Garage — die Frist wurde aktualisiert.",
        ["garages.temp.clear.not_found"] = "Keine passende temporäre Zuweisung für dieses Kennzeichen — abgelaufen oder nie vergeben.",
        ["garages.temp.clear.success"] = "Temporäre Zuweisung aufgehoben. Der Spieler hat keinen Zugriff mehr, bis eine neue Zuweisung erfolgt.",
        ["garages.temp.purchase_unavailable"] = "Dieses Fahrzeug ist derzeit nicht zum Kauf verfuegbar.",
    },
    ["ar-sa"] = {
        ["openGarages"] = "فتح المرآب",
        ["plate"] = "لوحة",
        ["command.plate"] = "لوحة",
        ["buyVehicleRequest"] = "شراء %s بـ $%s؟",
        ["buyVehicleYes"] = "نعم، إتمام الدفع",
        ["buyVehicleNo"] = "لا، غيرت رأيي",
        ["vehicleReleaseRequest"] = "تكلفة تحرير المركبة $%s دولار، هل تريد المتابعة مع التحرير؟",
        ["days"] = "أيام",
        ["hours"] = "ساعات",
        ["minutes"] = "دقائق",
        ["seconds"] = "ثواني",
        ["privateWorldVehicleCooldown"] = "انتظر %d ثانية قبل إنشاء مركبة أخرى في عالم خاص.",
        ["arrestRequest"] = "حجز المركبة؟",
        ["arrestYes"] = "نعم، إتمام الحجز",
        ["arrestNo"] = "لا، غيرت رأيي",
    }
}

local bulletproofTranslations = {
    ["pt-br"] = {
        ["garages.bulletproof.name"] = "Blindados",
        ["garages.bulletproof.title"] = "Blindados (%d)",
        ["garages.bulletproof.add"] = "Adicionar modelo",
        ["garages.bulletproof.add_description"] = "Proteger todos os ocupantes deste modelo contra tiros.",
        ["garages.bulletproof.spawn"] = "Nome de spawn do veículo",
        ["garages.bulletproof.remove"] = "Remover modelo",
        ["garages.bulletproof.remove_description"] = "Selecionar para remover a proteção deste modelo.",
        ["garages.bulletproof.confirm_remove"] = "Remover a proteção dos ocupantes de %s?",
        ["garages.bulletproof.added"] = "%s adicionado à lista de blindados.",
        ["garages.bulletproof.removed"] = "%s removido da lista de blindados.",
        ["garages.bulletproof.denied"] = "Você não tem permissão para editar a lista de blindados.",
        ["garages.bulletproof.duty"] = "Entre em serviço para editar a lista de blindados.",
        ["garages.bulletproof.unavailable"] = "A lista de blindados está indisponível.",
        ["garages.bulletproof.invalid"] = "Informe um nome de spawn válido, com letras, números ou sublinhado.",
        ["garages.bulletproof.model_not_found"] = "Este veículo não está cadastrado na garagem.",
        ["garages.bulletproof.exists"] = "Este modelo já está na lista.",
        ["garages.bulletproof.not_found"] = "Este modelo não está mais na lista.",
        ["garages.bulletproof.save_failed"] = "Não foi possível salvar a lista de blindados."
    },
    ["en-us"] = {
        ["garages.bulletproof.name"] = "Armored vehicles",
        ["garages.bulletproof.title"] = "Armored vehicles (%d)",
        ["garages.bulletproof.add"] = "Add model",
        ["garages.bulletproof.add_description"] = "Protect every occupant of this model from gunfire.",
        ["garages.bulletproof.spawn"] = "Vehicle spawn name",
        ["garages.bulletproof.remove"] = "Remove model",
        ["garages.bulletproof.remove_description"] = "Select to remove protection from this model.",
        ["garages.bulletproof.confirm_remove"] = "Remove occupant protection from %s?",
        ["garages.bulletproof.added"] = "%s added to the armored vehicle list.",
        ["garages.bulletproof.removed"] = "%s removed from the armored vehicle list.",
        ["garages.bulletproof.denied"] = "You cannot edit the armored vehicle list.",
        ["garages.bulletproof.duty"] = "Go on duty to edit the armored vehicle list.",
        ["garages.bulletproof.unavailable"] = "The armored vehicle list is unavailable.",
        ["garages.bulletproof.invalid"] = "Enter a valid spawn name using letters, numbers or underscores.",
        ["garages.bulletproof.model_not_found"] = "This vehicle is not registered in the garage.",
        ["garages.bulletproof.exists"] = "This model is already listed.",
        ["garages.bulletproof.not_found"] = "This model is no longer listed.",
        ["garages.bulletproof.save_failed"] = "Could not save the armored vehicle list."
    },
    ["es-es"] = {
        ["garages.bulletproof.name"] = "Vehículos blindados",
        ["garages.bulletproof.title"] = "Vehículos blindados (%d)",
        ["garages.bulletproof.add"] = "Añadir modelo",
        ["garages.bulletproof.add_description"] = "Proteger a todos los ocupantes de este modelo frente a disparos.",
        ["garages.bulletproof.spawn"] = "Nombre de spawn del vehículo",
        ["garages.bulletproof.remove"] = "Eliminar modelo",
        ["garages.bulletproof.remove_description"] = "Seleccionar para quitar la protección de este modelo.",
        ["garages.bulletproof.confirm_remove"] = "¿Quitar la protección de los ocupantes de %s?",
        ["garages.bulletproof.added"] = "%s añadido a la lista de vehículos blindados.",
        ["garages.bulletproof.removed"] = "%s eliminado de la lista de vehículos blindados.",
        ["garages.bulletproof.denied"] = "No tienes permiso para editar la lista de vehículos blindados.",
        ["garages.bulletproof.duty"] = "Activa el servicio para editar la lista de vehículos blindados.",
        ["garages.bulletproof.unavailable"] = "La lista de vehículos blindados no está disponible.",
        ["garages.bulletproof.invalid"] = "Introduce un nombre de spawn válido, con letras, números o guiones bajos.",
        ["garages.bulletproof.model_not_found"] = "Este vehículo no está registrado en el garaje.",
        ["garages.bulletproof.exists"] = "Este modelo ya está en la lista.",
        ["garages.bulletproof.not_found"] = "Este modelo ya no está en la lista.",
        ["garages.bulletproof.save_failed"] = "No se pudo guardar la lista de vehículos blindados."
    },
    ["pt-pt"] = {
        ["garages.bulletproof.name"] = "Veículos blindados",
        ["garages.bulletproof.title"] = "Veículos blindados (%d)",
        ["garages.bulletproof.add"] = "Adicionar modelo",
        ["garages.bulletproof.add_description"] = "Proteger todos os ocupantes deste modelo contra disparos.",
        ["garages.bulletproof.spawn"] = "Nome de spawn do veículo",
        ["garages.bulletproof.remove"] = "Remover modelo",
        ["garages.bulletproof.remove_description"] = "Selecionar para remover a proteção deste modelo.",
        ["garages.bulletproof.confirm_remove"] = "Remover a proteção dos ocupantes de %s?",
        ["garages.bulletproof.added"] = "%s adicionado à lista de veículos blindados.",
        ["garages.bulletproof.removed"] = "%s removido da lista de veículos blindados.",
        ["garages.bulletproof.denied"] = "Não tens permissão para editar a lista de veículos blindados.",
        ["garages.bulletproof.duty"] = "Entra em serviço para editar a lista de veículos blindados.",
        ["garages.bulletproof.unavailable"] = "A lista de veículos blindados está indisponível.",
        ["garages.bulletproof.invalid"] = "Indica um nome de spawn válido, com letras, números ou sublinhados.",
        ["garages.bulletproof.model_not_found"] = "Este veículo não está registado na garagem.",
        ["garages.bulletproof.exists"] = "Este modelo já está na lista.",
        ["garages.bulletproof.not_found"] = "Este modelo já não está na lista.",
        ["garages.bulletproof.save_failed"] = "Não foi possível guardar a lista de veículos blindados."
    },
    ["fr-fr"] = {
        ["garages.bulletproof.name"] = "Véhicules blindés",
        ["garages.bulletproof.title"] = "Véhicules blindés (%d)",
        ["garages.bulletproof.add"] = "Ajouter un modèle",
        ["garages.bulletproof.add_description"] = "Protéger tous les occupants de ce modèle contre les tirs.",
        ["garages.bulletproof.spawn"] = "Nom de spawn du véhicule",
        ["garages.bulletproof.remove"] = "Retirer un modèle",
        ["garages.bulletproof.remove_description"] = "Sélectionner pour retirer la protection de ce modèle.",
        ["garages.bulletproof.confirm_remove"] = "Retirer la protection des occupants de %s ?",
        ["garages.bulletproof.added"] = "%s a été ajouté à la liste des véhicules blindés.",
        ["garages.bulletproof.removed"] = "%s a été retiré de la liste des véhicules blindés.",
        ["garages.bulletproof.denied"] = "Vous n'avez pas l'autorisation de modifier la liste des véhicules blindés.",
        ["garages.bulletproof.duty"] = "Prenez votre service pour modifier la liste des véhicules blindés.",
        ["garages.bulletproof.unavailable"] = "La liste des véhicules blindés est indisponible.",
        ["garages.bulletproof.invalid"] = "Saisissez un nom de spawn valide (lettres, chiffres ou traits de soulignement).",
        ["garages.bulletproof.model_not_found"] = "Ce véhicule n'est pas enregistré dans le garage.",
        ["garages.bulletproof.exists"] = "Ce modèle figure déjà dans la liste.",
        ["garages.bulletproof.not_found"] = "Ce modèle ne figure plus dans la liste.",
        ["garages.bulletproof.save_failed"] = "Impossible d'enregistrer la liste des véhicules blindés."
    },
    ["de-de"] = {
        ["garages.bulletproof.name"] = "Gepanzerte Fahrzeuge",
        ["garages.bulletproof.title"] = "Gepanzerte Fahrzeuge (%d)",
        ["garages.bulletproof.add"] = "Modell hinzufügen",
        ["garages.bulletproof.add_description"] = "Alle Insassen dieses Modells vor Schüssen schützen.",
        ["garages.bulletproof.spawn"] = "Spawnname des Fahrzeugs",
        ["garages.bulletproof.remove"] = "Modell entfernen",
        ["garages.bulletproof.remove_description"] = "Auswählen, um den Schutz dieses Modells zu entfernen.",
        ["garages.bulletproof.confirm_remove"] = "Schutz der Insassen von %s entfernen?",
        ["garages.bulletproof.added"] = "%s wurde zur Liste der gepanzerten Fahrzeuge hinzugefügt.",
        ["garages.bulletproof.removed"] = "%s wurde aus der Liste der gepanzerten Fahrzeuge entfernt.",
        ["garages.bulletproof.denied"] = "Du darfst die Liste der gepanzerten Fahrzeuge nicht bearbeiten.",
        ["garages.bulletproof.duty"] = "Begib dich in den Dienst, um die Liste der gepanzerten Fahrzeuge zu bearbeiten.",
        ["garages.bulletproof.unavailable"] = "Die Liste der gepanzerten Fahrzeuge ist nicht verfügbar.",
        ["garages.bulletproof.invalid"] = "Gib einen gültigen Spawnnamen mit Buchstaben, Zahlen oder Unterstrichen ein.",
        ["garages.bulletproof.model_not_found"] = "Dieses Fahrzeug ist nicht in der Garage registriert.",
        ["garages.bulletproof.exists"] = "Dieses Modell steht bereits auf der Liste.",
        ["garages.bulletproof.not_found"] = "Dieses Modell steht nicht mehr auf der Liste.",
        ["garages.bulletproof.save_failed"] = "Die Liste der gepanzerten Fahrzeuge konnte nicht gespeichert werden."
    },
    ["ar-sa"] = {
        ["garages.bulletproof.name"] = "المركبات المدرعة",
        ["garages.bulletproof.title"] = "المركبات المدرعة (%d)",
        ["garages.bulletproof.add"] = "إضافة طراز",
        ["garages.bulletproof.add_description"] = "حماية جميع ركاب هذا الطراز من إطلاق النار.",
        ["garages.bulletproof.spawn"] = "اسم استدعاء المركبة",
        ["garages.bulletproof.remove"] = "إزالة طراز",
        ["garages.bulletproof.remove_description"] = "اختر لإزالة الحماية عن هذا الطراز.",
        ["garages.bulletproof.confirm_remove"] = "هل تريد إزالة الحماية عن ركاب %s؟",
        ["garages.bulletproof.added"] = "تمت إضافة %s إلى قائمة المركبات المدرعة.",
        ["garages.bulletproof.removed"] = "تمت إزالة %s من قائمة المركبات المدرعة.",
        ["garages.bulletproof.denied"] = "ليس لديك صلاحية تعديل قائمة المركبات المدرعة.",
        ["garages.bulletproof.duty"] = "يجب أن تكون في الخدمة لتعديل قائمة المركبات المدرعة.",
        ["garages.bulletproof.unavailable"] = "قائمة المركبات المدرعة غير متاحة.",
        ["garages.bulletproof.invalid"] = "أدخل اسم استدعاء صالحًا يتكوّن من أحرف أو أرقام أو شرطات سفلية.",
        ["garages.bulletproof.model_not_found"] = "هذه المركبة غير مسجلة في المرآب.",
        ["garages.bulletproof.exists"] = "هذا الطراز موجود بالفعل في القائمة.",
        ["garages.bulletproof.not_found"] = "هذا الطراز لم يعد موجودًا في القائمة.",
        ["garages.bulletproof.save_failed"] = "تعذّر حفظ قائمة المركبات المدرعة."
    }
}

for locale, entries in pairs(translations) do
    for key, value in pairs(bulletproofTranslations[locale] or bulletproofTranslations["en-us"]) do
        entries[key] = value
    end
end

---@param key string The translation key to check
---@return boolean Returns true if translation exists, false otherwise
function CheckTranslation(key)
    if translations[lang][key] then
        return true
    else
        print("[DEBUG] Translation not found for key: " .. key.. " - Lang: " .. lang)
        return false
    end
end

---@param key string The translation key to retrieve
---@return string Returns the translated string or error message
function _t(key)
    if CheckTranslation(key) then
        return translations[lang][key]
    else
        return "Translation not found for key: " .. key.. " - Lang: " .. lang
    end
end
