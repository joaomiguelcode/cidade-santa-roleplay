DEFINE_SCRIPTED_INTERACTION 'tablet' {
	{
		name = 'idle',

		animation =
		{
			dict  = 'amb@code_human_in_bus_passenger_idles@female@tablet@base',
			name  = 'base',
			flags = 50,
		},

		prop =
		{
			modelName = 'prop_cs_tablet',
			boneId 	  = 28422,
		},

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
	},

}