Config.defaultAge = nil -- "adult", "adolescent", "baby", nil - Utilize se você quiser setar uma "idade" padrão para os peds que não estão na lista abaixo.

Config.pedModels = { -- Esse script possui filtragem por hash, aqui você pode determinar as hashs
	adult = { -- Hash dos peds adultos, normalmente são apenas essas duas opções
		"mp_m_freemode_01",
		"mp_f_freemode_01",
		"zombie_argonix",
		"Tonystark",
		"Mark43",
		"Special1",
		"Special2",
		"Special3",
		"chucky",
		"Samurai",
		"AlienLCFR",
	},
	adolescent = { -- Peds adolecentes
		"dante",
	},
	baby = { -- Peds bebês
		"baby",
		"baby2",
	},
}