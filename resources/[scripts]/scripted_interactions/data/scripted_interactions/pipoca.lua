DEFINE_SCRIPTED_INTERACTION 'pipoca' {
	{
		name = 'idle',

		animation = {
			dict  = 'amb@code_human_wander_drinking@beer@male@base',
			name  = 'static',
			flags = 49,
		},

		prop = {
			modelName = 'comida_pipoca_sg',
			boneId    = 28422,
		},

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
	},
}
