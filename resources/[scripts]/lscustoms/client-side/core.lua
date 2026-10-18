-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("lscustoms")
cityName = GetConvar("cityName", "")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local activeBennys = false
local presetMode = false
local originalCategory = nil
local originalMod = nil
local originalPrimaryColour = nil
local originalSecondaryColour = nil
local originalPearlescentColour = nil
local originalWheelColour = nil
local originalDashColour = nil
local originalInterColour = nil
local originalWindowTint = nil
local originalWheelCategory = nil
local originalWheel = nil
local originalWheelType = nil
local originalCustomWheels = nil
local originalNeonLightState = nil
local originalNeonLightSide = nil
local originalNeonColourR = nil
local originalNeonColourG = nil
local originalNeonColourB = nil
local originalXenonColour = nil
local originalPoliceLivery = nil
local originalPlateIndex = nil
local attemptingPurchase = false
local isPurchaseSuccessful = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local bennysLocations = {
	-- ["Ottos01"] = {pos = vec3(810.53,-980.74,26.77),heading = 277.8,permission = "Mechanic"},
	-- ["Ottos02"] = {pos = vec3(810.48,-968.36,26.77),heading = 269.3,permission = "Mechanic"},
	-- ["Ottos03"] = {pos = vec3(810.37,-956.65,26.77),heading = 266.46,permission = "Mechanic"},
	-- ["Ottos04"] = {pos = vec3(836.27,-959.59,26.49),heading = 274.97,permission = "Mechanic"},
	-- ["Ottos05"] = {pos = vec3(836.18,-968.34,26.49),heading = 269.3,permission = "Mechanic"},
	-- ["Ottos06"] = {pos = vec3(835.53,-976.99,26.64),heading = 274.97,permission = "Mechanic"},
	-- ["Ottos07"] = {pos = vec3(835.28,-985.62,26.64),heading = 269.3,permission = "Mechanic"	},
	-- ["Ottos08"] = {pos = vec3(818.54,-947.31,22.09),heading = 201.26,permission = "Mechanic"},
	-- ["Ottos09"] = {pos = vec3(1703.33,3270.0,41.15),heading = 201.26,permission = "Mechanic"}
}

if cityName == "Santa" then
	
	-- bennysLocations["Ottos126"] = { pos = vec3(620.95,-147.6,54.32), heading = 272.13, permission = "Mechanic"}
	-- bennysLocations["Ottos127"] = { pos = vec3(621.54,-156.22,54.32), heading = 269.3, permission = "Mechanic"}
	-- bennysLocations["Ottos128"] = { pos = vec3(621.0,-164.95,54.32), heading = 274.97, permission = "Mechanic"}
	-- bennysLocations["Ottos129"] = { pos = vec3(620.47,-173.69,54.32), heading = 272.13, permission = "Mechanic"}
	-- bennysLocations["Ottos130"] = { pos = vec3(620.88,-182.3,54.32), heading = 272.13, permission = "Mechanic"}
	-- bennysLocations["Ottos131"] = { pos = vec3(620.55,-191.2,54.32), heading = 272.13, permission = "Mechanic"}
	-- bennysLocations["Ottos132"] = { pos = vec3(621.26,-199.93,54.32), heading = 269.3, permission = "Mechanic"}
	bennysLocations["Ottos133"] = { pos = vec3(595.57,-175.76,54.17), heading = 181.42, permission = "Mechanic"}
	bennysLocations["Ottos134"] = { pos = vec3(598.4,-175.34,54.17), heading = 178.59, permission = "Mechanic"}
	bennysLocations["Ottos135"] = { pos = vec3(601.09,-175.3,54.17), heading = 184.26, permission = "Mechanic"}
	bennysLocations["Ottos136"] = { pos = vec3(581.08,-179.14,49.39), heading = 178.59, permission = "Mechanic"}
	bennysLocations["Ottos137"] = { pos = vec3(588.97,-178.53,49.39), heading = 184.26, permission = "Mechanic"}
	bennysLocations["Ottos138"] = { pos = vec3(597.1,-178.57,49.39), heading = 184.26, permission = "Mechanic"}
	bennysLocations["Ottos139"] = { pos = vec3(605.29,-178.1,49.39), heading = 178.59, permission = "Mechanic"}
	bennysLocations["Ottos140"] = { pos = vec3(615.06,-213.27,54.91), heading = 85.04, permission = "Mechanic"}
	bennysLocations["Ottos141"] = { pos = vec3(571.28,-148.06,54.17), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos142"] = { pos = vec3(579.16,-147.61,54.17), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos143"] = { pos = vec3(587.41,-147.78,54.17), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos144"] = { pos = vec3(595.35,-147.62,54.17), heading = 357.17, permission = "Mechanic"}
	bennysLocations["Ottos145"] = { pos = vec3(603.59,-147.73,54.17), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos146"] = { pos = vec3(587.41,-178.24,54.42), heading = 175.75, permission = "Mechanic"}
	bennysLocations["Ottos147"] = { pos = vec3(583.55,-178.28,54.42), heading = 175.75, permission = "Mechanic"}
	bennysLocations["Ottos148"] = { pos = vec3(579.37,-179.22,54.39), heading = 181.42, permission = "Mechanic"}
	bennysLocations["Ottos149"] = { pos = vec3(575.9,-178.98,54.37), heading = 175.75, permission = "Mechanic"}
	bennysLocations["Ottos150"] = { pos = vec3(578.39,-199.25,54.17), heading = 178.59, permission = "Mechanic"}
	bennysLocations["Ottos151"] = { pos = vec3(586.12,-198.77,54.17), heading = 184.26, permission = "Mechanic"}
	bennysLocations["Ottos152"] = { pos = vec3(593.95,-199.04,54.17), heading = 184.26, permission = "Mechanic"}
	bennysLocations["Ottos153"] = { pos = vec3(602.0,-198.71,54.17), heading = 178.59, permission = "Mechanic"}

elseif cityName == "CidadeNobre" then

	bennysLocations["Ottos227"] = { pos = vec3(98.96,-1794.44,29.28), heading = 141.74, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(92.27,-1788.87,29.28), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(85.51,-1783.1,29.28), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(78.76,-1777.56,29.28), heading = 141.74, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(72.03,-1771.95,29.28), heading = 130.4, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(99.16,-1767.82,29.28), heading = 317.49, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(92.42,-1762.24,29.28), heading = 317.49, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(85.84,-1756.65,29.28), heading = 323.15, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(79.02,-1750.99,29.28), heading = 331.66, permission = "Mechanic"}
	bennysLocations["Ottos236"] = { pos = vec3(-4.24,-1760.99,29.28), heading = 48.19, permission = "Mechanic"}

elseif cityName == "Boomerang" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.5,-2054.25,13.41), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.2,-2060.91,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.67,-2067.42,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.16,-2073.81,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.76,-2080.5,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.31,-2104.33,13.36), heading = 141.74, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.61,-2107.25,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.07,-2110.6,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.42,-2116.29,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.01,-2119.64,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.36,-2125.29,13.36), heading = 130.4, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.26,-2128.45,13.36), heading = 121.89, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.08,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.41,-2134.99,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.61,-2131.29,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.41,-2123.82,13.26), heading = 232.45, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.63,-2120.17,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.24,-2112.72,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.48,-2109.01,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos250"] = { pos = vec3(-1170.3,-2204.95,15.05), heading = 331.66, permission = "Mechanic"}
	bennysLocations["Ottos251"] = { pos = vec3(-1187.28,-2176.68,13.19), heading = 266.46, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}

elseif cityName == "Malta" then

	bennysLocations["Ottos258"] = { pos = vec3(587.44,-178.83,54.77), heading = 359.34, permission = "Mechanic"}
	bennysLocations["Ottos259"] = { pos = vec3(583.48,-179.00,54.77), heading = 357.85, permission = "Mechanic"}
	bennysLocations["Ottos260"] = { pos = vec3(579.32,-179.35,54.79), heading = 182.23, permission = "Mechanic"}
	bennysLocations["Ottos261"] = { pos = vec3(575.82,-179.60,54.78), heading = 180.02, permission = "Mechanic"}
	bennysLocations["Ottos262"] = { pos = vec3(601.71,-198.92,54.52), heading = 180.36, permission = "Mechanic"}
	bennysLocations["Ottos263"] = { pos = vec3(594.05,-198.28,54.52), heading = 180.89, permission = "Mechanic"}
	bennysLocations["Ottos264"] = { pos = vec3(586.12,-198.68,54.52), heading = 179.11, permission = "Mechanic"}
	bennysLocations["Ottos265"] = { pos = vec3(578.28,-198.52,54.52), heading = 179.96, permission = "Mechanic"}
	bennysLocations["Ottos266"] = { pos = vec3(595.65,-146.48,54.52), heading = 0.05, permission = "Mechanic"}
	bennysLocations["Ottos267"] = { pos = vec3(603.61,-147.32,54.52), heading = 354.69, permission = "Mechanic"}
	bennysLocations["Ottos268"] = { pos = vec3(571.47,-147.70,54.52), heading = 0.46, permission = "Mechanic"}
	bennysLocations["Ottos269"] = { pos = vec3(579.37,-146.30,54.52), heading = 0.42, permission = "Mechanic"}
	bennysLocations["Ottos270"] = { pos = vec3(571.41,-147.57,54.52), heading = 358.18, permission = "Mechanic"}
	bennysLocations["Ottos271"] = { pos = vec3(614.52,-213.45,55.27), heading = 271.41, permission = "Mechanic"}
	bennysLocations["Ottos272"] = { pos = vec3(587.62,-146.25,54.52), heading = 1.08, permission = "Mechanic"}
	bennysLocations["Ottos273"] = { pos = vec3(610.24,-138.08,54.53), heading = 88.04, permission = "Mechanic"}
	bennysLocations["Ottos274"] = { pos = vec3(1711.54,3687.36,34.52), heading = 299.94, permission = "Mechanic"}
	bennysLocations["Ottos275"] = { pos = vec3(1708.53,3692.46,34.52), heading = 30.40, permission = "Mechanic"}
	bennysLocations["Ottos276"] = { pos = vec3(1705.89,3697.51,34.52), heading = 303.71, permission = "Mechanic"}

elseif cityName == "Kingdom" then

	bennysLocations["Ottos258"] = { pos = vec3(587.44,-178.83,54.77), heading = 359.34, permission = "Mechanic"}
	bennysLocations["Ottos259"] = { pos = vec3(583.48,-179.00,54.77), heading = 357.85, permission = "Mechanic"}
	bennysLocations["Ottos260"] = { pos = vec3(579.32,-179.35,54.79), heading = 182.23, permission = "Mechanic"}
	bennysLocations["Ottos261"] = { pos = vec3(575.82,-179.60,54.78), heading = 180.02, permission = "Mechanic"}
	bennysLocations["Ottos262"] = { pos = vec3(601.71,-198.92,54.52), heading = 180.36, permission = "Mechanic"}
	bennysLocations["Ottos263"] = { pos = vec3(594.05,-198.28,54.52), heading = 180.89, permission = "Mechanic"}
	bennysLocations["Ottos264"] = { pos = vec3(586.12,-198.68,54.52), heading = 179.11, permission = "Mechanic"}
	bennysLocations["Ottos265"] = { pos = vec3(578.28,-198.52,54.52), heading = 179.96, permission = "Mechanic"}
	bennysLocations["Ottos266"] = { pos = vec3(595.65,-146.48,54.52), heading = 0.05, permission = "Mechanic"}
	bennysLocations["Ottos267"] = { pos = vec3(603.61,-147.32,54.52), heading = 354.69, permission = "Mechanic"}
	bennysLocations["Ottos268"] = { pos = vec3(571.47,-147.70,54.52), heading = 0.46, permission = "Mechanic"}
	bennysLocations["Ottos269"] = { pos = vec3(579.37,-146.30,54.52), heading = 0.42, permission = "Mechanic"}
	bennysLocations["Ottos270"] = { pos = vec3(571.41,-147.57,54.52), heading = 358.18, permission = "Mechanic"}
	bennysLocations["Ottos271"] = { pos = vec3(614.52,-213.45,55.27), heading = 271.41, permission = "Mechanic"}
	bennysLocations["Ottos272"] = { pos = vec3(587.62,-146.25,54.52), heading = 1.08, permission = "Mechanic"}
	bennysLocations["Ottos273"] = { pos = vec3(610.24,-138.08,54.53), heading = 88.04, permission = "Mechanic"}


elseif cityName == "Imperium" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.45,-2054.36,13.41), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.04,-2060.96,13.4), heading = 48.19, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.52,-2067.58,13.4), heading = 48.19, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.07,-2074.02,13.4), heading = 42.52, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.61,-2080.69,13.4), heading = 48.19, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.32,-2104.36,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.54,-2107.22,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.0,-2110.61,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos236"] = { pos = vec3(-1149.21,-2113.48,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.4,-2116.23,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.04,-2119.62,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos239"] = { pos = vec3(-1140.22,-2122.49,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.41,-2125.34,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.25,-2128.44,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos242"] = { pos = vec3(-1131.4,-2131.3,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.11,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.46,-2134.82,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.62,-2131.23,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.36,-2123.72,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.69,-2120.04,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.29,-2112.59,13.26), heading = 223.94, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.58,-2108.87,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}
elseif cityName == "GoatRP" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.45,-2054.36,13.41), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.04,-2060.96,13.4), heading = 48.19, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.52,-2067.58,13.4), heading = 48.19, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.07,-2074.02,13.4), heading = 42.52, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.61,-2080.69,13.4), heading = 48.19, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.32,-2104.36,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.54,-2107.22,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.0,-2110.61,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos236"] = { pos = vec3(-1149.21,-2113.48,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.4,-2116.23,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.04,-2119.62,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos239"] = { pos = vec3(-1140.22,-2122.49,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.41,-2125.34,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.25,-2128.44,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos242"] = { pos = vec3(-1131.4,-2131.3,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.11,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.46,-2134.82,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.62,-2131.23,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.36,-2123.72,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.69,-2120.04,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.29,-2112.59,13.26), heading = 223.94, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.58,-2108.87,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}

elseif cityName == "District99" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.45,-2054.36,13.41), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.04,-2060.96,13.4), heading = 48.19, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.52,-2067.58,13.4), heading = 48.19, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.07,-2074.02,13.4), heading = 42.52, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.61,-2080.69,13.4), heading = 48.19, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.32,-2104.36,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.54,-2107.22,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.0,-2110.61,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos236"] = { pos = vec3(-1149.21,-2113.48,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.4,-2116.23,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.04,-2119.62,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos239"] = { pos = vec3(-1140.22,-2122.49,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.41,-2125.34,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.25,-2128.44,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos242"] = { pos = vec3(-1131.4,-2131.3,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.11,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.46,-2134.82,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.62,-2131.23,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.36,-2123.72,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.69,-2120.04,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.29,-2112.59,13.26), heading = 223.94, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.58,-2108.87,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}
	bennysLocations["Ottos253"] = { pos = vec3(-1682.88,-463.46,42.76), heading = 45.36, permission = "Mechanic"} -- MANSAO256

elseif cityName == "Krown" then

	bennysLocations["Ottos258"] = { pos = vec3(587.44,-178.83,54.77), heading = 359.34, permission = "Mechanic"}
	bennysLocations["Ottos259"] = { pos = vec3(583.48,-179.00,54.77), heading = 357.85, permission = "Mechanic"}
	bennysLocations["Ottos260"] = { pos = vec3(579.32,-179.35,54.79), heading = 182.23, permission = "Mechanic"}
	bennysLocations["Ottos261"] = { pos = vec3(575.82,-179.60,54.78), heading = 180.02, permission = "Mechanic"}
	bennysLocations["Ottos262"] = { pos = vec3(601.71,-198.92,54.52), heading = 180.36, permission = "Mechanic"}
	bennysLocations["Ottos263"] = { pos = vec3(594.05,-198.28,54.52), heading = 180.89, permission = "Mechanic"}
	bennysLocations["Ottos264"] = { pos = vec3(586.12,-198.68,54.52), heading = 179.11, permission = "Mechanic"}
	bennysLocations["Ottos265"] = { pos = vec3(578.28,-198.52,54.52), heading = 179.96, permission = "Mechanic"}
	bennysLocations["Ottos266"] = { pos = vec3(595.65,-146.48,54.52), heading = 0.05, permission = "Mechanic"}
	bennysLocations["Ottos267"] = { pos = vec3(603.61,-147.32,54.52), heading = 354.69, permission = "Mechanic"}
	bennysLocations["Ottos268"] = { pos = vec3(571.47,-147.70,54.52), heading = 0.46, permission = "Mechanic"}
	bennysLocations["Ottos269"] = { pos = vec3(579.37,-146.30,54.52), heading = 0.42, permission = "Mechanic"}
	bennysLocations["Ottos270"] = { pos = vec3(571.41,-147.57,54.52), heading = 358.18, permission = "Mechanic"}
	bennysLocations["Ottos271"] = { pos = vec3(614.52,-213.45,55.27), heading = 271.41, permission = "Mechanic"}
	bennysLocations["Ottos272"] = { pos = vec3(587.62,-146.25,54.52), heading = 1.08, permission = "Mechanic"}
	bennysLocations["Ottos273"] = { pos = vec3(610.24,-138.08,54.53), heading = 88.04, permission = "Mechanic"}

elseif cityName == "Orizon" then

	bennysLocations["Ottos258"] = { pos = vec3(587.44,-178.83,54.77), heading = 359.34, permission = "Mechanic"}
	bennysLocations["Ottos259"] = { pos = vec3(583.48,-179.00,54.77), heading = 357.85, permission = "Mechanic"}
	bennysLocations["Ottos260"] = { pos = vec3(579.32,-179.35,54.79), heading = 182.23, permission = "Mechanic"}
	bennysLocations["Ottos261"] = { pos = vec3(575.82,-179.60,54.78), heading = 180.02, permission = "Mechanic"}
	bennysLocations["Ottos262"] = { pos = vec3(601.71,-198.92,54.52), heading = 180.36, permission = "Mechanic"}
	bennysLocations["Ottos263"] = { pos = vec3(594.05,-198.28,54.52), heading = 180.89, permission = "Mechanic"}
	bennysLocations["Ottos264"] = { pos = vec3(586.12,-198.68,54.52), heading = 179.11, permission = "Mechanic"}
	bennysLocations["Ottos265"] = { pos = vec3(578.28,-198.52,54.52), heading = 179.96, permission = "Mechanic"}
	bennysLocations["Ottos266"] = { pos = vec3(595.65,-146.48,54.52), heading = 0.05, permission = "Mechanic"}
	bennysLocations["Ottos267"] = { pos = vec3(603.61,-147.32,54.52), heading = 354.69, permission = "Mechanic"}
	bennysLocations["Ottos268"] = { pos = vec3(571.47,-147.70,54.52), heading = 0.46, permission = "Mechanic"}
	bennysLocations["Ottos269"] = { pos = vec3(579.37,-146.30,54.52), heading = 0.42, permission = "Mechanic"}
	bennysLocations["Ottos270"] = { pos = vec3(571.41,-147.57,54.52), heading = 358.18, permission = "Mechanic"}
	bennysLocations["Ottos271"] = { pos = vec3(614.52,-213.45,55.27), heading = 271.41, permission = "Mechanic"}
	bennysLocations["Ottos272"] = { pos = vec3(587.62,-146.25,54.52), heading = 1.08, permission = "Mechanic"}
	bennysLocations["Ottos273"] = { pos = vec3(610.24,-138.08,54.53), heading = 88.04, permission = "Mechanic"}

elseif cityName == "Liberty99" then

	bennysLocations["Ottos258"] = { pos = vec3(587.44,-178.83,54.77), heading = 359.34, permission = "Mechanic"}
	bennysLocations["Ottos259"] = { pos = vec3(583.48,-179.00,54.77), heading = 357.85, permission = "Mechanic"}
	bennysLocations["Ottos260"] = { pos = vec3(579.32,-179.35,54.79), heading = 182.23, permission = "Mechanic"}
	bennysLocations["Ottos261"] = { pos = vec3(575.82,-179.60,54.78), heading = 180.02, permission = "Mechanic"}
	bennysLocations["Ottos262"] = { pos = vec3(601.71,-198.92,54.52), heading = 180.36, permission = "Mechanic"}
	bennysLocations["Ottos263"] = { pos = vec3(594.05,-198.28,54.52), heading = 180.89, permission = "Mechanic"}
	bennysLocations["Ottos264"] = { pos = vec3(586.12,-198.68,54.52), heading = 179.11, permission = "Mechanic"}
	bennysLocations["Ottos265"] = { pos = vec3(578.28,-198.52,54.52), heading = 179.96, permission = "Mechanic"}
	bennysLocations["Ottos266"] = { pos = vec3(595.65,-146.48,54.52), heading = 0.05, permission = "Mechanic"}
	bennysLocations["Ottos267"] = { pos = vec3(603.61,-147.32,54.52), heading = 354.69, permission = "Mechanic"}
	bennysLocations["Ottos268"] = { pos = vec3(571.47,-147.70,54.52), heading = 0.46, permission = "Mechanic"}
	bennysLocations["Ottos269"] = { pos = vec3(579.37,-146.30,54.52), heading = 0.42, permission = "Mechanic"}
	bennysLocations["Ottos270"] = { pos = vec3(571.41,-147.57,54.52), heading = 358.18, permission = "Mechanic"}
	bennysLocations["Ottos271"] = { pos = vec3(614.52,-213.45,55.27), heading = 271.41, permission = "Mechanic"}
	bennysLocations["Ottos272"] = { pos = vec3(587.62,-146.25,54.52), heading = 1.08, permission = "Mechanic"}
	bennysLocations["Ottos273"] = { pos = vec3(610.24,-138.08,54.53), heading = 88.04, permission = "Mechanic"}

elseif cityName == "Royal" then

	bennysLocations["Ottos258"] = { pos = vec3(587.44,-178.83,54.77), heading = 359.34, permission = "Mechanic"}
	bennysLocations["Ottos259"] = { pos = vec3(583.48,-179.00,54.77), heading = 357.85, permission = "Mechanic"}
	bennysLocations["Ottos260"] = { pos = vec3(579.32,-179.35,54.79), heading = 182.23, permission = "Mechanic"}
	bennysLocations["Ottos261"] = { pos = vec3(575.82,-179.60,54.78), heading = 180.02, permission = "Mechanic"}
	bennysLocations["Ottos262"] = { pos = vec3(601.71,-198.92,54.52), heading = 180.36, permission = "Mechanic"}
	bennysLocations["Ottos263"] = { pos = vec3(594.05,-198.28,54.52), heading = 180.89, permission = "Mechanic"}
	bennysLocations["Ottos264"] = { pos = vec3(586.12,-198.68,54.52), heading = 179.11, permission = "Mechanic"}
	bennysLocations["Ottos265"] = { pos = vec3(578.28,-198.52,54.52), heading = 179.96, permission = "Mechanic"}
	bennysLocations["Ottos266"] = { pos = vec3(595.65,-146.48,54.52), heading = 0.05, permission = "Mechanic"}
	bennysLocations["Ottos267"] = { pos = vec3(603.61,-147.32,54.52), heading = 354.69, permission = "Mechanic"}
	bennysLocations["Ottos268"] = { pos = vec3(571.47,-147.70,54.52), heading = 0.46, permission = "Mechanic"}
	bennysLocations["Ottos269"] = { pos = vec3(579.37,-146.30,54.52), heading = 0.42, permission = "Mechanic"}
	bennysLocations["Ottos270"] = { pos = vec3(571.41,-147.57,54.52), heading = 358.18, permission = "Mechanic"}
	bennysLocations["Ottos271"] = { pos = vec3(614.52,-213.45,55.27), heading = 271.41, permission = "Mechanic"}
	bennysLocations["Ottos272"] = { pos = vec3(587.62,-146.25,54.52), heading = 1.08, permission = "Mechanic"}
	bennysLocations["Ottos273"] = { pos = vec3(610.24,-138.08,54.53), heading = 88.04, permission = "Mechanic"}

elseif cityName == "Real" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.5,-2054.25,13.41), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.2,-2060.91,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.67,-2067.42,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.16,-2073.81,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.76,-2080.5,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.31,-2104.33,13.36), heading = 141.74, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.61,-2107.25,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.07,-2110.6,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.42,-2116.29,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.01,-2119.64,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.36,-2125.29,13.36), heading = 130.4, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.26,-2128.45,13.36), heading = 121.89, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.08,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.41,-2134.99,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.61,-2131.29,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.41,-2123.82,13.26), heading = 232.45, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.63,-2120.17,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.24,-2112.72,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.48,-2109.01,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos250"] = { pos = vec3(-1170.3,-2204.95,15.05), heading = 331.66, permission = "Mechanic"}
	bennysLocations["Ottos251"] = { pos = vec3(-1187.28,-2176.68,13.19), heading = 266.46, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}

elseif cityName == "Prime" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.5,-2054.25,13.41), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.2,-2060.91,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.67,-2067.42,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.16,-2073.81,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.76,-2080.5,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.31,-2104.33,13.36), heading = 141.74, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.61,-2107.25,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.07,-2110.6,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.42,-2116.29,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.01,-2119.64,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.36,-2125.29,13.36), heading = 130.4, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.26,-2128.45,13.36), heading = 121.89, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.08,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.41,-2134.99,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.61,-2131.29,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.41,-2123.82,13.26), heading = 232.45, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.63,-2120.17,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.24,-2112.72,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.48,-2109.01,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos250"] = { pos = vec3(-1170.3,-2204.95,15.05), heading = 331.66, permission = "Mechanic"}
	bennysLocations["Ottos251"] = { pos = vec3(-1187.28,-2176.68,13.19), heading = 266.46, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}

elseif cityName == "Grande" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.5,-2054.25,13.41), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.2,-2060.91,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.67,-2067.42,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.16,-2073.81,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.76,-2080.5,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.31,-2104.33,13.36), heading = 141.74, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.61,-2107.25,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.07,-2110.6,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.42,-2116.29,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.01,-2119.64,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.36,-2125.29,13.36), heading = 130.4, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.26,-2128.45,13.36), heading = 121.89, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.08,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.41,-2134.99,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.61,-2131.29,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.41,-2123.82,13.26), heading = 232.45, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.63,-2120.17,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.24,-2112.72,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.48,-2109.01,13.26), heading = 229.61, permission = "Mechanic"}
	-- bennysLocations["Ottos250"] = { pos = vec3(-1170.3,-2204.95,15.05), heading = 331.66, permission = "Mechanic"}
	bennysLocations["Ottos251"] = { pos = vec3(-1187.28,-2176.68,13.19), heading = 266.46, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}
	bennysLocations["Ottos253"] = { pos = vec3(-1116.32,-2163.40,13.29), heading = 133.32, permission = "Mechanic"}
	bennysLocations["Ottos254"] = { pos = vec3(-1112.08,-2159.31,13.29), heading = 310.82, permission = "Mechanic"}
	bennysLocations["Ottos255"] = { pos = vec3(-1106.51,-2153.54,13.29), heading = 290.37, permission = "Mechanic"}
	bennysLocations["Ottos256"] = { pos = vec3(-1101.87,-2149.34,13.29), heading = 137.47, permission = "Mechanic"}
	bennysLocations["Ottos257"] = { pos = vec3(-1097.27,-2144.78,13.29), heading = 305.10, permission = "Mechanic"}
	bennysLocations["Ottos258"] = { pos = vec3(587.44,-178.83,54.77), heading = 359.34, permission = "Mechanic"}
	bennysLocations["Ottos259"] = { pos = vec3(583.48,-179.00,54.77), heading = 357.85, permission = "Mechanic"}
	bennysLocations["Ottos260"] = { pos = vec3(579.32,-179.35,54.79), heading = 182.23, permission = "Mechanic"}
	bennysLocations["Ottos261"] = { pos = vec3(575.82,-179.60,54.78), heading = 180.02, permission = "Mechanic"}
	bennysLocations["Ottos262"] = { pos = vec3(601.71,-198.92,54.52), heading = 180.36, permission = "Mechanic"}
	bennysLocations["Ottos263"] = { pos = vec3(594.05,-198.28,54.52), heading = 180.89, permission = "Mechanic"}
	bennysLocations["Ottos264"] = { pos = vec3(586.12,-198.68,54.52), heading = 179.11, permission = "Mechanic"}
	bennysLocations["Ottos265"] = { pos = vec3(578.28,-198.52,54.52), heading = 179.96, permission = "Mechanic"}
	bennysLocations["Ottos266"] = { pos = vec3(595.65,-146.48,54.52), heading = 0.05, permission = "Mechanic"}
	bennysLocations["Ottos267"] = { pos = vec3(603.61,-147.32,54.52), heading = 354.69, permission = "Mechanic"}
	bennysLocations["Ottos268"] = { pos = vec3(571.47,-147.70,54.52), heading = 0.46, permission = "Mechanic"}
	bennysLocations["Ottos269"] = { pos = vec3(579.37,-146.30,54.52), heading = 0.42, permission = "Mechanic"}
	bennysLocations["Ottos270"] = { pos = vec3(571.41,-147.57,54.52), heading = 358.18, permission = "Mechanic"}
	bennysLocations["Ottos271"] = { pos = vec3(614.52,-213.45,55.27), heading = 271.41, permission = "Mechanic"}
	bennysLocations["Ottos272"] = { pos = vec3(587.62,-146.25,54.52), heading = 1.08, permission = "Mechanic"}
	bennysLocations["Ottos273"] = { pos = vec3(610.24,-138.08,54.53), heading = 88.04, permission = "Mechanic"}

elseif cityName == "Fronteira" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.5,-2054.25,13.41), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.2,-2060.91,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.67,-2067.42,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.16,-2073.81,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.76,-2080.5,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.31,-2104.33,13.36), heading = 141.74, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.61,-2107.25,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.07,-2110.6,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.42,-2116.29,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.01,-2119.64,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.36,-2125.29,13.36), heading = 130.4, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.26,-2128.45,13.36), heading = 121.89, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.08,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.41,-2134.99,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.61,-2131.29,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.41,-2123.82,13.26), heading = 232.45, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.63,-2120.17,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.24,-2112.72,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.48,-2109.01,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos250"] = { pos = vec3(-1170.3,-2204.95,15.05), heading = 331.66, permission = "Mechanic"}
	bennysLocations["Ottos251"] = { pos = vec3(-1187.28,-2176.68,13.19), heading = 266.46, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}

elseif cityName == "Galaxy" then

	bennysLocations["Ottos401"] = {pos = vec3(810.53,-980.74,26.77),heading = 277.8,permission = "Mechanic"}
	bennysLocations["Ottos402"] = {pos = vec3(810.48,-968.36,26.77),heading = 269.3,permission = "Mechanic"}
	bennysLocations["Ottos403"] = {pos = vec3(810.37,-956.65,26.77),heading = 266.46,permission = "Mechanic"}
	bennysLocations["Ottos404"] = {pos = vec3(836.27,-959.59,26.49),heading = 274.97,permission = "Mechanic"}
	bennysLocations["Ottos405"] = {pos = vec3(836.18,-968.34,26.49),heading = 269.3,permission = "Mechanic"}
	bennysLocations["Ottos406"] = {pos = vec3(835.53,-976.99,26.64),heading = 274.97,permission = "Mechanic"}
	bennysLocations["Ottos407"] = {pos = vec3(835.28,-985.62,26.64),heading = 269.3,permission = "Mechanic"}
	bennysLocations["Ottos408"] = {pos = vec3(818.54,-947.31,22.09),heading = 201.26,permission = "Mechanic"}
	bennysLocations["Ottos409"] = {pos = vec3(1703.33,3270.0,41.15),heading = 201.26,permission = "Mechanic"}

elseif cityName == "Universo" then

	bennysLocations["Ottos523"] = { pos = vec3(445.66,-3377.06,3.36), heading = 23.05, permission = "Mechanic"}
	bennysLocations["Ottos524"] = { pos = vec3(-1171.07,-2204.85,15.04), heading = 318.93, permission = "Mechanic"}
	bennysLocations["Ottos525"] = { pos = vec3(-1126.01,-2060.12,13.26), heading = 219.53, permission = "Mechanic"}
	bennysLocations["Ottos526"] = { pos = vec3(-1132.10,-2067.10,13.26), heading = 221.21, permission = "Mechanic"}
	bennysLocations["Ottos527"] = { pos = vec3(-1138.70,-2073.36,13.26), heading = 222.66, permission = "Mechanic"}
	bennysLocations["Ottos528"] = { pos = vec3(-1145.48,-2079.98,13.26), heading = 221.65, permission = "Mechanic"}
	bennysLocations["Ottos529"] = { pos = vec3(-1151.86,-2110.53,13.36), heading = 315.03, permission = "Mechanic"}
	bennysLocations["Ottos530"] = { pos = vec3(-1143.00,-2119.73,13.36), heading = 316.06, permission = "Mechanic"}
	bennysLocations["Ottos531"] = { pos = vec3(-1134.23,-2128.56,13.36), heading = 311.46, permission = "Mechanic"}
	bennysLocations["Ottos532"] = { pos = vec3(-1113.06,-2143.28,13.29), heading = 48.89, permission = "Mechanic"}
	bennysLocations["Ottos533"] = { pos = vec3(-1109.60,-2138.97,13.29), heading = 47.89, permission = "Mechanic"}
	bennysLocations["Ottos534"] = { pos = vec3(-1106.16,-2135.09,13.26), heading = 42.54, permission = "Mechanic"}
	bennysLocations["Ottos535"] = { pos = vec3(-1102.15,-2131.72,13.26), heading = 39.98, permission = "Mechanic"}
	bennysLocations["Ottos536"] = { pos = vec3(-1098.38,-2127.76,13.29), heading = 39.52, permission = "Mechanic"}
	bennysLocations["Ottos537"] = { pos = vec3(-1094.81,-2124.16,13.26), heading = 45.17, permission = "Mechanic"}
	bennysLocations["Ottos538"] = { pos = vec3(-1091.21,-2120.39,13.26), heading = 41.43, permission = "Mechanic"}
	bennysLocations["Ottos539"] = { pos = vec3(-1171.66,-2168.34,13.20), heading = 143.74, permission = "Mechanic"}
	bennysLocations["Ottos540"] = { pos = vec3(-1189.65,-2194.55,13.20), heading = 148.65, permission = "Mechanic"}
	bennysLocations["Ottos541"] = { pos = vec3(-1154.81,-2106.58,13.36), heading = 312.46, permission = "Mechanic"}
	bennysLocations["Ottos542"] = { pos = vec3(-1157.63,-2103.68,13.36), heading = 321.40, permission = "Mechanic"}
	bennysLocations["Ottos543"] = { pos = vec3(-1148.17,-2112.95,13.36), heading = 312.70, permission = "Mechanic"}
	bennysLocations["Ottos544"] = { pos = vec3(-1145.61,-2115.49,13.36), heading = 320.46, permission = "Mechanic"}
	bennysLocations["Ottos545"] = { pos = vec3(-1139.31,-2121.87,13.36), heading = 313.02, permission = "Mechanic"}
	bennysLocations["Ottos546"] = { pos = vec3(-1136.49,-2124.79,13.36), heading = 312.23, permission = "Mechanic"}
	bennysLocations["Ottos547"] = { pos = vec3(-1133.25,-2128.05,13.36), heading = 314.20, permission = "Mechanic"}
	bennysLocations["Ottos548"] = { pos = vec3(-1130.67,-2130.88,13.36), heading = 310.38, permission = "Mechanic"}
	bennysLocations["Ottos549"] = { pos = vec3(-1127.78,-2133.53,13.36), heading = 307.26, permission = "Mechanic"}
	bennysLocations["Ottos550"] = { pos = vec3(-1119.78,-2053.18,13.26), heading = 221.86, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}


elseif cityName == "Alexandria" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.5,-2054.25,13.41), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.2,-2060.91,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.67,-2067.42,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.16,-2073.81,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.76,-2080.5,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.31,-2104.33,13.36), heading = 141.74, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.61,-2107.25,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.07,-2110.6,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.42,-2116.29,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.01,-2119.64,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.36,-2125.29,13.36), heading = 130.4, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.26,-2128.45,13.36), heading = 121.89, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.08,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.41,-2134.99,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.61,-2131.29,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.41,-2123.82,13.26), heading = 232.45, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.63,-2120.17,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.24,-2112.72,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.48,-2109.01,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos250"] = { pos = vec3(-1170.3,-2204.95,15.05), heading = 331.66, permission = "Mechanic"}
	bennysLocations["Ottos251"] = { pos = vec3(-1187.28,-2176.68,13.19), heading = 266.46, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1169.21,-2204.25,15.04), heading = 348.74, permission = "Mechanic"}

elseif cityName == "Maresia" then

	bennysLocations["Ottos227"] = { pos = vec3(527.74,-3184.1,0.66), heading = 0.0, permission = "Mechanic"}
	bennysLocations["Ottos228"] = { pos = vec3(-1118.5,-2054.25,13.41), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos229"] = { pos = vec3(-1125.2,-2060.91,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos230"] = { pos = vec3(-1131.67,-2067.42,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos231"] = { pos = vec3(-1138.16,-2073.81,13.4), heading = 51.03, permission = "Mechanic"}
	bennysLocations["Ottos232"] = { pos = vec3(-1144.76,-2080.5,13.4), heading = 45.36, permission = "Mechanic"}
	bennysLocations["Ottos233"] = { pos = vec3(-1158.31,-2104.33,13.36), heading = 141.74, permission = "Mechanic"}
	bennysLocations["Ottos234"] = { pos = vec3(-1155.61,-2107.25,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos235"] = { pos = vec3(-1152.07,-2110.6,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos237"] = { pos = vec3(-1146.42,-2116.29,13.36), heading = 136.07, permission = "Mechanic"}
	bennysLocations["Ottos238"] = { pos = vec3(-1143.01,-2119.64,13.36), heading = 138.9, permission = "Mechanic"}
	bennysLocations["Ottos240"] = { pos = vec3(-1137.36,-2125.29,13.36), heading = 130.4, permission = "Mechanic"}
	bennysLocations["Ottos241"] = { pos = vec3(-1134.26,-2128.45,13.36), heading = 121.89, permission = "Mechanic"}
	bennysLocations["Ottos243"] = { pos = vec3(-1128.56,-2134.08,13.36), heading = 133.23, permission = "Mechanic"}
	bennysLocations["Ottos244"] = { pos = vec3(-1106.41,-2134.99,13.26), heading = 226.78, permission = "Mechanic"}
	bennysLocations["Ottos245"] = { pos = vec3(-1102.61,-2131.29,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos246"] = { pos = vec3(-1095.41,-2123.82,13.26), heading = 232.45, permission = "Mechanic"}
	bennysLocations["Ottos247"] = { pos = vec3(-1091.63,-2120.17,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos248"] = { pos = vec3(-1084.24,-2112.72,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos249"] = { pos = vec3(-1080.48,-2109.01,13.26), heading = 229.61, permission = "Mechanic"}
	bennysLocations["Ottos250"] = { pos = vec3(-1170.3,-2204.95,15.05), heading = 331.66, permission = "Mechanic"}
	bennysLocations["Ottos251"] = { pos = vec3(-1187.28,-2176.68,13.19), heading = 266.46, permission = "Mechanic"}
	bennysLocations["Ottos252"] = { pos = vec3(-1131.38,-2131.23,12.75), heading = 134.35, permission = "Mechanic"}
	bennysLocations["Ottos253"] = { pos = vec3(-1140.07,-2122.18,12.75), heading = 135.31, permission = "Mechanic"}
	bennysLocations["Ottos254"] = { pos = vec3(-1149.24,-2113.38,12.75), heading = 134.05, permission = "Mechanic"}


end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local function saveVehicle()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local vehicle = GetVehiclePedIsUsing(Ped)
		local vehicleMods = {
			neon = {},
			colors = {},
			extracolors = {},
			dashColour = -1,
			interColour = -1,
			lights = {},
			tint = GetVehicleWindowTint(vehicle),
			wheeltype = GetVehicleWheelType(vehicle),
			platestyle = GetVehicleNumberPlateTextIndex(vehicle),
			mods = {},
			var = {},
			smokecolor = {},
			xenonColor = -1,
			liverys = 24,
			extras = {},
			plateIndex = 0
		}

		vehicleMods["xenonColor"] = GetCurrentXenonColour()
		vehicleMods["lights"][1],vehicleMods["lights"][2],vehicleMods["lights"][3] = GetVehicleNeonLightsColour(vehicle)
		vehicleMods["colors"][1],vehicleMods["colors"][2] = GetVehicleColours(vehicle)
		vehicleMods["extracolors"][1],vehicleMods["extracolors"][2] = GetVehicleExtraColours(vehicle)
		vehicleMods["smokecolor"][1],vehicleMods["smokecolor"][2],vehicleMods["smokecolor"][3] = GetVehicleTyreSmokeColor(vehicle)
		vehicleMods["dashColour"] = GetVehicleDashboardColour(vehicle)
		vehicleMods["interColour"] = GetVehicleInteriorColour(vehicle)
		vehicleMods["liverys"] = GetVehicleLivery(vehicle)
		vehicleMods["plateIndex"] = GetVehicleNumberPlateTextIndex(vehicle)

		for i = 0,3 do
			vehicleMods["neon"][i] = IsVehicleNeonLightEnabled(vehicle,i)
		end

		for i = 0,16 do
			vehicleMods["mods"][i] = GetVehicleMod(vehicle,i)
		end

		for i = 17,22 do
			vehicleMods["mods"][i] = IsToggleModOn(vehicle,i)
		end

		for i = 23,48 do
			vehicleMods["mods"][i] = GetVehicleMod(vehicle,i)

			if i == 24 or i == 23 then
				vehicleMods["var"][i] = GetVehicleModVariation(vehicle,i)
			end
		end

		for i = 1,12 do
			local ison = IsVehicleExtraTurnedOn(vehicle,i)
			if 1 == tonumber(ison) then
				vehicleMods["extras"][i] = 1
			else
				vehicleMods["extras"][i] = 0
			end
		end

		if presetMode then
			TriggerEvent("garages:saveVehedit2Preset",vRP.VehicleName(),vehicleMods)
		else
			TriggerServerEvent("lscustoms:updateVehicle",vehicleMods,GetVehicleNumberPlateText(vehicle),vRP.VehicleName())
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ATTEMPTPURCHASE
-----------------------------------------------------------------------------------------------------------------------------------------
function AttemptPurchase(type,upgradeLevel)
	if upgradeLevel ~= nil then
		upgradeLevel = upgradeLevel + 2
	end

	TriggerServerEvent("lscustoms:attemptPurchase",type,upgradeLevel)

	attemptingPurchase = true

	while attemptingPurchase do
		Wait(1)
	end

	if not isPurchaseSuccessful then
		PlaySoundFrontend(-1,"ERROR","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
	end

	return isPurchaseSuccessful
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentMod(id)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local mod = GetVehicleMod(vehicle,id)
	local modName = GetLabelText(GetModTextLabel(vehicle,id,mod))

	return mod,modName
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentWheel()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local wheel = GetVehicleMod(vehicle,23)
	local wheelName = GetLabelText(GetModTextLabel(vehicle,23,wheel))
	local wheelType = GetVehicleWheelType(vehicle)

	return wheel,wheelName,wheelType
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTCHUSTOMWHEELSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentCustomWheelState()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local state = GetVehicleModVariation(vehicle,23)

	if state then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETORIGINALWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function GetOriginalWheel()
	return originalWheel
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETORIGINALCUSTOMWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function GetOriginalCustomWheel()
	return originalCustomWheels
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentWindowTint()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	return GetVehicleWindowTint(vehicle)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTVEHICLEWHEELSMOKECLOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentVehicleWheelSmokeColour()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local r,g,b = GetVehicleTyreSmokeColor(vehicle)

	return r,g,b
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTNEONSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentNeonState(id)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local isEnabled = IsVehicleNeonLightEnabled(vehicle,id)

	if isEnabled then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTNEONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentNeonColour()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local r,g,b = GetVehicleNeonLightsColour(vehicle)

	return r,g,b
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTXENONSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentXenonState()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local isEnabled = IsToggleModOn(vehicle,22)

	if isEnabled then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentXenonColour()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	return GetVehicleHeadlightsColour(vehicle)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTTURBOSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentTurboState()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local isEnabled = IsToggleModOn(vehicle,18)

	if isEnabled then
		return 1
	else
		return 0
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCURRENTEXTRASTATE
-----------------------------------------------------------------------------------------------------------------------------------------
function GetCurrentExtraState(extra)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	return IsVehicleExtraTurnedOn(vehicle,extra)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKVALIDMODS
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckValidMods(category,id,wheelType)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local tempMod = GetVehicleMod(vehicle,id)
	local tempWheel = GetVehicleMod(vehicle,23)
	local tempWheelType = GetVehicleWheelType(vehicle)
	local tempWheelCustom = GetVehicleModVariation(vehicle,23)
	local amountValidMods = 0
	local validMods = {}
	local hornNames = {}

	if wheelType ~= nil then
		SetVehicleWheelType(vehicle,wheelType)
	end

	if id == 14 then
		for k,v in pairs(vehicleCustomisation) do 
			if vehicleCustomisation[k]["category"] == category then
				hornNames = vehicleCustomisation[k]["hornNames"]
				break
			end
		end
	end

	local modAmount = GetNumVehicleMods(vehicle,id)
	for i = 1,modAmount do
		local label = GetModTextLabel(vehicle,id,(i - 1))
		local modName = GetLabelText(label)

		if modName == "NULL" or modName == nil or modName == "" then
			if id == 14 then
				if i <= #hornNames then
					modName = hornNames[i]["name"]
				else
					modName = "Horn "..i
				end
			else
				modName = category.." "..i
			end
		end

		validMods[i] = { id = (i - 1), name = modName }

		amountValidMods = amountValidMods + 1
	end

	if modAmount > 0 then
		table.insert(validMods,1,{ id = -1, name = "Original" })
	end

	if wheelType ~= nil then
		SetVehicleWheelType(vehicle,tempWheelType)
		SetVehicleMod(vehicle,23,tempWheel,tempWheelCustom)
	end

	return validMods,amountValidMods
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalMod()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleMod(vehicle,originalCategory,originalMod)
	SetVehicleDoorsShut(vehicle,true)

	originalCategory = nil
	originalMod = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalWindowTint()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleWindowTint(vehicle,originalWindowTint)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALCOLOURS
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalColours()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleColours(vehicle,originalPrimaryColour,originalSecondaryColour)
	SetVehicleExtraColours(vehicle,originalPearlescentColour,originalWheelColour)
	SetVehicleDashboardColour(vehicle,originalDashColour)
	SetVehicleInteriorColour(vehicle,originalInterColour)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALWHEELS
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalWheels()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local doesHaveCustomWheels = GetVehicleModVariation(vehicle,23)

	SetVehicleWheelType(vehicle,originalWheelType)

	if originalWheelCategory ~= nil then
		SetVehicleMod(vehicle,originalWheelCategory,originalWheel,originalCustomWheels)
		
		if GetVehicleClass(vehicle) == 8 then
			SetVehicleMod(vehicle,24,originalWheel,originalCustomWheels)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALNEONSTATES
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalNeonStates()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleNeonLightEnabled(vehicle,originalNeonLightSide,originalNeonLightState)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALNEONCOLOURS
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalNeonColours()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleNeonLightsColour(vehicle,originalNeonColourR,originalNeonColourG,originalNeonColourB)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREORIGINALXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function RestoreOriginalXenonColour()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleHeadlightsColour(vehicle,originalXenonColour)
	SetVehicleLights(vehicle,0)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREPOLICELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function RestorePoliceLivery()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleLivery(vehicle,originalPoliceLivery)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESTOREPLATEINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function RestorePlateIndex()
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleNumberPlateTextIndex(vehicle,originalPlateIndex)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewMod(categoryID,modID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if not originalMod and not originalCategory then
		originalCategory = categoryID
		originalMod = GetVehicleMod(vehicle,categoryID)
	end

	if categoryID == 39 or categoryID == 40 or categoryID == 41 then
		SetVehicleDoorOpen(vehicle,4,false,true)
	elseif categoryID == 37 or categoryID == 38 then
		SetVehicleDoorOpen(vehicle,5,false,true)
	end

	SetVehicleMod(vehicle,categoryID,modID)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewWindowTint(windowTintID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleWindowTint(vehicle,windowTintID)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewColour(paintType,paintCategory,paintID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	SetVehicleModKit(vehicle,0)

	if not originalDashColour and not originalInterColour and not originalPrimaryColour and not originalSecondaryColour and not originalPearlescentColour and not originalWheelColour then
		originalPrimaryColour,originalSecondaryColour = GetVehicleColours(vehicle)
		originalPearlescentColour,originalWheelColour = GetVehicleExtraColours(vehicle)
		originalDashColour = GetVehicleDashboardColour(vehicle)
		originalInterColour = GetVehicleInteriorColour(vehicle)
	end

	if paintType == 0 then
		if paintCategory == 1 then
			SetVehicleColours(vehicle,paintID,originalSecondaryColour)
			SetVehicleExtraColours(vehicle,originalPearlescentColour,originalWheelColour)
		else
			SetVehicleColours(vehicle,paintID,originalSecondaryColour)
		end
	elseif paintType == 1 then
		SetVehicleColours(vehicle,originalPrimaryColour,paintID)
	elseif paintType == 2 then
		SetVehicleExtraColours(vehicle,paintID,originalWheelColour)
	elseif paintType == 3 then
		SetVehicleExtraColours(vehicle,originalPearlescentColour,paintID)
	elseif paintType == 4 then
		SetVehicleDashboardColour(vehicle,paintID)
	elseif paintType == 5 then
		SetVehicleInteriorColour(vehicle,paintID)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewWheel(categoryID,wheelID,wheelType)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local doesHaveCustomWheels = GetVehicleModVariation(vehicle,23)

	if not originalWheelCategory and not originalWheel and not originalWheelType and not originalCustomWheels then
		originalWheelCategory = categoryID
		originalWheelType = GetVehicleWheelType(vehicle)
		originalWheel = GetVehicleMod(vehicle,23)
		originalCustomWheels = GetVehicleModVariation(vehicle,23)
	end

	SetVehicleWheelType(vehicle,wheelType)
	SetVehicleMod(vehicle,categoryID,wheelID,doesHaveCustomWheels)

	if GetVehicleClass(vehicle) == 8 then
		SetVehicleMod(vehicle,24,wheelID,doesHaveCustomWheels)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWNEON
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewNeon(side,enabled)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if not originalNeonLightState and not originalNeonLightSide then
		if IsVehicleNeonLightEnabled(vehicle,side) then
			originalNeonLightState = 1
		else
			originalNeonLightState = 0
		end

		originalNeonLightSide = side
	end

	SetVehicleNeonLightEnabled(vehicle,side,enabled)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWNEONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewNeonColour(r,g,b)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if not originalNeonColourR and not originalNeonColourG and not originalNeonColourB then
		originalNeonColourR,originalNeonColourG,originalNeonColourB = GetVehicleNeonLightsColour(vehicle)
	end

	SetVehicleNeonLightsColour(vehicle,r,g,b)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewXenonColour(colour)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if not originalXenonColour then
		originalXenonColour = GetVehicleHeadlightsColour(vehicle)
	end

	SetVehicleLights(vehicle,2)
	SetVehicleHeadlightsColour(vehicle,colour)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWPOLICELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewPoliceLivery(liv)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleLivery(vehicle,tonumber(liv))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREVIEWPLATEINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function PreviewPlateIndex(index)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleNumberPlateTextIndex(vehicle,tonumber(index))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYMOD
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyMod(categoryID,modID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	if categoryID == 18 then
		ToggleVehicleMod(vehicle,categoryID,modID)
	elseif categoryID == 11 or categoryID == 12 or categoryID== 13 or categoryID == 15 or categoryID == 16 then
		originalCategory = categoryID
		originalMod = modID

		SetVehicleMod(vehicle,categoryID,modID)
	else
		originalCategory = categoryID
		originalMod = modID

		SetVehicleMod(vehicle,categoryID,modID)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYEXTRA
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyExtra(extraID)
	local Ped = PlayerPedId()
	local Vehicle = GetVehiclePedIsUsing(Ped)

	local engine = GetVehicleEngineHealth(Vehicle)
	local body = GetVehicleBodyHealth(Vehicle)
	local health = GetEntityHealth(Vehicle)
	local vehWindows = {}
	local vehTyres = {}
	local vehDoors = {}

	for i = 0,7 do
		local Status = false

		if GetTyreHealth(Vehicle,i) ~= 1000.0 then
			Status = true
		end

		vehTyres[i] = Status
	end

	for i = 0,5 do
		vehDoors[i] = IsVehicleDoorDamaged(Vehicle,i)
	end

	for i = 0,5 do
		vehWindows[i] = IsVehicleWindowIntact(Vehicle,i)
	end

	local isEnabled = IsVehicleExtraTurnedOn(Vehicle,extraID)
	if isEnabled == 1 then
		SetVehicleExtra(Vehicle,tonumber(extraID),1)
		SetVehiclePetrolTankHealth(Vehicle,4000.0)
	else
		SetVehicleExtra(Vehicle,tonumber(extraID),0)
		SetVehiclePetrolTankHealth(Vehicle,4000.0)
	end

	SetVehicleEngineHealth(Vehicle,engine)
	SetVehicleBodyHealth(Vehicle,body)
	SetEntityHealth(Vehicle,health)

	for Tyre,Burst in pairs(vehTyres) do
		if Burst then
			SetVehicleTyreBurst(Vehicle,Tyre,true,1000.0)
		end
	end

	for k,v in pairs(vehWindows) do
		if not v then
			SmashVehicleWindow(Vehicle,k)
		end
	end

	for k,v in pairs(vehDoors) do
		if v then
			SetVehicleDoorBroken(Vehicle,k,v)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYWINDOWTINT
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyWindowTint(windowTintID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalWindowTint = windowTintID

	SetVehicleWindowTint(vehicle,windowTintID)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyColour(paintType,paintCategory,paintID)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local vehPrimaryColour,vehSecondaryColour = GetVehicleColours(vehicle)
	local vehPearlescentColour,vehWheelColour = GetVehicleExtraColours(vehicle)

	if paintType == 0 then
		if paintCategory == 1 then
			SetVehicleColours(vehicle,paintID,vehSecondaryColour)
			SetVehicleExtraColours(vehicle,originalPearlescentColour,vehWheelColour)
			originalPrimaryColour = paintID
		else
			SetVehicleColours(vehicle,paintID,vehSecondaryColour)
			originalPrimaryColour = paintID
		end
	elseif paintType == 1 then
		SetVehicleColours(vehicle,vehPrimaryColour,paintID)
		originalSecondaryColour = paintID
	elseif paintType == 2 then
		SetVehicleExtraColours(vehicle,paintID,vehWheelColour)
		originalPearlescentColour = paintID
	elseif paintType == 3 then
		SetVehicleExtraColours(vehicle,vehPearlescentColour,paintID)
		originalWheelColour = paintID
	elseif paintType == 4 then
		SetVehicleDashboardColour(vehicle,paintID)
		originalDashColour = paintID
	elseif paintType == 5 then
		SetVehicleInteriorColour(vehicle,paintID)
		originalInterColour = paintID
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyWheel(categoryID,wheelID,wheelType)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local doesHaveCustomWheels = GetVehicleModVariation(vehicle,23)

	originalWheelCategory = categoryID
	originalWheel = wheelID
	originalWheelType = wheelType

	SetVehicleWheelType(vehicle,wheelType)
	SetVehicleMod(vehicle,categoryID,wheelID,doesHaveCustomWheels)
	
	if GetVehicleClass(vehicle) == 8 then
		SetVehicleMod(vehicle,24,wheelID,doesHaveCustomWheels)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYCUSTOMWHEEL
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyCustomWheel(state)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	SetVehicleMod(vehicle,23,GetVehicleMod(vehicle,23),state)

	if GetVehicleClass(vehicle) == 8 then
		SetVehicleMod(vehicle,24,GetVehicleMod(vehicle,24),state)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYNEON
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyNeon(side,enabled)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalNeonLightState = enabled
	originalNeonLightSide = side

	SetVehicleNeonLightEnabled(vehicle,side,enabled)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYNEONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyNeonColour(r,g,b)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalNeonColourR = r
	originalNeonColourG = g
	originalNeonColourB = b

	SetVehicleNeonLightsColour(vehicle,r,g,b)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYXENONLIGHTS
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyXenonLights(category,state)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	ToggleVehicleMod(vehicle,category,state)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYXENONCOLOUR
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyXenonColour(colour)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalXenonColour = colour

	SetVehicleHeadlightsColour(vehicle,colour)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYPOLICELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyPoliceLivery(liv)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalPoliceLivery = liv

	SetVehicleLivery(vehicle,liv)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYPLATEINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyPlateIndex(index)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	originalPlateIndex = index

	SetVehicleNumberPlateTextIndex(vehicle,index)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYTYRESMOKE
-----------------------------------------------------------------------------------------------------------------------------------------
function ApplyTyreSmoke(r,g,b)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)

	ToggleVehicleMod(vehicle,20,true)
	SetVehicleTyreSmokeColor(vehicle,r,g,b)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXITBENNYS
-----------------------------------------------------------------------------------------------------------------------------------------
function ExitBennys()
	local Ped = PlayerPedId()
	if IsPedInAnyVehicle(Ped) then
		local vehicle = GetVehiclePedIsUsing(Ped)
		if GetPedInVehicleSeat(vehicle,-1) == Ped then
			FreezeEntityPosition(vehicle,false)
			saveVehicle()
		end
	end

	presetMode = false

	TriggerServerEvent("lscustoms:inVehicle",nil)
	TriggerEvent("player:inBennys",false)
	DisplayMenuContainer(false)
	activeBennys = false
    TriggerEvent("help:open")
	DestroyMenus()
    LocalPlayer["state"]["Bennys"] = false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISABLECONTROLS
-----------------------------------------------------------------------------------------------------------------------------------------
function disableControls()
	activeBennys = true

	CreateThread(function()
		while activeBennys do
			DisableControlAction(1,38,true)
			DisableControlAction(1,172,true)
			DisableControlAction(1,173,true)
			DisableControlAction(1,177,true)
			DisableControlAction(1,176,true)
			DisableControlAction(1,71,true)
			DisableControlAction(1,72,true)
			DisableControlAction(1,34,true)
			DisableControlAction(1,35,true)
			DisableControlAction(1,75,true)
			
			if IsDisabledControlJustReleased(1,172) then
				MenuScrollFunctionality("up")
				PlaySoundFrontend(-1,"NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end
			
			if IsDisabledControlJustReleased(1,173) then
				MenuScrollFunctionality("down")
				PlaySoundFrontend(-1,"NAV_UP_DOWN","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end
			
			if IsDisabledControlJustReleased(1,176) then
				MenuManager(true)
				PlaySoundFrontend(-1,"OK","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end
			
			if IsDisabledControlJustReleased(1,177) then
				MenuManager(false)
				PlaySoundFrontend(-1,"NO","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
			end

			Wait(0)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURCHASESUCCESFUL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("lscustoms:purchaseSuccessful")
AddEventHandler("lscustoms:purchaseSuccessful",function()
	isPurchaseSuccessful = true
	attemptingPurchase = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURCHASEFAILED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("lscustoms:purchaseFailed")
AddEventHandler("lscustoms:purchaseFailed",function()
	isPurchaseSuccessful = false
	attemptingPurchase = false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PURCHASEFAILED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("lscustoms:openMenu")
AddEventHandler("lscustoms:openMenu",function(isPreset)
    local Ped = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(Ped)

    if isPreset and (not IsPedInAnyVehicle(Ped) or GetPedInVehicleSeat(vehicle,-1) ~= Ped) then
        return
    end

    presetMode = isPreset and true or false
    LocalPlayer["state"]["Bennys"] = true
    local Coords = GetEntityCoords(Ped)
    local Heading = GetEntityHeading(Ped)

    SetVehicleModKit(vehicle,0)
    SetEntityCoords(vehicle,Coords)
    SetEntityHeading(vehicle,Heading)
    SetVehicleDirtLevel(vehicle,0.0)
    FreezeEntityPosition(vehicle,true)
    SetVehicleOnGroundProperly(vehicle)

    originalCategory = nil
    originalMod = nil
    originalPrimaryColour = nil
    originalSecondaryColour = nil
    originalPearlescentColour = nil
    originalWheelColour = nil
    originalDashColour = nil
    originalInterColour = nil
    originalWindowTint = GetVehicleWindowTint(vehicle)
    originalWheelCategory = nil
    originalWheel = nil
    originalWheelType = nil
    originalCustomWheels = nil
    originalNeonLightState = nil
    originalNeonLightSide = nil
    originalNeonColourR = nil
    originalNeonColourG = nil
    originalNeonColourB = nil
    originalXenonColour = nil
    originalPoliceLivery = nil
    originalPlateIndex = nil

    InitiateMenus(isMotorcycle)

    DisplayMenuContainer(true)
    DisplayMenu(true,"mainMenu")
    TriggerEvent("player:inBennys",true)
    PlaySoundFrontend(-1,"OK","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
    TriggerServerEvent("lscustoms:inVehicle",VehToNet(vehicle),GetVehicleNumberPlateText(vehicle))
   
    disableControls()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOPEN
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		if LocalPlayer["state"]["Route"] < 900000 then
			if not activeBennys then
				local Ped = PlayerPedId()
				if IsPedInAnyVehicle(Ped) then
					local Coords = GetEntityCoords(Ped)
					local vehicle = GetVehiclePedIsUsing(Ped)
					if GetPedInVehicleSeat(vehicle,-1) == Ped then
						for k,v in pairs(bennysLocations) do
							local Distance = #(Coords - v["pos"])

							if Distance <= 2.0 then
								TimeDistance = 1
								DrawMarker(23,v["pos"][1],v["pos"][2],v["pos"][3] - 0.35,0.0,0.0,0.0,0.0,0.0,0.0,5.0,5.0,0.0,255,10,0,100,0,0,0,0)

								if IsControlJustPressed(1,38) and not exports["hud"]:Wanted() and vSERVER.checkPermission(v["permission"]) then
									local isMotorcycle = false
                                    -- if not VehicleVip(GetSpawnFromHash(GetEntityModel(vehicle))) then
                                    --     TriggerEvent("Notify","vermelho","Este veículo não está disponível para customização.",8000,"Mecanica")
                                    --     goto skipBennys
                                    -- end
                                    LocalPlayer["state"]["Bennys"] = true

									if v["bikes"] then
										if GetVehicleClass(vehicle) == 8 then
											isMotorcycle = true
										else
											goto skipBennys
										end
									else
										if GetVehicleClass(vehicle) == 8 then
											isMotorcycle = true
										else
											isMotorcycle = false
										end
									end

									SetVehicleModKit(vehicle,0)
									SetEntityCoords(vehicle,v["pos"])
									SetEntityHeading(vehicle,v["heading"])
									FreezeEntityPosition(vehicle,true)
									SetVehicleOnGroundProperly(vehicle)

									originalCategory = nil
									originalMod = nil
									originalPrimaryColour = nil
									originalSecondaryColour = nil
									originalPearlescentColour = nil
									originalWheelColour = nil
									originalDashColour = nil
									originalInterColour = nil
									originalWindowTint = GetVehicleWindowTint(vehicle)
									originalWheelCategory = nil
									originalWheel = nil
									originalWheelType = nil
									originalCustomWheels = nil
									originalNeonLightState = nil
									originalNeonLightSide = nil
									originalNeonColourR = nil
									originalNeonColourG = nil
									originalNeonColourB = nil
									originalXenonColour = nil
									originalPoliceLivery = nil
									originalPlateIndex = nil

									InitiateMenus(isMotorcycle)

									DisplayMenuContainer(true)
									DisplayMenu(true,"mainMenu")
									TriggerEvent("player:inBennys",true)
									PlaySoundFrontend(-1,"OK","HUD_FRONTEND_DEFAULT_SOUNDSET",1)
									TriggerServerEvent("lscustoms:inVehicle",VehToNet(vehicle),GetVehicleNumberPlateText(vehicle))

									disableControls()

									::skipBennys::
								end
							end
						end
					end
				end
			end
		end

		Wait(TimeDistance)
	end
end)


RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)
