DEFINE_SCRIPTED_INTERACTION 'joystick_control' {
	{
		name = 'idle',
		animation =
		{
			dict  = 'amb@code_human_in_bus_passenger_idles@female@tablet@base',
			name  = 'base',
			flags = 49,
		},
		prop =
		{
			modelName = 'prop_controller_01',
			boneId 	  = 18905,

            
            offsetPosition = vector3( 0.10, 0.10, 0.18 ),
            offsetRotation = vector3( 180.0, -75.0, 20.0 ),
		},
		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
	}
}

