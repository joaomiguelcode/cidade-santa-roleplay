DEFINE_SCRIPTED_INTERACTION 'talking_on_radio' {
	{
		name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,

		animation =
		{
			dict  = 'anim@male@holding_radio',
			name  = 'holding_radio_clip',
			flags = 49,
		},

        props =
        {
            {
                modelName = 'prop_cs_hand_radio',
                boneId 	  = 28422,

                offsetPosition = vector3(   0.0750,  0.0230, -0.0230 ),
                offsetRotation = vector3( -90.0000, 0.0, -59.9999),
            }
        }
	}
}