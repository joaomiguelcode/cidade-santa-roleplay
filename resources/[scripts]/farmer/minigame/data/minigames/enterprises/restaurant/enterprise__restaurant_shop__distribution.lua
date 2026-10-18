DEFINE_MINIGAME 'enterprise__restaurant_shop__distribution' {

    displayName = _t("restaurant_route_displayname"),

    points = {
        vector3(29.48,-1343.06,29.50),
        vector3(2552.76,385.89,108.62),
        vector3(1157.59,-324.01,69.21),
        vector3(-713.23,-913.43,19.22),
        vector3(-52.19,-1753.28,29.42),
        vector3(378.29,329.77,103.57),
        vector3(-3246.50,1004.96,12.83),
        vector3(1734.20,6417.31,35.04),
        vector3(545.25,2666.16,42.16),
        vector3(1961.59,3746.24,32.34),
        vector3(2676.26,3285.76,55.24),
        vector3(1702.19,4928.98,42.06),
        vector3(-1825.47,788.73,138.23),
        vector3(1390.65,3601.06,34.98),
        vector3(-2970.53,393.59,15.04),
        vector3(-3044.90,587.62,7.91),
        vector3(1138.81,-984.40,46.42),
        vector3(1163.40,2706.53,38.16),
        vector3(-1491.21,-379.43,40.16),
        vector3(-1222.44,-903.23,12.33)
    },

    distance = 10.0,

    flags = eMinigameDefFlags.MDF_ONLY_CREATED_BY_SCRIPT | eMinigameDefFlags.MDF__ON_COMPLETE__GOTO_NEXT_MINIGAME_POINT,

    duration = 0,
}