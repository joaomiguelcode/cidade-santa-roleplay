local defaultLanguage = 'pt-br'
local language = string.lower(GetConvar('language', defaultLanguage) or defaultLanguage)

if language == '' then
	language = defaultLanguage
end

local locales = {
	['pt-br'] = {
		request = {
			request_anim = '~g~%s~s~ Aceitar | ~r~%s~s~ Recusar | %s',
		},
		notify = {
			anim_cooldown = '[~r~ERRO~s~] Animação em cooldown.',
			no_players_nearby = '[~r~ERRO~s~] Ninguém próximo a você.',
			error_ocurred = '[~r~ERRO~s~] Idade não identificada',
			cant_play_anim = '[~r~ERRO~s~] Você não pode solicitar essa animação para essa pessoa.',
			send_anim = '[~g~SUCESSO~s~] Pedido enviado.',
		},
	},
	['en-us'] = {
		request = {
			request_anim = '~g~%s~s~ Accept | ~r~%s~s~ Decline | %s',
		},
		notify = {
			anim_cooldown = '[~r~ERROR~s~] Animation is on cooldown.',
			no_players_nearby = '[~r~ERROR~s~] Nobody is near you.',
			error_ocurred = '[~r~ERROR~s~] Age not identified',
			cant_play_anim = '[~r~ERROR~s~] You cannot request this animation from this person.',
			send_anim = '[~g~SUCCESS~s~] Request sent.',
		},
	},
	['es-es'] = {
		request = {
			request_anim = '~g~%s~s~ Aceptar | ~r~%s~s~ Rechazar | %s',
		},
		notify = {
			anim_cooldown = '[~r~ERROR~s~] Animación en enfriamiento.',
			no_players_nearby = '[~r~ERROR~s~] Nadie cerca de ti.',
			error_ocurred = '[~r~ERROR~s~] Edad no identificada',
			cant_play_anim = '[~r~ERROR~s~] No puedes solicitar esta animación a esta persona.',
			send_anim = '[~g~ÉXITO~s~] Solicitud enviada.',
		},
	},
	['pt-pt'] = {
		request = {
			request_anim = '~g~%s~s~ Aceitar | ~r~%s~s~ Recusar | %s',
		},
		notify = {
			anim_cooldown = '[~r~ERRO~s~] Animação em tempo de espera.',
			no_players_nearby = '[~r~ERRO~s~] Ninguém perto de si.',
			error_ocurred = '[~r~ERRO~s~] Idade não identificada',
			cant_play_anim = '[~r~ERRO~s~] Não pode solicitar esta animação a esta pessoa.',
			send_anim = '[~g~SUCESSO~s~] Pedido enviado.',
		},
	},
	['fr-fr'] = {
		request = {
			request_anim = '~g~%s~s~ Accepter | ~r~%s~s~ Refuser | %s',
		},
		notify = {
			anim_cooldown = '[~r~ERREUR~s~] Animation en temps de recharge.',
			no_players_nearby = '[~r~ERREUR~s~] Personne près de vous.',
			error_ocurred = '[~r~ERREUR~s~] Âge non identifié',
			cant_play_anim = '[~r~ERREUR~s~] Vous ne pouvez pas demander cette animation à cette personne.',
			send_anim = '[~g~SUCCÈS~s~] Demande envoyée.',
		},
	},
	['de-de'] = {
		request = {
			request_anim = '~g~%s~s~ Annehmen | ~r~%s~s~ Ablehnen | %s',
		},
		notify = {
			anim_cooldown = '[~r~FEHLER~s~] Animation hat Abklingzeit.',
			no_players_nearby = '[~r~FEHLER~s~] Niemand in deiner Nähe.',
			error_ocurred = '[~r~FEHLER~s~] Alter nicht erkannt',
			cant_play_anim = '[~r~FEHLER~s~] Du kannst diese Animation nicht von dieser Person anfordern.',
			send_anim = '[~g~ERFOLG~s~] Anfrage gesendet.',
		},
	},
	['ar-sa'] = {
		request = {
			request_anim = '~g~%s~s~ قبول | ~r~%s~s~ رفض | %s',
		},
		notify = {
			anim_cooldown = '[~r~خطأ~s~] الحركة في فترة انتظار.',
			no_players_nearby = '[~r~خطأ~s~] لا يوجد أحد بالقرب منك.',
			error_ocurred = '[~r~خطأ~s~] لم يتم تحديد العمر',
			cant_play_anim = '[~r~خطأ~s~] لا يمكنك طلب هذه الحركة من هذا الشخص.',
			send_anim = '[~g~نجاح~s~] تم إرسال الطلب.',
		},
	},
}

Config.locales = locales[language] or locales[defaultLanguage]
