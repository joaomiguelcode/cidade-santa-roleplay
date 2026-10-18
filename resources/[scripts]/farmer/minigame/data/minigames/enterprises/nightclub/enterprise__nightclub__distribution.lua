DEFINE_MINIGAME 'enterprise__nightclub__distribution' {

    displayName = _t("nightclub_route_displayname"),

    points = {
        vector3(24.92,-1349.98,29.33),
        vector3(2561.02,387.93,108.62),
        vector3(1152.71,-328.41,69.21),
        vector3(-708.45,-917.17,19.21),
        vector3(-49.63,-1760.07,29.44),
        vector3(373.65,323.26,103.49),
        vector3(-3238.54,1007.95,12.38),
        vector3(1736.11,6408.38,35.00),
        vector3(541.35,2673.96,42.17),
        vector3(1969.91,3745.01,32.38),
        vector3(2685.17,3287.24,55.41),
        vector3(1696.12,4925.91,42.23),
        vector3(-1824.92,785.14,138.24),
        vector3(1392.09,3598.41,35.03),
        vector3(-2973.94,393.06,15.04),
        vector3(-3037.31,586.88,7.81),
        vector3(1141.76,-978.55,46.32),
        vector3(1163.24,2702.42,38.18),
        vector3(-1487.45,-388.70,39.33),
        vector3(-1230.05,-904.23,12.15)
    },

    distance = 10.0,

    flags = eMinigameDefFlags.MDF_ONLY_CREATED_BY_SCRIPT | eMinigameDefFlags.MDF__ON_COMPLETE__GOTO_NEXT_MINIGAME_POINT,

    duration = 0,
}