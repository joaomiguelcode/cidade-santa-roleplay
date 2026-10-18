
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
if cityName ~= "Fronteira" then
    local int_arcade1 = GetInteriorAtCoordsWithType(743.26500000,-816.71220000,21.66042000,"int_arcade")
    local int_plan1 = GetInteriorAtCoordsWithType(710.87930000,-813.11000000,15.19892000,"int_plan")
    CreateThread(function()
        -- OnEnterMp()
        -- SetInstancePriorityMode(true)
    
        -- IPL Requests
        RequestIpl("chop_props") -- -13.83, -1455.45, 31.81
        RequestIpl("v_rockclub")
        RequestIpl("rc12b_default") -- 330.4596, -584.8196, 42.3174
        -- RequestIpl("v_carshowroom") -- -30.8793, -1088.336, 25.4221
        RequestIpl("shr_int") -- -59.7936, -1098.784, 27.2612
        RequestIpl("shr_int_lod")
        RequestIpl("shutter_closed")
        RequestIpl("FINBANK") -- 2.69689322, -667.0166, 16.1306286
        RequestIpl("facelobby") -- -1047.9, -233.0, 39.0
        RequestIpl("CS1_02_cf_onmission1") -- -146.3837, 6161.5, 30.2062
        RequestIpl("CS1_02_cf_onmission2") -- -146.3837, 6161.5, 30.2062
        RequestIpl("CS1_02_cf_onmission3") -- -146.3837, 6161.5, 30.2062
        RequestIpl("CS1_02_cf_onmission4") -- -146.3837, 6161.5, 30.2062
        RequestIpl("des_farmhouse") -- 2447.9, 4973.4, 47.7
        RequestIpl("des_farmhs_endimap") -- 2450.595, 4959.929
        RequestIpl("des_farmhs_end_occl") -- 2450.595, 4959.929
        RequestIpl("des_farmhs_startimap") -- 2450.595, 4959.929
        RequestIpl("des_farmhs_start_occl") -- 2450.595, 4959.929
        RequestIpl("farm") -- 2447.9, 4973.4, 47.7
        RequestIpl("farm_props") -- 2447.9, 4973.4, 47.7
        RequestIpl("farm_int") -- 2447.9, 4973.4, 47.7
        RequestIpl("farmint") -- 2447.9, 4973.4, 47.7
        -- RequestIpl("FIBlobby") -- 105.4557, -745.4835, 44.7548
        -- RequestIpl("FBI_colPLUG") -- 74.29, -736.05, 46.76
        -- RequestIpl("FBI_repair") -- 74.29, -736.05, 46.76
        RequestIpl("TrevorsTrailerTidy") -- 1973, 3815, 34
        RequestIpl("dt1_03_gr_closed") -- 23.7318, -647.2123, 37.9549
        RequestIpl("dt1_21_prop_lift") -- -180.5771, -1016.928, 28.2893
        RequestIpl("dt1_21_prop_lift_on") -- -180.5771, -1016.928, 28.2893
        -- RequestIpl("yogagame") -- -781.6566, 186.8937, 71.8352
        RequestIpl("v_tunnel_hole") -- -14.651, -604.3639, 25.1823
        RequestIpl("V_Michael") -- -811.2679, 179.3344, 75.7408
        RequestIpl("V_Michael_Garage") -- -810.5301, 187.7868, 71.4786
        RequestIpl("V_Michael_FameShame") -- -810.5301, 187.7868, 71.4786
        RequestIpl("V_Michael_JewelHeist") -- -813.3, 177.5, 75.76
        RequestIpl("V_Michael_plane_ticket") -- -813.3, 177.5, 75.76
        RequestIpl("V_Michael_Scuba") -- -810.5301, 187.7868, 71.4786
        RequestIpl("hei_yacht_heist") -- -2043.974, -1031.582, 11.981
        RequestIpl("hei_yacht_heist_Bar")
        RequestIpl("hei_yacht_heist_Bedrm")
        RequestIpl("hei_yacht_heist_Bridge")
        RequestIpl("hei_yacht_heist_DistantLights")
        RequestIpl("hei_yacht_heist_enginrm")
        RequestIpl("hei_yacht_heist_LODLights")
        RequestIpl("hei_yacht_heist_Lounge")
        RequestIpl("cargoship") -- -162.8918, -2365.769, 0
        RequestIpl("sc1_01_newbill") -- -351, -1324, 44.02
        RequestIpl("hw1_02_newbill")
        RequestIpl("hw1_emissive_newbill")
        RequestIpl("sc1_14_newbill")
        RequestIpl("dt1_17_newbill") -- 391.81, -962.71, 41.97
        RequestIpl("SC1_01_OldBill") -- -351, -1324, 44.02
        RequestIpl("SC1_30_Keep_Closed")
        RequestIpl("refit_unload") -- -583.1606, -282.3967, 35.394
        RequestIpl("post_hiest_unload") -- -630.4205, -236.7843, 37.057
        RequestIpl("occl_meth_grp1") -- 29.4838, 3735.593, 38.688
        RequestIpl("Michael_premier") -- -813.3, 177.5, 75.76
        RequestIpl("DT1_05_HC_REQ") -- 169, -670.3, 41.9
        RequestIpl("DT1_05_REQUEST") -- 163.4, -745.7, 251
        RequestIpl("scafendimap")
        RequestIpl("ferris_finale_anim") -- -1675.178, -1143.605, 12.0175
        RequestIpl("ferris_finale_anim_lod")
        RequestIpl("CS2_06_TriAf02") -- 2384.969, 4277.583, 30.379
        RequestIpl("CS4_08_TriAf02")
        RequestIpl("CS4_04_TriAf03") -- 1577.881, 3836.107, 30.7717
        RequestIpl("AP1_04_TriAf01") -- -1277.629, -2030.913, 1.2823
    
        RequestIpl("grdlc_int_01_shell")
        RequestIpl("gr_grdlc_int_01")
        RequestIpl("gr_grdlc_int_02")
        RequestIpl("gr_entrance_placement")
        RequestIpl("gr_grdlc_interior_placement")
        RequestIpl("gr_grdlc_interior_placement_interior_0_grdlc_int_01_milo")
        RequestIpl("grgrdlc_interior_placement_interior_1_grdlc_int_02_milo")
        RequestIpl("gr_case0_bunkerclosed") -- 848.6175, 2996.567, 45.81612
        RequestIpl("gr_case1_bunkerclosed") -- 2126.785, 3335.04, 48.21422
        RequestIpl("gr_case2_bunkerclosed") -- 2493.654, 3140.399, 51.28789
        RequestIpl("gr_case3_bunkerclosed") -- 481.0465, 2995.135, 43.96672
        RequestIpl("gr_case4_bunkerclosed") -- -391.3216, 4363.728, 58.65862
        RequestIpl("gr_case5_bunkerclosed") -- 1823.961, 4708.14, 42.4991
        RequestIpl("gr_case6_bunkerclosed") -- 1570.372, 2254.549, 78.89397
        RequestIpl("gr_case7_bunkerclosed") -- -783.0755, 5934.686, 24.31475
        RequestIpl("gr_case9_bunkerclosed") -- 24.43542, 2959.705, 58.35517
        RequestIpl("gr_case10_bunkerclosed") -- -3058.714, 3329.19, 12.5844
        RequestIpl("gr_case11_bunkerclosed") -- -3180.466, 1374.192, 19.9597
    
        RequestIpl("cs5_4_trains") -- 2773.61, 2835.327, 35.1903
        RequestIpl("chophillskennel") -- 19.0568, 536.4818, 169.6277
        RequestIpl("bnkheist_apt_dest")
        RequestIpl("bnkheist_apt_norm")
        RequestIpl("redcarpet") -- 300.5927, 300.5927, 104.3776
        RequestIpl("cs3_05_water_grp1") -- -24.685, 3032.92, 40.331
        RequestIpl("cs3_05_water_grp1_lod")
        RequestIpl("cs3_05_water_grp2") -- -24.685, 3032.92, 40.331
        RequestIpl("cs3_05_water_grp2_lod")
        RequestIpl("canyonriver01") -- -532.1309, 4526.187, 88.7955
        RequestIpl("canyonriver01_lod")
        RequestIpl("railing_start") -- -532.1309, 4526.187, 88.7955
        RequestIpl("bh1_47_joshhse_unburnt")
        RequestIpl("bh1_47_joshhse_unburnt_lod")
        RequestIpl("bkr_bi_hw1_13_int") -- 982.0083, -100.8747, 74.84512
        RequestIpl("CanyonRvrShallow")
        RequestIpl("methtrailer_grp1")
        RequestIpl("lr_cs6_08_grave_closed")
        RequestIpl("bkr_bi_id1_23_door")
        RequestIpl("ch1_02_open")
        RequestIpl("sp1_10_real_interior") -- -248.6731, -2010.603, 30.14562
        RequestIpl("sp1_10_real_interior_lod")
        RequestIpl("Carwash_with_spinners")
        RequestIpl("ex_sm_13_office_02a")
        -- RequestIpl("bkr_biker_interior_placement_interior_0_biker_dlc_int_01_milo") -- 1107.04, -3157.399, -37.51859
        -- RequestIpl("bkr_biker_interior_placement_interior_1_biker_dlc_int_02_milo") -- 998.4809, -3164.711, -38.90733
        -- RequestIpl("bkr_biker_interior_placement_interior_6_biker_dlc_int_ware05_milo") -- 1165, -3196.6, -39.01306
        RequestIpl("ch3_rd2_bishopschickengraffiti") -- 1861.28, 2402.11, 58.53
        RequestIpl("cs5_04_mazebillboardgraffiti") -- 2697.32, 3162.18, 58.1
        RequestIpl("cs5_roads_ronoilgraffiti") -- 2119.12, 3058.21, 53.25
        RequestIpl("ba_barriers_case0")
        RequestIpl("ba_case0_forsale")
        RequestIpl("ba_case0_dixon")
        RequestIpl("ba_case0_madonna")
        RequestIpl("ba_case0_solomun")
        RequestIpl("ba_case0_taleofus")
        RequestIpl("ba_barriers_case1")
        RequestIpl("ba_case1_forsale")
        RequestIpl("ba_case1_dixon")
        RequestIpl("ba_case1_madonna")
        RequestIpl("ba_case1_solomun")
        RequestIpl("ba_case1_taleofus")
        RequestIpl("ba_barriers_case2")
        RequestIpl("ba_case2_forsale")
        RequestIpl("ba_case2_dixon")
        RequestIpl("ba_case2_madonna")
        RequestIpl("ba_case2_solomun")
        RequestIpl("ba_case2_taleofus")
        RequestIpl("ba_barriers_case3")
        RequestIpl("ba_case3_forsale")
        RequestIpl("ba_case3_dixon")
        RequestIpl("ba_case3_madonna")
        RequestIpl("ba_case3_solomun")
        RequestIpl("ba_case3_taleofus")
        RequestIpl("ba_barriers_case4")
        RequestIpl("ba_case4_forsale")
        RequestIpl("ba_case4_dixon")
        RequestIpl("ba_case4_madonna")
        RequestIpl("ba_case4_solomun")
        RequestIpl("ba_case4_taleofus")
        RequestIpl("ba_barriers_case5")
        RequestIpl("ba_case5_forsale")
        RequestIpl("ba_case5_dixon")
        RequestIpl("ba_case5_madonna")
        RequestIpl("ba_case5_solomun")
        RequestIpl("ba_case5_taleofus")
        RequestIpl("ba_barriers_case6")
        RequestIpl("ba_case6_forsale")
        RequestIpl("ba_case6_dixon")
        RequestIpl("ba_case6_madonna")
        RequestIpl("ba_case6_solomun")
        RequestIpl("ba_case6_taleofus")
        RequestIpl("ba_barriers_case7")
        RequestIpl("ba_case7_forsale")
        RequestIpl("ba_case7_dixon")
        RequestIpl("ba_case7_madonna")
        RequestIpl("ba_case7_solomun")
        RequestIpl("ba_case7_taleofus")
        RequestIpl("ba_barriers_case8")
        RequestIpl("ba_case8_forsale")
        RequestIpl("ba_case8_dixon")
        RequestIpl("ba_case8_madonna")
        RequestIpl("ba_case8_solomun")
        RequestIpl("ba_case8_taleofus")
        RequestIpl("ba_barriers_case9")
        RequestIpl("ba_case9_forsale")
        RequestIpl("ba_case9_dixon")
        RequestIpl("ba_case9_madonna")
        RequestIpl("ba_case9_solomun")
        RequestIpl("ba_case9_taleofus")
        RequestIpl("gr_grdlc_yacht_lod")
        RequestIpl("gr_grdlc_yacht_placement")
        RequestIpl("gr_heist_yacht2")
        RequestIpl("gr_heist_yacht2_bar")
        RequestIpl("gr_heist_yacht2_bar_lod")
        RequestIpl("gr_heist_yacht2_bedrm")
        RequestIpl("gr_heist_yacht2_bedrm_lod")
        RequestIpl("gr_heist_yacht2_bridge")
        RequestIpl("gr_heist_yacht2_bridge_lod")
        RequestIpl("gr_heist_yacht2_enginrm")
        RequestIpl("gr_heist_yacht2_enginrm_lod")
        RequestIpl("gr_heist_yacht2_lod")
        RequestIpl("gr_heist_yacht2_lounge")
        RequestIpl("gr_heist_yacht2_lounge_lod")
        RequestIpl("gr_heist_yacht2_slod")
        RequestIpl("ex_dt1_02_office_02b")
        RequestIpl("ex_dt1_11_office_02c")
        RequestIpl("ex_sm_15_office_01a")
        -- RequestIpl("vw_casino_main") -- 1100.000, 220.000, -50.000
        -- RequestIpl("vw_dlc_casino_door")
        -- RequestIpl("hei_dlc_casino_door")
        -- RequestIpl("hei_dlc_windows_casino")
    
        -- IPL Removals
        RemoveIpl("hei_bi_hw1_13_door")
        RemoveIpl("v_carshowroom") -- -30.8793, -1088.336, 25.4221
        RemoveIpl("shutter_open")
        RemoveIpl("shutter_closed")
        RemoveIpl("DES_StiltHouse_imapend") -- -1020.5, 663.41, 154.75
        RemoveIpl("csr_inMission")
        RemoveIpl("facelobbyfake")
        RemoveIpl("CS1_02_cf_offmission") -- -146.3837, 6161.5, 30.2062
        RemoveIpl("farm_burnt") -- 2447.9, 4973.4, 47.7
        RemoveIpl("farm_burnt_props") -- 2447.9, 4973.4, 47.7
        RemoveIpl("des_farmhs_endimap") -- 2450.595, 4959.929
        RemoveIpl("des_farmhs_end_occl") -- 2450.595, 4959.929
        RemoveIpl("FIBlobbyfake") -- 105.4557, -745.4835, 44.7548
        RemoveIpl("id2_14_during2") -- 716.84, -962.05, 31.59
        RemoveIpl("id2_14_on_fire") -- 716.84, -962.05, 31.59
        RemoveIpl("id2_14_post_no_int") -- 716.84, -962.05, 31.59
        RemoveIpl("id2_14_pre_no_int") -- 716.84, -962.05, 31.59
        RemoveIpl("TrevorsMP") -- 1973, 3815, 34
        RemoveIpl("TrevorsTrailer") -- 1973, 3815, 34
        RemoveIpl("DT1_03_Shutter") -- 23.9346, -669.7552, 30.8853
        RemoveIpl("smboat") -- -2041.974, -1031.582, 12.981
        RemoveIpl("sp1_10_fake_interior")
        RemoveIpl("sp1_10_fake_interior_lod")
        RemoveIpl("DT1_05_HC_REMOVE") -- 169, -670.3, 41.9
        RemoveIpl("jewel2fake") -- -630.4205, -236.7843, 37.057
        RemoveIpl("bh1_16_refurb") -- -623.6868, -231.935, 40.30703
        RemoveIpl("ch1_02_closed")
        RemoveIpl("scafstartimap")
        RemoveIpl("bh1_16_doors_shut")
        RemoveIpl("CS3_07_MPGates") -- -1601.424, 2808.213, 16.2598
        RemoveIpl("prologue01")
        RemoveIpl("prologue01c")
        RemoveIpl("prologue01d")
        RemoveIpl("prologue01e")
        RemoveIpl("prologue01f")
        RemoveIpl("prologue01g")
        RemoveIpl("prologue01h")
        RemoveIpl("prologue01i")
        RemoveIpl("prologue01j")
        RemoveIpl("prologue01k")
        RemoveIpl("prologue01z")
        RemoveIpl("prologue02")
        RemoveIpl("prologue03")
        RemoveIpl("prologue03b")
        RemoveIpl("prologue04")
        RemoveIpl("prologue04b")
        RemoveIpl("prologue05")
        RemoveIpl("prologue05b")
        RemoveIpl("prologue06")
        RemoveIpl("prologue06b")
        RemoveIpl("prologue06_int")
        RemoveIpl("prologuerd")
        RemoveIpl("prologuerdb")
        RemoveIpl("prologue_DistantLights")
        RemoveIpl("prologue_LODLights")
        RemoveIpl("prologue_m2_door")
        RemoveIpl("hei_sm_16_interior_v_bahama_milo_")
        RemoveIpl("canyonriver01_traincrash") -- -532.1309, 4526.187, 88.7955
        RemoveIpl("railing_end") -- -532.1309, 4526.187, 88.7955
        RemoveIpl("apa_v_mp_h_01_a")
        RemoveIpl("apa_v_mp_h_06_b")
        RemoveIpl("apa_v_mp_h_08_c")
        RemoveIpl("ex_dt1_02_office_01c")
        RemoveIpl("ex_dt1_11_office_01b")
        RemoveIpl("ex_sm_13_office_01a")
        RemoveIpl("ex_sm_15_office_02b")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware01_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware02_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware03_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware04_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware05_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_3_biker_dlc_int_ware02_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_4_biker_dlc_int_ware03_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_5_biker_dlc_int_ware04_milo")
        RemoveIpl("ex_exec_warehouse_placement_interior_1_int_warehouse_s_dlc_milo")
        RemoveIpl("ex_exec_warehouse_placement_interior_0_int_warehouse_m_dlc_milo")
        RemoveIpl("ex_exec_warehouse_placement_interior_2_int_warehouse_l_dlc_milo")
        RemoveIpl("imp_impexp_interior_placement_interior_1_impexp")
        RemoveIpl("imp_impexp_interior_placement")
        RemoveIpl("imp_impexp_interior_placement_interior_0_impexp_int_01_milo_")
        RemoveIpl("imp_impexp_interior_placement_interior_1_impexp_intwaremed_milo_")
        RemoveIpl("imp_impexp_interior_placement_interior_2_imptexp_mod_int_01_milo_")
        RemoveIpl("imp_impexp_interior_placement_interior_3_impexp_int_02_milo_")
    
        -- North Yankton
        RemoveIpl("prologue01")
        RemoveIpl("prologue01c")
        RemoveIpl("prologue01d")
        RemoveIpl("prologue01e")
        RemoveIpl("prologue01f")
        RemoveIpl("prologue01g")
        RemoveIpl("prologue01h")
        RemoveIpl("prologue01i")
        RemoveIpl("prologue01j")
        RemoveIpl("prologue01k")
        RemoveIpl("prologue01z")
        RemoveIpl("prologue02")
        RemoveIpl("prologue03")
        RemoveIpl("prologue03b")
        RemoveIpl("prologue04")
        RemoveIpl("prologue04b")
        RemoveIpl("prologue05")
        RemoveIpl("prologue05b")
        RemoveIpl("prologue06")
        RemoveIpl("prologue06b")
        RemoveIpl("prologue06_int")
        RemoveIpl("prologuerd")
        RemoveIpl("prologuerdb")
        RemoveIpl("prologue_DistantLights")
        RemoveIpl("prologue_LODLights")
        RemoveIpl("prologue_m2_door")
    
        -- Cassino
        RequestIpl("vw_casino_main")
        -- RequestIpl("vw_dlc_casino_door")
        -- RequestIpl("hei_dlc_casino_door")
        RequestIpl("hei_dlc_windows_casino")
    
    --ARCADE_BAR--
    RefreshInterior(int_arcade1)
    RefreshInterior(int_plan1)
    
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_flat") --blue shell
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_beams") --brick
    EnableInteriorProp(int_arcade1, "entity_set_screens") -- TV sets
    EnableInteriorProp(int_arcade1, "entity_set_big_screen") -- big telly
    EnableInteriorProp(int_arcade1, "entity_set_constant_geometry") -- glass shelves + bar
    EnableInteriorProp(int_arcade1, "entity_set_ret_light_no_neon")
    EnableInteriorProp(int_arcade1, "ch_chint02_00_dropped_ceiling")
    EnableInteriorProp(int_arcade1, "entity_set_hip_light_no_neon")
    EnableInteriorProp(int_arcade1, "arcade_bar")
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_streetx4") --assault rifles
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_mirror") --mirror ceiling
    
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_carpet") -- carpets
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict") --dirty shell
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict") --mud
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_clean_up") --dirt
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_clean_up") -- closed vending machines
    
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_claw")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_monkey")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_patriot")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_retro")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_brawler")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_racer")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_love")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_cabs")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_gunner") --no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_teller")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_king") --no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_strife") --no
    
    EnableInteriorProp(int_arcade1, "entity_set_plushie_01")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_02")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_03")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_04")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_05")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_06")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_07")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_08") -- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_09")-- a toy
    
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_01") --signboard
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_02")--signboard
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_03")--signboard
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_04")--signboard
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_05")--signboard
    EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_06")--signboard
    EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_07")--signboard
    EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_08")--signboard
    
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_01") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_02") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_03") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_04") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_05") --wall paint
    EnableInteriorProp(int_arcade1, "entity_set_mural_option_06") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_07") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_08") --wall paint
    
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_01") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_02") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_03") --painted floor
    EnableInteriorProp(int_arcade1, "entity_set_floor_option_04") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_05") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_06") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_07") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_08")--painted floor
    
    EnableInteriorProp(int_plan1, "set_plan_casino") --casino on the table
    EnableInteriorProp(int_plan1, "set_plan_computer") --comp
    EnableInteriorProp(int_plan1, "set_plan_keypad")
    
    EnableInteriorProp(int_plan1, "set_plan_hacker")
    EnableInteriorProp(int_plan1, "set_plan_mechanic")
    EnableInteriorProp(int_plan1, "set_plan_weapons")
    
    EnableInteriorProp(int_plan1, "set_plan_vault")
    EnableInteriorProp(int_plan1, "set_plan_wall") --stone wall
    EnableInteriorProp(int_plan1, "set_plan_setup") --light for plan
    EnableInteriorProp(int_plan1, "set_plan_bed") --the room
    DisableInteriorProp(int_plan1, "set_plan_pre_setup") -- trash everywhere
    DisableInteriorProp(int_plan1, "set_plan_no_bed") --trash in the bed
    EnableInteriorProp(int_plan1, "set_plan_garage")
    EnableInteriorProp(int_plan1, "set_plan_scribbles")
    EnableInteriorProp(int_plan1, "set_plan_arcade_x4")
    EnableInteriorProp(int_plan1, "set_plan_plans")
    EnableInteriorProp(int_plan1, "set_plan_plastic_explosives")
    EnableInteriorProp(int_plan1, "set_plan_cockroaches")
    EnableInteriorProp(int_plan1, "set_plan_electric_drill")
    EnableInteriorProp(int_plan1, "set_plan_vault_drill")
    EnableInteriorProp(int_plan1, "set_plan_vault_laser")
    EnableInteriorProp(int_plan1, "set_plan_stealth_outfits")
    EnableInteriorProp(int_plan1, "set_plan_hacking_device")
    EnableInteriorProp(int_plan1, "set_plan_gruppe_sechs_outfits")
    EnableInteriorProp(int_plan1, "set_plan_fireman_helmet")
    EnableInteriorProp(int_plan1, "set_plan_drone_parts")
    EnableInteriorProp(int_plan1, "set_plan_vault_keycard_01a")
    EnableInteriorProp(int_plan1, "set_plan_swipe_card_01b")
    EnableInteriorProp(int_plan1, "set_plan_swipe_card_01a")
    EnableInteriorProp(int_plan1, "set_plan_vault_drill_alt")
    EnableInteriorProp(int_plan1, "set_plan_vault_laser_alt")
    
        EnableInteriorProp(258561,"standard_bunker_set")
        EnableInteriorProp(258561,"Bunker_Style_C")
        EnableInteriorProp(258561,"Office_Upgrade_set")
        EnableInteriorProp(258561,"Gun_schematic_set")
        EnableInteriorProp(258561,"security_upgrade")
        EnableInteriorProp(258561,"gun_range_lights")
        EnableInteriorProp(258561,"gun_locker_upgrade")
        RefreshInterior(258561)
        EnableInteriorProp(258561,"standard_bunker_set")
        EnableInteriorProp(258561,"Bunker_Style_C")
        EnableInteriorProp(258561,"Office_Upgrade_set")
        EnableInteriorProp(258561,"Gun_schematic_set")
        EnableInteriorProp(258561,"security_upgrade")
        EnableInteriorProp(258561,"gun_range_lights")
        EnableInteriorProp(258561,"gun_locker_upgrade")
        RefreshInterior(258561)
    end)
else
    local int_arcade1 = GetInteriorAtCoordsWithType(743.26500000,-816.71220000,21.66042000,"int_arcade")
    local int_plan1 = GetInteriorAtCoordsWithType(710.87930000,-813.11000000,15.19892000,"int_plan")
    CreateThread(function()
        -- OnEnterMp()
        -- SetInstancePriorityMode(true)
    
        -- IPL Requests
        RequestIpl("chop_props") -- -13.83, -1455.45, 31.81
        RequestIpl("v_rockclub")
        RequestIpl("rc12b_default") -- 330.4596, -584.8196, 42.3174
        -- RequestIpl("v_carshowroom") -- -30.8793, -1088.336, 25.4221
        RequestIpl("shr_int") -- -59.7936, -1098.784, 27.2612
        RequestIpl("shr_int_lod")
        RequestIpl("shutter_closed")
        RequestIpl("FINBANK") -- 2.69689322, -667.0166, 16.1306286
        RequestIpl("facelobby") -- -1047.9, -233.0, 39.0
        RequestIpl("CS1_02_cf_onmission1") -- -146.3837, 6161.5, 30.2062
        RequestIpl("CS1_02_cf_onmission2") -- -146.3837, 6161.5, 30.2062
        RequestIpl("CS1_02_cf_onmission3") -- -146.3837, 6161.5, 30.2062
        RequestIpl("CS1_02_cf_onmission4") -- -146.3837, 6161.5, 30.2062
        RequestIpl("des_farmhouse") -- 2447.9, 4973.4, 47.7
        RequestIpl("des_farmhs_endimap") -- 2450.595, 4959.929
        RequestIpl("des_farmhs_end_occl") -- 2450.595, 4959.929
        RequestIpl("des_farmhs_startimap") -- 2450.595, 4959.929
        RequestIpl("des_farmhs_start_occl") -- 2450.595, 4959.929
        RequestIpl("farm") -- 2447.9, 4973.4, 47.7
        RequestIpl("farm_props") -- 2447.9, 4973.4, 47.7
        RequestIpl("farm_int") -- 2447.9, 4973.4, 47.7
        RequestIpl("farmint") -- 2447.9, 4973.4, 47.7
        -- RequestIpl("FIBlobby") -- 105.4557, -745.4835, 44.7548
        -- RequestIpl("FBI_colPLUG") -- 74.29, -736.05, 46.76
        -- RequestIpl("FBI_repair") -- 74.29, -736.05, 46.76
        RequestIpl("id2_14_during1") -- 716.84, -962.05, 31.59
        RequestIpl("TrevorsTrailerTidy") -- 1973, 3815, 34
        RequestIpl("dt1_03_gr_closed") -- 23.7318, -647.2123, 37.9549
        RequestIpl("dt1_21_prop_lift") -- -180.5771, -1016.928, 28.2893
        RequestIpl("dt1_21_prop_lift_on") -- -180.5771, -1016.928, 28.2893
        -- RequestIpl("yogagame") -- -781.6566, 186.8937, 71.8352
        RequestIpl("v_tunnel_hole") -- -14.651, -604.3639, 25.1823
        RequestIpl("V_Michael") -- -811.2679, 179.3344, 75.7408
        RequestIpl("V_Michael_Garage") -- -810.5301, 187.7868, 71.4786
        RequestIpl("V_Michael_FameShame") -- -810.5301, 187.7868, 71.4786
        RequestIpl("V_Michael_JewelHeist") -- -813.3, 177.5, 75.76
        RequestIpl("V_Michael_plane_ticket") -- -813.3, 177.5, 75.76
        RequestIpl("V_Michael_Scuba") -- -810.5301, 187.7868, 71.4786
        RequestIpl("hei_yacht_heist") -- -2043.974, -1031.582, 11.981
        RequestIpl("hei_yacht_heist_Bar")
        RequestIpl("hei_yacht_heist_Bedrm")
        RequestIpl("hei_yacht_heist_Bridge")
        RequestIpl("hei_yacht_heist_DistantLights")
        RequestIpl("hei_yacht_heist_enginrm")
        RequestIpl("hei_yacht_heist_LODLights")
        RequestIpl("hei_yacht_heist_Lounge")
        RequestIpl("cargoship") -- -162.8918, -2365.769, 0
        RequestIpl("sc1_01_newbill") -- -351, -1324, 44.02
        RequestIpl("hw1_02_newbill")
        RequestIpl("hw1_emissive_newbill")
        RequestIpl("sc1_14_newbill")
        RequestIpl("dt1_17_newbill") -- 391.81, -962.71, 41.97
        RequestIpl("SC1_01_OldBill") -- -351, -1324, 44.02
        RequestIpl("SC1_30_Keep_Closed")
        RequestIpl("refit_unload") -- -583.1606, -282.3967, 35.394
        RequestIpl("post_hiest_unload") -- -630.4205, -236.7843, 37.057
        RequestIpl("occl_meth_grp1") -- 29.4838, 3735.593, 38.688
        RequestIpl("Michael_premier") -- -813.3, 177.5, 75.76
        RequestIpl("DT1_05_HC_REQ") -- 169, -670.3, 41.9
        RequestIpl("DT1_05_REQUEST") -- 163.4, -745.7, 251
        RequestIpl("scafendimap")
        RequestIpl("ferris_finale_anim") -- -1675.178, -1143.605, 12.0175
        RequestIpl("ferris_finale_anim_lod")
        RequestIpl("CS2_06_TriAf02") -- 2384.969, 4277.583, 30.379
        RequestIpl("CS4_08_TriAf02")
        RequestIpl("CS4_04_TriAf03") -- 1577.881, 3836.107, 30.7717
        RequestIpl("AP1_04_TriAf01") -- -1277.629, -2030.913, 1.2823
    
        RequestIpl("grdlc_int_01_shell")
        RequestIpl("gr_grdlc_int_01")
        RequestIpl("gr_grdlc_int_02")
        RequestIpl("gr_entrance_placement")
        RequestIpl("gr_grdlc_interior_placement")
        RequestIpl("gr_grdlc_interior_placement_interior_0_grdlc_int_01_milo")
        RequestIpl("grgrdlc_interior_placement_interior_1_grdlc_int_02_milo")
        RequestIpl("gr_case0_bunkerclosed") -- 848.6175, 2996.567, 45.81612
        RequestIpl("gr_case1_bunkerclosed") -- 2126.785, 3335.04, 48.21422
        RequestIpl("gr_case2_bunkerclosed") -- 2493.654, 3140.399, 51.28789
        RequestIpl("gr_case3_bunkerclosed") -- 481.0465, 2995.135, 43.96672
        RequestIpl("gr_case4_bunkerclosed") -- -391.3216, 4363.728, 58.65862
        RequestIpl("gr_case5_bunkerclosed") -- 1823.961, 4708.14, 42.4991
        RequestIpl("gr_case6_bunkerclosed") -- 1570.372, 2254.549, 78.89397
        RequestIpl("gr_case7_bunkerclosed") -- -783.0755, 5934.686, 24.31475
        RequestIpl("gr_case9_bunkerclosed") -- 24.43542, 2959.705, 58.35517
        RequestIpl("gr_case10_bunkerclosed") -- -3058.714, 3329.19, 12.5844
        RequestIpl("gr_case11_bunkerclosed") -- -3180.466, 1374.192, 19.9597
    
        RequestIpl("cs5_4_trains") -- 2773.61, 2835.327, 35.1903
        RequestIpl("chophillskennel") -- 19.0568, 536.4818, 169.6277
        RequestIpl("bnkheist_apt_dest")
        RequestIpl("bnkheist_apt_norm")
        RequestIpl("redcarpet") -- 300.5927, 300.5927, 104.3776
        RequestIpl("cs3_05_water_grp1") -- -24.685, 3032.92, 40.331
        RequestIpl("cs3_05_water_grp1_lod")
        RequestIpl("cs3_05_water_grp2") -- -24.685, 3032.92, 40.331
        RequestIpl("cs3_05_water_grp2_lod")
        RequestIpl("canyonriver01") -- -532.1309, 4526.187, 88.7955
        RequestIpl("canyonriver01_lod")
        RequestIpl("railing_start") -- -532.1309, 4526.187, 88.7955
        RequestIpl("bh1_47_joshhse_unburnt")
        RequestIpl("bh1_47_joshhse_unburnt_lod")
        RequestIpl("bkr_bi_hw1_13_int") -- 982.0083, -100.8747, 74.84512
        RequestIpl("CanyonRvrShallow")
        RequestIpl("methtrailer_grp1")
        RequestIpl("lr_cs6_08_grave_closed")
        RequestIpl("bkr_bi_id1_23_door")
        RequestIpl("ch1_02_open")
        RequestIpl("sp1_10_real_interior") -- -248.6731, -2010.603, 30.14562
        RequestIpl("sp1_10_real_interior_lod")
        RequestIpl("Carwash_with_spinners")
        RequestIpl("ex_sm_13_office_02a")
        -- RequestIpl("bkr_biker_interior_placement_interior_0_biker_dlc_int_01_milo") -- 1107.04, -3157.399, -37.51859
        -- RequestIpl("bkr_biker_interior_placement_interior_1_biker_dlc_int_02_milo") -- 998.4809, -3164.711, -38.90733
        -- RequestIpl("bkr_biker_interior_placement_interior_6_biker_dlc_int_ware05_milo") -- 1165, -3196.6, -39.01306
        RequestIpl("ch3_rd2_bishopschickengraffiti") -- 1861.28, 2402.11, 58.53
        RequestIpl("cs5_04_mazebillboardgraffiti") -- 2697.32, 3162.18, 58.1
        RequestIpl("cs5_roads_ronoilgraffiti") -- 2119.12, 3058.21, 53.25
        RequestIpl("ba_barriers_case0")
        RequestIpl("ba_case0_forsale")
        RequestIpl("ba_case0_dixon")
        RequestIpl("ba_case0_madonna")
        RequestIpl("ba_case0_solomun")
        RequestIpl("ba_case0_taleofus")
        RequestIpl("ba_barriers_case1")
        RequestIpl("ba_case1_forsale")
        RequestIpl("ba_case1_dixon")
        RequestIpl("ba_case1_madonna")
        RequestIpl("ba_case1_solomun")
        RequestIpl("ba_case1_taleofus")
        RequestIpl("ba_barriers_case2")
        RequestIpl("ba_case2_forsale")
        RequestIpl("ba_case2_dixon")
        RequestIpl("ba_case2_madonna")
        RequestIpl("ba_case2_solomun")
        RequestIpl("ba_case2_taleofus")
        RequestIpl("ba_barriers_case3")
        RequestIpl("ba_case3_forsale")
        RequestIpl("ba_case3_dixon")
        RequestIpl("ba_case3_madonna")
        RequestIpl("ba_case3_solomun")
        RequestIpl("ba_case3_taleofus")
        RequestIpl("ba_barriers_case4")
        RequestIpl("ba_case4_forsale")
        RequestIpl("ba_case4_dixon")
        RequestIpl("ba_case4_madonna")
        RequestIpl("ba_case4_solomun")
        RequestIpl("ba_case4_taleofus")
        RequestIpl("ba_barriers_case5")
        RequestIpl("ba_case5_forsale")
        RequestIpl("ba_case5_dixon")
        RequestIpl("ba_case5_madonna")
        RequestIpl("ba_case5_solomun")
        RequestIpl("ba_case5_taleofus")
        RequestIpl("ba_barriers_case6")
        RequestIpl("ba_case6_forsale")
        RequestIpl("ba_case6_dixon")
        RequestIpl("ba_case6_madonna")
        RequestIpl("ba_case6_solomun")
        RequestIpl("ba_case6_taleofus")
        RequestIpl("ba_barriers_case7")
        RequestIpl("ba_case7_forsale")
        RequestIpl("ba_case7_dixon")
        RequestIpl("ba_case7_madonna")
        RequestIpl("ba_case7_solomun")
        RequestIpl("ba_case7_taleofus")
        RequestIpl("ba_barriers_case8")
        RequestIpl("ba_case8_forsale")
        RequestIpl("ba_case8_dixon")
        RequestIpl("ba_case8_madonna")
        RequestIpl("ba_case8_solomun")
        RequestIpl("ba_case8_taleofus")
        RequestIpl("ba_barriers_case9")
        RequestIpl("ba_case9_forsale")
        RequestIpl("ba_case9_dixon")
        RequestIpl("ba_case9_madonna")
        RequestIpl("ba_case9_solomun")
        RequestIpl("ba_case9_taleofus")
        RequestIpl("gr_grdlc_yacht_lod")
        RequestIpl("gr_grdlc_yacht_placement")
        RequestIpl("gr_heist_yacht2")
        RequestIpl("gr_heist_yacht2_bar")
        RequestIpl("gr_heist_yacht2_bar_lod")
        RequestIpl("gr_heist_yacht2_bedrm")
        RequestIpl("gr_heist_yacht2_bedrm_lod")
        RequestIpl("gr_heist_yacht2_bridge")
        RequestIpl("gr_heist_yacht2_bridge_lod")
        RequestIpl("gr_heist_yacht2_enginrm")
        RequestIpl("gr_heist_yacht2_enginrm_lod")
        RequestIpl("gr_heist_yacht2_lod")
        RequestIpl("gr_heist_yacht2_lounge")
        RequestIpl("gr_heist_yacht2_lounge_lod")
        RequestIpl("gr_heist_yacht2_slod")
        RequestIpl("ex_dt1_02_office_02b")
        RequestIpl("ex_dt1_11_office_02c")
        RequestIpl("ex_sm_15_office_01a")
        -- RequestIpl("vw_casino_main") -- 1100.000, 220.000, -50.000
        -- RequestIpl("vw_dlc_casino_door")
        -- RequestIpl("hei_dlc_casino_door")
        -- RequestIpl("hei_dlc_windows_casino")
    
        -- IPL Removals
        RemoveIpl("hei_bi_hw1_13_door")
        RemoveIpl("v_carshowroom") -- -30.8793, -1088.336, 25.4221
        RemoveIpl("shutter_open")
        RemoveIpl("shutter_closed")
        RemoveIpl("DES_StiltHouse_imapend") -- -1020.5, 663.41, 154.75
        RemoveIpl("csr_inMission")
        RemoveIpl("facelobbyfake")
        RemoveIpl("CS1_02_cf_offmission") -- -146.3837, 6161.5, 30.2062
        RemoveIpl("farm_burnt") -- 2447.9, 4973.4, 47.7
        RemoveIpl("farm_burnt_props") -- 2447.9, 4973.4, 47.7
        RemoveIpl("des_farmhs_endimap") -- 2450.595, 4959.929
        RemoveIpl("des_farmhs_end_occl") -- 2450.595, 4959.929
        RemoveIpl("FIBlobbyfake") -- 105.4557, -745.4835, 44.7548
        RemoveIpl("id2_14_during_door") -- 716.84, -962.05, 31.59
        RemoveIpl("id2_14_during2") -- 716.84, -962.05, 31.59
        RemoveIpl("id2_14_on_fire") -- 716.84, -962.05, 31.59
        RemoveIpl("id2_14_post_no_int") -- 716.84, -962.05, 31.59
        RemoveIpl("id2_14_pre_no_int") -- 716.84, -962.05, 31.59
        RemoveIpl("TrevorsMP") -- 1973, 3815, 34
        RemoveIpl("TrevorsTrailer") -- 1973, 3815, 34
        RemoveIpl("DT1_03_Shutter") -- 23.9346, -669.7552, 30.8853
        RemoveIpl("smboat") -- -2041.974, -1031.582, 12.981
        RemoveIpl("sp1_10_fake_interior")
        RemoveIpl("sp1_10_fake_interior_lod")
        RemoveIpl("DT1_05_HC_REMOVE") -- 169, -670.3, 41.9
        RemoveIpl("jewel2fake") -- -630.4205, -236.7843, 37.057
        RemoveIpl("bh1_16_refurb") -- -623.6868, -231.935, 40.30703
        RemoveIpl("ch1_02_closed")
        RemoveIpl("scafstartimap")
        RemoveIpl("bh1_16_doors_shut")
        RemoveIpl("CS3_07_MPGates") -- -1601.424, 2808.213, 16.2598
        RemoveIpl("prologue01")
        RemoveIpl("prologue01c")
        RemoveIpl("prologue01d")
        RemoveIpl("prologue01e")
        RemoveIpl("prologue01f")
        RemoveIpl("prologue01g")
        RemoveIpl("prologue01h")
        RemoveIpl("prologue01i")
        RemoveIpl("prologue01j")
        RemoveIpl("prologue01k")
        RemoveIpl("prologue01z")
        RemoveIpl("prologue02")
        RemoveIpl("prologue03")
        RemoveIpl("prologue03b")
        RemoveIpl("prologue04")
        RemoveIpl("prologue04b")
        RemoveIpl("prologue05")
        RemoveIpl("prologue05b")
        RemoveIpl("prologue06")
        RemoveIpl("prologue06b")
        RemoveIpl("prologue06_int")
        RemoveIpl("prologuerd")
        RemoveIpl("prologuerdb")
        RemoveIpl("prologue_DistantLights")
        RemoveIpl("prologue_LODLights")
        RemoveIpl("prologue_m2_door")
        RemoveIpl("hei_sm_16_interior_v_bahama_milo_")
        RemoveIpl("canyonriver01_traincrash") -- -532.1309, 4526.187, 88.7955
        RemoveIpl("railing_end") -- -532.1309, 4526.187, 88.7955
        RemoveIpl("apa_v_mp_h_01_a")
        RemoveIpl("apa_v_mp_h_06_b")
        RemoveIpl("apa_v_mp_h_08_c")
        RemoveIpl("ex_dt1_02_office_01c")
        RemoveIpl("ex_dt1_11_office_01b")
        RemoveIpl("ex_sm_13_office_01a")
        RemoveIpl("ex_sm_15_office_02b")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware01_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware02_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware03_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware04_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_2_biker_dlc_int_ware05_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_3_biker_dlc_int_ware02_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_4_biker_dlc_int_ware03_milo")
        RemoveIpl("bkr_biker_interior_placement_interior_5_biker_dlc_int_ware04_milo")
        RemoveIpl("ex_exec_warehouse_placement_interior_1_int_warehouse_s_dlc_milo")
        RemoveIpl("ex_exec_warehouse_placement_interior_0_int_warehouse_m_dlc_milo")
        RemoveIpl("ex_exec_warehouse_placement_interior_2_int_warehouse_l_dlc_milo")
        RemoveIpl("imp_impexp_interior_placement_interior_1_impexp")
        RemoveIpl("imp_impexp_interior_placement")
        RemoveIpl("imp_impexp_interior_placement_interior_0_impexp_int_01_milo_")
        RemoveIpl("imp_impexp_interior_placement_interior_1_impexp_intwaremed_milo_")
        RemoveIpl("imp_impexp_interior_placement_interior_2_imptexp_mod_int_01_milo_")
        RemoveIpl("imp_impexp_interior_placement_interior_3_impexp_int_02_milo_")
    
        -- North Yankton
        RemoveIpl("prologue01")
        RemoveIpl("prologue01c")
        RemoveIpl("prologue01d")
        RemoveIpl("prologue01e")
        RemoveIpl("prologue01f")
        RemoveIpl("prologue01g")
        RemoveIpl("prologue01h")
        RemoveIpl("prologue01i")
        RemoveIpl("prologue01j")
        RemoveIpl("prologue01k")
        RemoveIpl("prologue01z")
        RemoveIpl("prologue02")
        RemoveIpl("prologue03")
        RemoveIpl("prologue03b")
        RemoveIpl("prologue04")
        RemoveIpl("prologue04b")
        RemoveIpl("prologue05")
        RemoveIpl("prologue05b")
        RemoveIpl("prologue06")
        RemoveIpl("prologue06b")
        RemoveIpl("prologue06_int")
        RemoveIpl("prologuerd")
        RemoveIpl("prologuerdb")
        RemoveIpl("prologue_DistantLights")
        RemoveIpl("prologue_LODLights")
        RemoveIpl("prologue_m2_door")
    
        -- Cassino
        RequestIpl("vw_casino_main")
        -- RequestIpl("vw_dlc_casino_door")
        -- RequestIpl("hei_dlc_casino_door")
        RequestIpl("hei_dlc_windows_casino")
    
    --ARCADE_BAR--
    RefreshInterior(int_arcade1)
    RefreshInterior(int_plan1)
    
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_flat") --blue shell
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_beams") --brick
    EnableInteriorProp(int_arcade1, "entity_set_screens") -- TV sets
    EnableInteriorProp(int_arcade1, "entity_set_big_screen") -- big telly
    EnableInteriorProp(int_arcade1, "entity_set_constant_geometry") -- glass shelves + bar
    EnableInteriorProp(int_arcade1, "entity_set_ret_light_no_neon")
    EnableInteriorProp(int_arcade1, "ch_chint02_00_dropped_ceiling")
    EnableInteriorProp(int_arcade1, "entity_set_hip_light_no_neon")
    EnableInteriorProp(int_arcade1, "arcade_bar")
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_streetx4") --assault rifles
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_ceiling_mirror") --mirror ceiling
    
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_carpet") -- carpets
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict") --dirty shell
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict") --mud
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_clean_up") --dirt
    DisableInteriorProp(int_arcade1, "entity_set_arcade_set_derelict_clean_up") -- closed vending machines
    
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_claw")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_monkey")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_patriot")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_retro")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_brawler")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_racer")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_love")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_cabs")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_gunner") --no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_teller")--no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_king") --no
    EnableInteriorProp(int_arcade1, "entity_set_arcade_set_trophy_strife") --no
    
    EnableInteriorProp(int_arcade1, "entity_set_plushie_01")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_02")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_03")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_04")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_05")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_06")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_07")-- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_08") -- a toy
    EnableInteriorProp(int_arcade1, "entity_set_plushie_09")-- a toy
    
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_01") --signboard
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_02")--signboard
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_03")--signboard
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_04")--signboard
    DisableInteriorProp(int_arcade1, "entity_set_mural_neon_option_05")--signboard
    EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_06")--signboard
    EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_07")--signboard
    EnableInteriorProp(int_arcade1, "entity_set_mural_neon_option_08")--signboard
    
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_01") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_02") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_03") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_04") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_05") --wall paint
    EnableInteriorProp(int_arcade1, "entity_set_mural_option_06") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_07") --wall paint
    DisableInteriorProp(int_arcade1, "entity_set_mural_option_08") --wall paint
    
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_01") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_02") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_03") --painted floor
    EnableInteriorProp(int_arcade1, "entity_set_floor_option_04") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_05") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_06") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_07") --painted floor
    DisableInteriorProp(int_arcade1, "entity_set_floor_option_08")--painted floor
    
    EnableInteriorProp(int_plan1, "set_plan_casino") --casino on the table
    EnableInteriorProp(int_plan1, "set_plan_computer") --comp
    EnableInteriorProp(int_plan1, "set_plan_keypad")
    
    EnableInteriorProp(int_plan1, "set_plan_hacker")
    EnableInteriorProp(int_plan1, "set_plan_mechanic")
    EnableInteriorProp(int_plan1, "set_plan_weapons")
    
    EnableInteriorProp(int_plan1, "set_plan_vault")
    EnableInteriorProp(int_plan1, "set_plan_wall") --stone wall
    EnableInteriorProp(int_plan1, "set_plan_setup") --light for plan
    EnableInteriorProp(int_plan1, "set_plan_bed") --the room
    DisableInteriorProp(int_plan1, "set_plan_pre_setup") -- trash everywhere
    DisableInteriorProp(int_plan1, "set_plan_no_bed") --trash in the bed
    EnableInteriorProp(int_plan1, "set_plan_garage")
    EnableInteriorProp(int_plan1, "set_plan_scribbles")
    EnableInteriorProp(int_plan1, "set_plan_arcade_x4")
    EnableInteriorProp(int_plan1, "set_plan_plans")
    EnableInteriorProp(int_plan1, "set_plan_plastic_explosives")
    EnableInteriorProp(int_plan1, "set_plan_cockroaches")
    EnableInteriorProp(int_plan1, "set_plan_electric_drill")
    EnableInteriorProp(int_plan1, "set_plan_vault_drill")
    EnableInteriorProp(int_plan1, "set_plan_vault_laser")
    EnableInteriorProp(int_plan1, "set_plan_stealth_outfits")
    EnableInteriorProp(int_plan1, "set_plan_hacking_device")
    EnableInteriorProp(int_plan1, "set_plan_gruppe_sechs_outfits")
    EnableInteriorProp(int_plan1, "set_plan_fireman_helmet")
    EnableInteriorProp(int_plan1, "set_plan_drone_parts")
    EnableInteriorProp(int_plan1, "set_plan_vault_keycard_01a")
    EnableInteriorProp(int_plan1, "set_plan_swipe_card_01b")
    EnableInteriorProp(int_plan1, "set_plan_swipe_card_01a")
    EnableInteriorProp(int_plan1, "set_plan_vault_drill_alt")
    EnableInteriorProp(int_plan1, "set_plan_vault_laser_alt")
    
        EnableInteriorProp(258561,"standard_bunker_set")
        EnableInteriorProp(258561,"Bunker_Style_C")
        EnableInteriorProp(258561,"Office_Upgrade_set")
        EnableInteriorProp(258561,"Gun_schematic_set")
        EnableInteriorProp(258561,"security_upgrade")
        EnableInteriorProp(258561,"gun_range_lights")
        EnableInteriorProp(258561,"gun_locker_upgrade")
        RefreshInterior(258561)
        EnableInteriorProp(258561,"standard_bunker_set")
        EnableInteriorProp(258561,"Bunker_Style_C")
        EnableInteriorProp(258561,"Office_Upgrade_set")
        EnableInteriorProp(258561,"Gun_schematic_set")
        EnableInteriorProp(258561,"security_upgrade")
        EnableInteriorProp(258561,"gun_range_lights")
        EnableInteriorProp(258561,"gun_locker_upgrade")
        RefreshInterior(258561)
    end)    
end

Citizen.CreateThread(function()
    local ipls = {
        "v_lestersoft_milo_",
        "id2_14_during1",
        "id2_14_during_door"
    }

    for _, ipl in ipairs(ipls) do
        if not IsIplActive(ipl) then
            RequestIpl(ipl)
        end
    end
end)