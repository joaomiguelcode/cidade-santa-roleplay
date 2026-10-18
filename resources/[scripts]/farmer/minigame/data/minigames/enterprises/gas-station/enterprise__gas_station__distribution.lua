DEFINE_MINIGAME 'enterprise__gas_station__distribution' {
    
    displayName = _t("gas_route_displayname"),

    points = {
        vector3(60.11,-871.02,30.49),
        vector3(588.00,2743.24,42.07),
        vector3(-127.41,6351.85,31.48),
        vector3(263.16,-345.24,45.04),
        vector3(593.90,81.85,93.07),
        vector3(-329.40,268.90,86.30),
        vector3(-2029.98,-449.30,11.54),
        vector3(-1193.68,-1508.34,4.36),
        vector3(203.40,-806.92,31.00),
        vector3(-363.78,-887.13,31.08),
        vector3(76.77,9.55,68.72),
        vector3(359.67,301.48,103.63),
        vector3(1033.24,-759.78,57.82),
        vector3(-798.31,-2021.85,9.06),
        vector3(456.78,-1144.56,29.41),
        vector3(526.11,-146.63,58.22),
        vector3(-1160.36,-751.60,19.07),
        vector3(97.67,-1073.57,29.29),
        vector3(1715.46,4711.54,42.38),
        vector3(1622.80,3562.54,35.24),
        vector3(-73.72,-2006.61,18.02),
    },

    distance = 10.0,

    flags = eMinigameDefFlags.MDF_ONLY_CREATED_BY_SCRIPT | eMinigameDefFlags.MDF__ON_COMPLETE__GOTO_NEXT_MINIGAME_POINT,

    duration = 0,
}