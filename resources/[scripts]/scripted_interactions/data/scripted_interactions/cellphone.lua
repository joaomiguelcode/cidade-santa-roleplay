DEFINE_SCRIPTED_INTERACTION 'cellphone' {
	{
		name = 'idle',

		animation =
		{
			dict  = 'cellphone@',
			name  = 'cellphone_text_in',
			flags = 50,
		},

		prop =
		{
			modelName = 'prop_amb_phone',
			boneId 	  = 28422,
		},

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
	},
	-- {
	-- 	name = 'text_in',

	-- 	animation =
	-- 	{
	-- 		dict  = 'cellphone@',
	-- 		name  = 'cellphone_text_in',
	-- 		flags = 50,
	-- 	},

	-- 	flags = eScriptedInteractionStateFlags.STATE_TRANSITION__KEEP_ALL_PROP,
	-- },
	{
		name = 'text_to_call',

		animation =
		{
			dict  = 'cellphone@',
			name  = 'cellphone_text_to_call',
			flags = 50,
		},

		flags = eScriptedInteractionStateFlags.STATE_TRANSITION__KEEP_ALL_PROP,
	},
	{
		name = 'call_to_text',

		animation =
		{
			dict  = 'cellphone@',
			name  = 'cellphone_call_to_text',
			flags = 50,
		},

		flags = eScriptedInteractionStateFlags.STATE_TRANSITION__KEEP_ALL_PROP,
	},
	{
		name = 'call_out',

		animation =
		{
			dict  = 'cellphone@',
			name  = 'cellphone_call_out',
			flags = 50,
		},

		flags = eScriptedInteractionStateFlags.STATE_TRANSITION__KEEP_ALL_PROP,
	},
	{
		name = 'text_out',

		animation =
		{
			dict  = 'cellphone@',
			name  = 'cellphone_text_out',
			flags = 50,
		},

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
	},

	-- In car!

	{
		name = 'car_idle',

		animation =
		{
			dict  = 'anim@cellphone@in_car@ps',
			name  = 'cellphone_text_in',
			flags = 50,
		},

		prop =
		{
			modelName = 'prop_amb_phone',
			boneId 	  = 28422,
		},

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
	},
	-- {
	-- 	name = 'car_text_in',

	-- 	animation =
	-- 	{
	-- 		dict  = 'anim@cellphone@in_car@ps',
	-- 		name  = 'cellphone_text_in',
	-- 		flags = 50,
	-- 	},

	-- 	flags = eScriptedInteractionStateFlags.STATE_TRANSITION__KEEP_ALL_PROP,
	-- },
	{
		name = 'car_text_to_call',

		animation =
		{
			dict  = 'anim@cellphone@in_car@ps',
			name  = 'cellphone_text_to_call',
			flags = 50,
		},

		flags = eScriptedInteractionStateFlags.STATE_TRANSITION__KEEP_ALL_PROP,
	},
	{
		name = 'car_call_to_text',

		animation =
		{
			dict  = 'anim@cellphone@in_car@ps',
			name  = 'cellphone_call_to_text',
			flags = 50,
		},

		flags = eScriptedInteractionStateFlags.STATE_TRANSITION__KEEP_ALL_PROP,
	},
	{
		name = 'car_call_out',

		animation =
		{
			dict  = 'anim@cellphone@in_car@ps',
			name  = 'cellphone_call_out',
			flags = 50,
		},

		flags = eScriptedInteractionStateFlags.STATE_TRANSITION__KEEP_ALL_PROP,
	},
	{
		name = 'car_text_out',

		animation =
		{
			dict  = 'anim@cellphone@in_car@ps',
			name  = 'cellphone_text_out',
			flags = 50,
		},

		flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP,
	}
}