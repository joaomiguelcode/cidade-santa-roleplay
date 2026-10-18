cityName = GetConvar("cityName", "")

Fathers = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,42,43,44 }
Mothers = { 21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,45 }

PedList = {
	
}

local CityConfig = {
    ["Santa"] = function()
            
        -- PedList[#PedList+1] = { -- QG_90
        --     Distance = 100,
        --     Coords = { -556.80,5032.15,159.99,161.95 },
        --     Model = "a_c_cow"
        -- }
        -- PedList[#PedList+1] = { -- QG_90
        --     Distance = 100,
        --     Coords = { -561.27,5035.61,159.99,182.17 },
        --     Model = "a_c_cow"
        -- }
        PedList[#PedList+1] = { -- QG_95
            Distance = 100,
            Coords = { -3153.81,1510.54,37.74,340.23 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_95
            Distance = 100,
            Coords = { -3149.53,1510.34,37.74,343.68 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { -1560.55,355.15,86.96,187.09 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- mansao230
            Distance = 100,
            Coords = { -1103.64,378.19,69.96,181.42 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- mansao230
            Distance = 100,
            Coords = { -1106.36,378.49,70.15,178.59 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- mansao230
            Distance = 100,
            Coords = { -1108.54,378.48,70.31,184.26 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- mansao230
            Distance = 100,
            Coords = { -1110.79,378.85,70.53,184.26 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { -2228.09,-607.7,5.31,48.19 },
            Model = "samurai",
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["CidadeNobre"] = function()
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_60
            Distance = 100,
            Coords = { 1271.99,-1696.76,53.70,33.82},
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_60
            Distance = 100,
            Coords = { 1269.03,-1698.58,53.87,24.84 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -811.11,-1260.40,5.49,144.89 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -815.67,-1266.03,5.18,320.17 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -818.45,-1263.86,5.18,321.97 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -807.87,-1267.07,5.21,47.87 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -806.04,-1264.98,5.45,53.06 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 676.04,3752.72,35.06,266.46 },
            Model = "samurai",
        }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 201.47,-1008.17,29.5,153.08 },
            Model = "mp_m_freemode_01",
            Custom = {
                clothings = json.decode('{"mask":{"item":300,"texture":0},"tshirt":{"item":130,"texture":0},"backpack":{"item":157,"texture":1},"shoes":{"item":34,"texture":0},"watch":{"item":-1,"texture":0},"bracelet":{"item":16,"texture":1},"decals":{"item":245,"texture":0},"glass":{"item":0,"texture":0},"accessory":{"item":250,"texture":0},"ear":{"item":31,"texture":0},"vest":{"item":0,"texture":0},"pants":{"item":294,"texture":1},"hat":{"item":-1,"texture":0},"torso":{"item":15,"texture":0},"arms":{"item":216,"texture":0}}'),
                barbershop = json.decode('[0,21,0.15,0,8,0,-1,-1,-1,35,27,26,10,0.01,56,0,0,0,5,0.99,56,5,0.57,52,32,0.58,56,-0.92,0.38,0.69,0.65,-0.22,0,0.3,0,-0.19,0.25,-0.37,-0.28,0.32,0.8,-0.94,-0.16,0.47,0.07,-0.37,0,10,0.99,56,0,null,null,null,null,null,null,null,null,0,0,0,0.0,0.0,false,0,45]'),
            }
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Boomerang"] = function()
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_10
            Distance = 100,
            Coords = { 339.36,-13.79,83.00,304.60 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_10
            Distance = 100,
            Coords = { 340.72,-12.55,83.00,298.44 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_10
            Distance = 100,
            Coords = { 341.74,-11.67,83.00,227.98 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_59
            Distance = 100,
            Coords = { -2933.76,46.92,11.61,62.37 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_59
            Distance = 100,
            Coords = { -2934.77,45.12,11.61,62.37 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_59
            Distance = 100,
            Coords = { -2935.58,43.32,11.61,62.37 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_44
            Distance = 100,
            Coords = { 908.33,-13.62,78.76,37.64 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_44
            Distance = 100,
            Coords = { 910.52,-14.89,78.76,85.85 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_44
            Distance = 100,
            Coords = { 912.05,-15.45,78.76,232.24 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2646.66,5281.99,47.26,16.86 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2649.96,5284.04,47.23,28.35 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2642.65,5281.01,47.30,17.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2644.45,5281.24,47.28,197.15 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -811.11,-1260.40,5.49,144.89 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -815.67,-1266.03,5.18,320.17 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -818.45,-1263.86,5.18,321.97 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -807.87,-1267.07,5.21,47.87 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -806.04,-1264.98,5.45,53.06 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Malta"] = function()
        PedList[#PedList+1] = { -- emprego leiteiro 
            Distance = 100,
            Coords = { 2515.64,4763.61,34.78,319.87 },
            Model = "ig_chef2"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 46.93,3715.25,39.74,252.70 },
            Model = "u_m_m_bikehire_01"
        }

        PedList[#PedList+1] = { -- emprego colheita
            Distance = 100,
            Coords = { 2091.70,5041.92,41.15,234.07 },
            Model = "ig_chef2"
        }

        PedList[#PedList+1] = { -- emprego colheita2
            Distance = 100,
            Coords = { 2094.58,5045.58,41.24,79.62 },
            Model = "ig_chef2"
        }

        PedList[#PedList+1] = { -- emprego agricultor
            Distance = 100,
            Coords = { 751.76,6459.12,31.52,68.06 },
            Model = "ig_chef2"
        }

        PedList[#PedList+1] = { -- emprego pesca
            Distance = 100,
            Coords = { 1408.08,6715.11,14.48,60.53 },
            Model = "cs_josef"
        }

        PedList[#PedList+1] = { -- emprego mineradora
            Distance = 100,
            Coords = { 2957.57,2830.08,45.28,66.31 },
            Model = "s_m_m_gardener_01"
        }
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { -- pesca
            Distance = 100,
            Coords = { 1340.20,4225.27,33.92,81.25 },
            Model = "s_m_m_gardener_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 297.30,131.58,104.12,334.46 },
            Model = "u_f_y_princess"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { -1990.35,3031.75,35.24,336.39 },
            Model = "s_m_m_marine_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { -3185.92,3260.48,1.14,304.73 },
            Model = "s_m_y_marine_03"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = {  -2803.49,3327.08,32.81,239.62 },
            Model = "csb_ramp_marine"
        }
        -- PedList[#PedList+1] = {
        --     Distance = 100,
        --     Coords = {  -557.28,-183.28,38.22,209.90 },
        --     Model = "cs_casey"
        -- }
        -- PedList[#PedList+1] = {
        --     Distance = 100,
        --     Coords = {  1844.63,2575.02,46.01,102.71 },
        --     Model = "cs_fbisuit_01"
        -- }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = {  -659.01,-87.99,38.79,304.29 },
            Model = "s_m_m_scientist_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = {  1125.25,-1576.53,35.38,269.44 },
            Model = "s_m_y_fireman_01"
        }
        PedList[#PedList+1] = { -- Juridico
            Distance = 100,
            Coords = { -539.08,-204.44,37.65,209.68 },
            Model = "csb_reporter"
        }
        PedList[#PedList+1] = { -- Juridico Sandy Shoes
            Distance = 100,
            Coords = { 1896.81,3569.60,38.82,124.55 },
            Model = "csb_reporter"
        }
        PedList[#PedList+1] = { -- Bombeiros
            Distance = 100,
            Coords = { -652.91,-105.81,37.94,218.21 },
            Model = "s_m_y_fireman_01"
        }
        PedList[#PedList+1] = { -- Bombeiros Sandy Shoes
            Distance = 100,
            Coords = { 1683.71,3571.48,35.43,220.49 },
            Model = "s_m_y_fireman_01"
        }
        PedList[#PedList+1] = { -- Hospital
            Distance = 100,
            Coords = { -327.08,-614.99,32.79,301.10 },
            Model = "s_m_m_doctor_01"
        }
        PedList[#PedList+1] = { -- Hospital Sandy Shoes
            Distance = 100,
            Coords = { 1765.81,3624.48,34.58,211.33 },
            Model = "s_m_m_doctor_01"
        }
        PedList[#PedList+1] = { -- Mecanica
            Distance = 100,
            Coords = { 551.31,-194.28,54.50,96.70 },
            Model = "s_m_m_gaffer_01"
        }
        PedList[#PedList+1] = { -- Mecanica Sandy Shoes
            Distance = 100,
            Coords = { 1716.76,3687.68,34.52,306.94 },
            Model = "s_m_m_gaffer_01"
        }
        PedList[#PedList+1] = { -- Exercito Zancudo
            Distance = 100,
            Coords = { -2165.09,3242.29,32.81,152.51 },
            Model = "s_m_y_marine_03"
        }
        PedList[#PedList+1] = { -- Exercito Sandy Shoes
            Distance = 100,
            Coords = { 1746.35,3803.50,35.46,124.72 },
            Model = "s_m_y_marine_03"
        }
        PedList[#PedList+1] = { -- pesca
            Distance = 100,
            Coords = { 1422.20,3825.85,32.19,332.87 },
            Model = "cs_floyd"
        }
        PedList[#PedList+1] = { -- igreja
            Distance = 100,
            Coords = {  1812.06,3911.32,35.05,108.95 },
            Model = "cs_priest"
        }
        PedList[#PedList+1] = { -- igreja
            Distance = 100,
            Coords = {  -787.42,5.39,41.68,210.44 },
            Model = "cs_priest"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = {  -525.78,-214.44,37.65,214.37 },
            Model = "s_m_m_ciasec_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = {  1598.78,2550.78,45.55,275.97 },
            Model = "s_m_m_ciasec_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }

    end,
    ["Kingdom"] = function()
        
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        -- PedList[#PedList+1] = { -- Arenas
        --     Distance = 100,
        --     Coords = { 187.53,-1002.94,30.53,161.58 },
        --     Model = "mp_m_fibsec_01"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 144.07,-983.69,30.6,255.12 },
            Model = "csb_tomcasino"
        }
    end,
    ["Imperium"] = function()
        
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        -- PedList[#PedList+1] = { -- Arenas
        --     Distance = 100,
        --     Coords = { 187.53,-1002.94,30.53,161.58 },
        --     Model = "mp_m_fibsec_01"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["GoatRP"] = function()
        
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        -- PedList[#PedList+1] = { -- Arenas
        --     Distance = 100,
        --     Coords = { 187.53,-1002.94,30.53,161.58 },
        --     Model = "mp_m_fibsec_01"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["District99"] = function()
        
        
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2440.58,4736.35,34.29,317.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2432.5,4744.58,34.31,317.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2424.47,4752.37,34.31,317.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2416.28,4760.8,34.31,317.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2408.6,4768.88,34.31,317.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2400.32,4777.48,34.53,317.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2432.46,4802.66,34.83,137.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2440.62,4794.22,34.66,137.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2448.65,4786.57,34.64,137.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2456.88,4778.08,34.49,137.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2464.53,4770.04,34.37,137.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2473.38,4760.98,34.31,137.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2495.03,4762.77,34.37,137.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2503.13,4754.08,34.31,137.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2511.34,4746.04,34.31,137.50 },
                Model = "a_c_cow"
            }
            PedList[#PedList+1] = { -- Leiteiro
                Distance = 100,
                Coords = { 2519.56,4737.35,34.29,137.50 },
                Model = "a_c_cow"
            }
            -- PedList[#PedList+1] = { -- Arenas
            --     Distance = 100,
            --     Coords = { 187.53,-1002.94,30.53,161.58 },
            --     Model = "mp_m_fibsec_01"
            -- }
            PedList[#PedList+1] = { --
                Distance = 100,
                Coords = { 4890.0,-5454.01,33.72,187.09 },
                Model = "mp_m_exarmy_01"
            }
            PedList[#PedList+1] = { -- Lana
                Distance = 100,
                Coords = { 141.75,-987.54,29.67,230.78},
                Model = "csb_tomcasino"
            }
    end,
    ["Orizon"] = function()
        
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        -- PedList[#PedList+1] = { -- Arenas
        --     Distance = 100,
        --     Coords = { 187.53,-1002.94,30.53,161.58 },
        --     Model = "mp_m_fibsec_01"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }

        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Krown"] = function()
        
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        -- PedList[#PedList+1] = { -- Arenas
        --     Distance = 100,
        --     Coords = { 187.53,-1002.94,30.53,161.58 },
        --     Model = "mp_m_fibsec_01"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Orizon"] = function()
        
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        -- PedList[#PedList+1] = { -- Arenas
        --     Distance = 100,
        --     Coords = { 187.53,-1002.94,30.53,161.58 },
        --     Model = "mp_m_fibsec_01"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }

        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Liberty99"] = function()
        -- PedList[#PedList+1] = { -- dogtag
        --     Distance = 100,
        --     Coords = { 198.15,-1006.41,29.50,155.91 },
        --     Model = "csb_ramp_marine"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Royal"] = function()
        
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        -- PedList[#PedList+1] = { -- Arenas
        --     Distance = 100,
        --     Coords = { 187.53,-1002.94,30.53,161.58 },
        --     Model = "mp_m_fibsec_01"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 144.07,-983.69,30.6,255.12 },
            Model = "csb_tomcasino"
        }
    end,
    ["Real"] = function()
        
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        -- PedList[#PedList+1] = { -- Arenas
        --     Distance = 100,
        --     Coords = { 187.53,-1002.94,30.53,161.58 },
        --     Model = "mp_m_fibsec_01"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 2957.02,2829.93,45.36,121.89 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 2515.53,4763.32,34.76,104.89 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 2091.54,5042.01,41.16,314.65 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 749.02,6454.5,31.95,150.24 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 1420.03,6715.31,14.52,175.75 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Prime"] = function()
        
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        -- PedList[#PedList+1] = { -- Arenas
        --     Distance = 100,
        --     Coords = { 187.53,-1002.94,30.53,161.58 },
        --     Model = "mp_m_fibsec_01"
        -- }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 2955.24,2829.73,45.81,354.56 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 2515.53,4763.32,34.76,104.89 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 2091.54,5042.01,41.16,314.65 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 749.02,6454.5,31.95,150.24 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { 1420.03,6715.31,14.52,175.75 },
            Model = "a_m_m_hillbilly_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Universo"] = function()
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Grande"] = function()
        PedList[#PedList+1] = { -- FFA Wellington
            Distance = 100,
            Coords = { 830.37,-2507.34,28.48,269.3 },
            Model = "mp_m_freemode_01",
            Custom = {
                barbershop = json.decode('[0,21,0.15,0,8,0,-1,-1,-1,35,27,26,10,0.01,56,0,0,0,5,0.99,56,5,0.57,52,32,0.58,56,-0.92,0.38,0.69,0.65,-0.22,0,0.3,0,-0.19,0.25,-0.37,-0.28,0.32,0.8,-0.94,-0.16,0.47,0.07,-0.37,0,10,0.99,56,0,null,null,null,null,null,null,null,null,0,0,0,0.0,0.0,false,0,45]'),
            }
        }

        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_96
            Distance = 100,
            Coords = { -72.57,809.89,227.25,237.93 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_395
            Distance = 100,
            Coords = { 1271.99,-1696.76,53.70,33.82},
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_395
            Distance = 100,
            Coords = { 1269.03,-1698.58,53.87,24.84 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_89
            Distance = 100,
            Coords = { -2320.93,223.46,167.60,295.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_89
            Distance = 100,
            Coords = { -2318.21,217.45,167.60,291.09 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Militar
            Distance = 100,
            Coords = { 2432.89,-373.33,93.00,267.65 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Militar
            Distance = 100,
            Coords = { 2433.62,-369.56,93.00,279.55 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Militar
            Distance = 100,
            Coords = { 2433.25,-365.96,92.99,266.42 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Militar
            Distance = 100,
            Coords = { 2433.39,-363.37,92.99,238.10 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2646.66,5281.99,47.26,16.86 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2649.96,5284.04,47.23,28.35 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2642.65,5281.01,47.30,17.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2644.45,5281.24,47.28,197.15 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1938.41,3008.18,34.00,313.42 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1934.71,3007.32,34.00,29.70 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1936.61,3009.32,34.00,223.51 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1938.05,3010.77,34.00,52.42 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1936.24,3005.48,34.00,249.75 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -811.11,-1260.40,5.49,144.89 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -815.67,-1266.03,5.18,320.17 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -818.45,-1263.86,5.18,321.97 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -807.87,-1267.07,5.21,47.87 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -806.04,-1264.98,5.45,53.06 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Fronteira"] = function()
        
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_96
            Distance = 100,
            Coords = { -72.57,809.89,227.25,237.93 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_60
            Distance = 100,
            Coords = { 1271.99,-1696.76,53.70,33.82},
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_60
            Distance = 100,
            Coords = { 1269.03,-1698.58,53.87,24.84 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_133
            Distance = 100,
            Coords = { 1419.58,-2344.72,69.80,118.05 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_133
            Distance = 100,
            Coords = { 1422.00,-2348.31,69.79,108.61 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_89
            Distance = 100,
            Coords = { -2320.93,223.46,167.60,295.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- QG_89
            Distance = 100,
            Coords = { -2318.21,217.45,167.60,291.09 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Militar
            Distance = 100,
            Coords = { 2432.89,-373.33,93.00,267.65 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Militar
            Distance = 100,
            Coords = { 2433.62,-369.56,93.00,279.55 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Militar
            Distance = 100,
            Coords = { 2433.25,-365.96,92.99,266.42 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Militar
            Distance = 100,
            Coords = { 2433.39,-363.37,92.99,238.10 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2646.66,5281.99,47.26,16.86 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2649.96,5284.04,47.23,28.35 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2642.65,5281.01,47.30,17.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Prf
            Distance = 100,
            Coords = { 2644.45,5281.24,47.28,197.15 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1938.41,3008.18,34.00,313.42 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1934.71,3007.32,34.00,29.70 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1936.61,3009.32,34.00,223.51 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1938.05,3010.77,34.00,52.42 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Exercito
            Distance = 100,
            Coords = { -1936.24,3005.48,34.00,249.75 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -811.11,-1260.40,5.49,144.89 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -815.67,-1266.03,5.18,320.17 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -818.45,-1263.86,5.18,321.97 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -807.87,-1267.07,5.21,47.87 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Tatica
            Distance = 100,
            Coords = { -806.04,-1264.98,5.45,53.06 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { --
            Distance = 100,
            Coords = { 4890.0,-5454.01,33.72,187.09 },
            Model = "mp_m_exarmy_01"
        }
    end,
    ["Gaules"] = function()
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,

    ["Alexandria"] = function()
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Pescaria
            Distance = 100,
            Coords = { -1559.10,-1155.45,3.91,129.08 },
            Model = "ig_old_man2"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,
    ["Maresia"] = function()
        PedList[#PedList+1] = {
            Distance = 100,
            Coords = { -857.09,-1246.72,5.14,150.24 },
            Model = "s_f_y_casino_01"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.58,4736.35,34.29,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.5,4744.58,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2424.47,4752.37,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2416.28,4760.8,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2408.6,4768.88,34.31,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2400.32,4777.48,34.53,317.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2432.46,4802.66,34.83,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2440.62,4794.22,34.66,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2448.65,4786.57,34.64,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2456.88,4778.08,34.49,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2464.53,4770.04,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2473.38,4760.98,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2495.03,4762.77,34.37,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2503.13,4754.08,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2511.34,4746.04,34.31,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Leiteiro
            Distance = 100,
            Coords = { 2519.56,4737.35,34.29,137.50 },
            Model = "a_c_cow"
        }
        PedList[#PedList+1] = { -- Lana
            Distance = 100,
            Coords = { 141.75,-987.54,29.67,230.78},
            Model = "csb_tomcasino"
        }
    end,

}

CreateThread(function()
    if CityConfig[cityName] then
        CityConfig[cityName]()
    end
end)
