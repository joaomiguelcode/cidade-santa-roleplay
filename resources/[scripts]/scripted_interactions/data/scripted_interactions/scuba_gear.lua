DEFINE_SCRIPTED_INTERACTION 'scuba_gear' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'p_s_scuba_tank_s',
                boneId 	  = 24818,

                offsetPosition = vector3( -0.28, -0.24, 0.0 ),
                offsetRotation = vector3( 0.0, 90.0, 180.0 ),
            },
            {
                modelName = 'p_s_scuba_mask_s',
                boneId 	  = 12844,

                offsetPosition = vector3( 0.0, 0.0, 0.0 ),
                offsetRotation = vector3( 0.0, 90.0, 180.0 ),
            }
        }
    }
}