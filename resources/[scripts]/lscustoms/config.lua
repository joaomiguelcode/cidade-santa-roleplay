language = GetConvar("language", "pt-br") or "pt-br"

vehicleCustomisationPrices = {
    cosmetics = 9000,
    respray = 9000,
    engines = { 3000, 6000, 9000, 15000, 15000, 15000 },
    brakes = { 3000, 6000, 15000, 15000, 15000, 15000 },
    transmission = { 3000, 6000, 15000, 15000, 15000, 15000 },
    suspension = { 3000, 6000, 9000, 15000, 15000, 15000 },
    shield = { 35000, 40000, 40000, 45000, 50000, 55000 },
    turbo = 21000,
    wheels = 9000,
    customwheels = 9000,
    wheelsmoke = 9000,
    windowtint = 9000,
    neonside = 9000,
    neoncolours = 9000,
    headlights = 9000,
    xenoncolours = 9000,
    policelivery = 9000,
    plateindex = 9000
}



vehicleCustomisation = {
    {
        category = _t("spoiler"),
        id = 0
    },{
        category = _t("front_bumper"),
        id = 1
    },{
        category = _t("rear_bumper"),
        id = 2
    },{
        category = _t("side_skirt"),
        id = 3
    },{
        category = _t("exhaust"),
        id = 4
    },{
        category = _t("roll_cage"),
        id = 5
    },{
        category = _t("grille"),
        id = 6
    },{
        category = _t("hood"),
        id = 7
    },{
        category = _t("left_fender"),
        id = 8
    },{
        category = _t("right_fender"),
        id = 9
    },{
        category = _t("roof"),
        id = 10
    },{
        category = _t("custom_plates"),
        id = 25
    },{
        category = _t("trim_a"),
        id = 27
    },{
        category = _t("ornaments"),
        id = 28
    },{
        category = _t("dashboard"),
        id = 29
    },{
        category = _t("dial"),
        id = 30
    },{
        category = _t("door_speaker"),
        id = 31
    },{
        category = _t("seats"),
        id = 32
    },{
        category = _t("steering_wheel"),
        id = 33
    },{
        category = _t("gear_lever"),
        id = 34
    },{
        category = _t("plate_holder"),
        id = 35
    },{
        category = _t("speakers"),
        id = 36
    },{
        category = _t("trunk"),
        id = 37
    },{
        category = _t("hydraulic_suspension"),
        id = 38
    },{
        category = _t("engine_block"),
        id = 39
    },{
        category = _t("air_filter"),
        id = 40
    },{
        category = _t("strut"),
        id = 41
    },{
        category = _t("arch_cover"),
        id = 42
    },{
        category = _t("antenna"),
        id = 43
    },{
        category = _t("trim_b"),
        id = 44
    },{
        category = _t("fuel_tank"),
        id = 45
    },{
        category = _t("windows"),
        id = 46
    },{
        category = _t("livery"),
        id = 48
    },{
        id = 14,
        category = _t("horns_name"),
        hornNames = {
            { name = _t("horns")["truck_horn"], id = 0 },
            { name = _t("horns")["police_horn"], id = 1 },
            { name = _t("horns")["clown_horn"], id = 2 },
            { name = _t("horns")["musical_horn_1"], id = 3 },
            { name = _t("horns")["musical_horn_2"], id = 4 },
            { name = _t("horns")["musical_horn_3"], id = 5 },
            { name = _t("horns")["musical_horn_4"], id = 6 },
            { name = _t("horns")["musical_horn_5"], id = 7 },
            { name = _t("horns")["sad_trombone"], id = 8 },
            { name = _t("horns")["classic_horn_1"], id = 9 },
            { name = _t("horns")["classic_horn_2"], id = 10 },
            { name = _t("horns")["classic_horn_3"], id = 11 },
            { name = _t("horns")["classic_horn_4"], id = 12 },
            { name = _t("horns")["classic_horn_5"], id = 13 },
            { name = _t("horns")["classic_horn_6"], id = 14 },
            { name = _t("horns")["classic_horn_7"], id = 15 },
            { name = _t("horns")["scale_do"], id = 16 },
            { name = _t("horns")["scale_re"], id = 17 },
            { name = _t("horns")["scale_mi"], id = 18 },
            { name = _t("horns")["scale_fa"], id = 19 },
            { name = _t("horns")["scale_sol"], id = 20 },
            { name = _t("horns")["scale_la"], id = 21 },
            { name = _t("horns")["scale_si"], id = 22 },
            { name = _t("horns")["jazz_horn_1"], id = 24 },
            { name = _t("horns")["jazz_horn_2"], id = 25 },
            { name = _t("horns")["jazz_horn_3"], id = 26 },
            { name = _t("horns")["jazz_horn_loop"], id = 27 },
            { name = _t("horns")["national_anthem_1"], id = 28 },
            { name = _t("horns")["national_anthem_2"], id = 29 },
            { name = _t("horns")["national_anthem_3"], id = 30 },
            { name = _t("horns")["national_anthem_4"], id = 31 },
            { name = _t("horns")["classic_horn_8_loop"], id = 32 },
            { name = _t("horns")["classic_horn_9_loop"], id = 33 },
            { name = _t("horns")["classic_horn_10_loop"], id = 34 },
            { name = _t("horns")["funeral_march_loop"], id = 38 },
            { name = _t("horns")["funeral_march"], id = 39 },
            { name = _t("horns")["scary_horn_loop"], id = 40 },
            { name = _t("horns")["scary_horn"], id = 41 },
            { name = _t("horns")["san_andreas_loop"], id = 42 },
            { name = _t("horns")["san_andreas"], id = 43 },
            { name = _t("horns")["liberty_city_loop"], id = 44 },
            { name = _t("horns")["liberty_city"], id = 45 },
            { name = _t("horns")["festive_1_loop"], id = 46 },
            { name = _t("horns")["festive_1"], id = 47 },
            { name = _t("horns")["festive_2_loop"], id = 48 },
            { name = _t("horns")["festive_2"], id = 49 },
            { name = _t("horns")["festive_3_loop"], id = 50 },
            { name = _t("horns")["festive_3"], id = 51 }
        }
    },{
        category = _t("engine_upgrade"),
        type = "engines",
        id = 11
    },{
        category = _t("brake_upgrade"),
        type = "brakes",
        id = 12
    },{
        category = _t("transmission_upgrade"),
        type = "transmission",
        id = 13
    },{
        category = _t("suspension_upgrade"),
        type = "suspension",
        id = 15
    },{
        category = _t("armor_upgrade"),
        type = "shield",
        id = 16
    },{
        category = _t("turbo_upgrade"),
        id = 18
    }
}

for k, v in ipairs(vehicleCustomisation) do
    if v and v["category"] then
        
    else
        print("Invalid entry in vehicleCustomisation: ", json.encode(v["id"])) -- Debugging output
    end
end

vehicleWindowTintOptions = {
    {
        name = _t("no_tint"),
        id = 0
    },{
        name = _t("pure_black"),
        id = 1
    },{
        name = _t("dark_smoke"),
        id = 2
    },{
        name = _t("light_smoke"),
        id = 3
    }
}

vehicleWheelOptions = {
	{
		category = _t("custom_tyres"),
		id = -1,
		wheelID = 23
	},
    -- {
	-- 	category = "Fumaça dos Pneus",
	-- 	id = 20,
	-- 	wheelID = 23
	-- },
    {
		category = _t("sport_wheels"),
		id = 0,
		wheelID = 23
	},{
		category = _t("muscle_wheels"),
		id = 1,
		wheelID = 23
	},{
		category = _t("lowrider_wheels"),
		id = 2,
		wheelID = 23
	},{
		category = _t("suv_wheels"),
		id = 3,
		wheelID = 23
	},{
		category = _t("offroad_wheels"),
		id = 4,
		wheelID = 23
	},{
		category = _t("tuner_wheels"),
		id = 5,
		wheelID = 23
	},{
		category = _t("super_wheels"),
		id = 6,
		wheelID = 23
	},{
		category = _t("high_end_wheels"),
		id = 7,
		wheelID = 23
	},{
		category = _t("stock_wheels"),
		id = 8,
		wheelID = 23
	},{
		category = _t("custom_wheels"),
		id = 9,
		wheelID = 23
	},{
		category = _t("street_wheels"),
		id = 11,
		wheelID = 23
	},{
		category = _t("trail_wheels"),
		id = 12,
		wheelID = 23
	}
}

vehicleTyreSmokeOptions = {
    { name = _t("white_smoke"), r = 254, g = 254, b = 254 },
    { name = _t("black_smoke"), r = 1, g = 1, b = 1 },
    { name = _t("blue_smoke"), r = 0, g = 150, b = 255 },
    { name = _t("yellow_smoke"), r = 255, g = 255, b = 50 },
    { name = _t("orange_smoke"), r = 255, g = 153, b = 51 },
    { name = _t("red_smoke"), r = 255, g = 10, b = 10 },
    { name = _t("green_smoke"), r = 10, g = 255, b = 10 },
    { name = _t("purple_smoke"), r = 153, g = 10, b = 153 },
    { name = _t("pink_smoke"), r = 255, g = 102, b = 178 },
    { name = _t("gray_smoke"), r = 128, g = 128, b = 128 }
}

vehicleResprayCategories = {
    {
        category = _t("primary_color"),
        id = 0
    },{
        category = _t("secondary_color"),
        id = 1
    },{
        category = _t("pearl_color"),
        id = 2
    },{
        category = _t("wheel_color"),
        id = 3
    },{
        category = _t("dashboard_color"),
        id = 4
    },{
        category = _t("interior_color"),
        id = 5
    }
}

vehicleResprayMenus = {
    ["respray_types"] = {
        heading = _t("respray_types"),
        subheading = _t("choose_respray_type")
    },
    ["respray"] = {
        heading = _t("respray"),
        subheading = _t("choose_respray_category")
    }
}

vehicleResprayOptions = {
    {
        id = 1,
        category = _t("metallic"),
        colours = {
            { name = _t("black"), id = 0 },
            { name = _t("carbon_black"), id = 147 },
            { name = _t("graphite"), id = 1 },
            { name = _t("anthracite_black"), id = 11 },
            { name = _t("black_steel"), id = 11 },
            { name = _t("dark_steel"), id = 3 },
            { name = _t("silver"), id = 4 },
            { name = _t("bluish_silver"), id = 5 },
            { name = _t("rolled_steel"), id = 6 },
            { name = _t("shadow_silver"), id = 7 },
            { name = _t("stone_silver"), id = 8 },
            { name = _t("midnight_silver"), id = 9 },
            { name = _t("cast_iron_silver"), id = 10 },
            { name = _t("red"), id = 27 },
            { name = _t("torino_red"), id = 28 },
            { name = _t("formula_red"), id = 29 },
            { name = _t("lava_red"), id = 150 },
            { name = _t("blaze_red"), id = 30 },
            { name = _t("grace_red"), id = 31 },
            { name = _t("garnet_red"), id = 32 },
            { name = _t("sunset_red"), id = 33 },
            { name = _t("cabernet_red"), id = 34 },
            { name = _t("wine_red"), id = 143 },
            { name = _t("candy_red"), id = 35 },
            { name = _t("hot_pink"), id = 135 },
            { name = _t("pfister_pink"), id = 137 },
            { name = _t("salmon_pink"), id = 136 },
            { name = _t("sunrise_orange"), id = 36 },
            { name = _t("orange"), id = 38 },
            { name = _t("bright_orange"), id = 138 },
            { name = _t("gold"), id = 99 },
            { name = _t("bronze"), id = 90 },
            { name = _t("yellow"), id = 88 },
            { name = _t("race_yellow"), id = 89 },
            { name = _t("dew_yellow"), id = 91 },
            { name = _t("dark_green"), id = 49 },
            { name = _t("racing_green"), id = 50 },
            { name = _t("sea_green"), id = 51 },
            { name = _t("bright_green"), id = 53 },
            { name = _t("gasoline_green"), id = 54 },
            { name = _t("lime_green"), id = 92 },
            { name = _t("midnight_blue"), id = 141 },
            { name = _t("galaxy_blue"), id = 61 },
            { name = _t("dark_blue"), id = 62 },
            { name = _t("saxon_blue"), id = 63 },
            { name = _t("blue"), id = 64 },
            { name = _t("mariner_blue"), id = 65 },
            { name = _t("harbor_blue"), id = 66 },
            { name = _t("diamond_blue"), id = 67 },
            { name = _t("surf_blue"), id = 68 },
            { name = _t("nautical_blue"), id = 69 },
            { name = _t("racing_blue"), id = 73 },
            { name = _t("ultra_blue"), id = 70 },
            { name = _t("light_blue"), id = 74 },
            { name = _t("chocolate_brown"), id = 96 },
            { name = _t("bison_brown"), id = 101 },
            { name = _t("creeen_brown"), id = 95 },
            { name = _t("feltzer_brown"), id = 94 },
            { name = _t("maple_brown"), id = 97 },
            { name = _t("beechwood_brown"), id = 103 },
            { name = _t("sienna_brown"), id = 104 },
            { name = _t("saddle_brown"), id = 98 },
            { name = _t("moss_brown"), id = 100 },
            { name = _t("wood_beech"), id = 102 },
            { name = _t("straw_brown"), id = 99 },
            { name = _t("sand_brown"), id = 105 },
            { name = _t("bleached_brown"), id = 106 },
            { name = _t("schafter_purple"), id = 71 },
            { name = _t("spinnaker_purple"), id = 72 },
            { name = _t("midnight_purple"), id = 142 },
            { name = _t("bright_purple"), id = 145 },
            { name = _t("cream"), id = 107 },
            { name = _t("ice_white"), id = 111 },
            { name = _t("frost_white"), id = 112 }
        }
    },{
        id = 2,
        category = _t("matte"),
        colours = {
            { name = _t("black"), id = 12 },
            { name = _t("gray"), id = 13 },
            { name = _t("light_gray"), id = 14 },
            { name = _t("ice_white"), id = 131 },
            { name = _t("blue"), id = 83 },
            { name = _t("dark_blue"), id = 82 },
            { name = _t("midnight_blue"), id = 84 },
            { name = _t("midnight_purple"), id = 149 },
            { name = _t("schafter_purple"), id = 148 },
            { name = _t("red"), id = 39 },
            { name = _t("dark_red"), id = 40 },
            { name = _t("orange"), id = 41 },
            { name = _t("yellow"), id = 42 },
            { name = _t("lime_green"), id = 55 },
            { name = _t("green"), id = 128 },
            { name = _t("forest_green"), id = 151 },
            { name = _t("foliage_green"), id = 155 },
            { name = _t("olive_green"), id = 152 },
            { name = _t("desert_sand"), id = 153 },
            { name = _t("desert_tan"), id = 154 }
        }
    },{
        id = 3,
        category = _t("metals"),
        colours = {
            { name = _t("brushed_steel"), id = 117 },
            { name = _t("brushed_black_steel"), id = 118 },
            { name = _t("brushed_aluminum"), id = 119 },
            { name = _t("pure_gold"), id = 158 },
            { name = _t("brushed_gold"), id = 159 },
            { name = _t("chrome"), id = 120 }
        }
    }
}


vehicleNeonOptions = {
    category = _t("neon_lights"),
    neonTypes = {
        { name = _t("front_neon"), id = 2 },
        { name = _t("rear_neon"), id = 3 },
        { name = _t("left_neon"), id = 0 },
        { name = _t("right_neon"), id = 1 }
    },
    neonColours = {
        { name = _t("white"), r = 222, g = 222, b = 255 },
        { name = _t("blue"), r = 2, g = 21, b = 255 },
        { name = _t("electric_blue"), r = 3, g = 83, b = 255 },
        { name = _t("mint_green"), r = 0, g = 255, b = 140 },
        { name = _t("lime_green"), r = 94, g = 255, b = 1 },
        { name = _t("yellow"), r = 255, g = 255, b = 0 },
        { name = _t("gold"), r = 255, g = 150, b = 0 },
        { name = _t("orange"), r = 255, g = 62, b = 0 },
        { name = _t("red"), r = 255, g = 1, b = 1 },
        { name = _t("pony_pink"), r = 255, g = 50, b = 100 },
        { name = _t("hot_pink"), r = 255, g = 5, b = 190 },
        { name = _t("purple"), r = 35, g = 1, b = 255 },
        { name = _t("blacklight"), r = 15, g = 3, b = 255 }
    }
}

vehicleXenonOptions = {
    xenonColours = {
        { name = _t("xenon_standard"), id = 255 },
        { name = _t("xenon_white"), id = 0 },
        { name = _t("xenon_blue"), id = 1 },
        { name = _t("xenon_electric_blue"), id = 2 },
        { name = _t("xenon_mint_green"), id = 3 },
        { name = _t("xenon_lime_green"), id = 4 },
        { name = _t("xenon_yellow"), id = 5 },
        { name = _t("xenon_gold"), id = 6 },
        { name = _t("xenon_orange"), id = 7 },
        { name = _t("xenon_red"), id = 8 },
        { name = _t("xenon_pony_pink"), id = 9 },
        { name = _t("xenon_hot_pink"), id = 10 },
        { name = _t("xenon_purple"), id = 11 },
        { name = _t("xenon_blacklight"), id = 12 }
    }
}