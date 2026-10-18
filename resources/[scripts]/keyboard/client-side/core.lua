-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("keyboard",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Status = ""
local Progress = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUCESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("success",function(Data,Callback)
	SetNuiFocus(false,false)
	Status = Data["data"]
	Progress = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FAILURE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("failure",function(Data,Callback)
	SetNuiFocus(false,false)
	Status = "undefined"
	Progress = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYBOARD
-----------------------------------------------------------------------------------------------------------------------------------------
function Keyboard(Data)
	if Progress then return end

	Progress = true
	Wait(100)
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "OPEN_MENU", data = Data })

	while Progress do
		Wait(0)
	end

	if Status ~= "undefined" then
		return Status
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYBOARD
-----------------------------------------------------------------------------------------------------------------------------------------
function KeyboardFamily(Data)
	if Progress then return end

	Progress = true
	Wait(100)
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "OPEN_FAMILY", data = Data })

	while Progress do
		Wait(0)
	end

	if Status ~= "undefined" then
		return Status
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYBOARD
-----------------------------------------------------------------------------------------------------------------------------------------
function KeyboardInterCom(Data)
	if Progress then return end

	Progress = true
	Wait(100)
	SetNuiFocus(true,true)
	SendNUIMessage({ action = "OPEN_INTERCOM", data = Data })

	while Progress do
		Wait(0)
	end

	if Status ~= "undefined" then
		return Status
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYBOARD
-----------------------------------------------------------------------------------------------------------------------------------------
function KeyboardRobbery(Data)
    print("Robbery 3")
	if Progress then return end
    print("Robbery 4")
	Progress = true
	Wait(100)
	SetNuiFocus(true,true)
    print(json.encode(Data))
	SendNUIMessage({ action = "OPEN_ROBERRY", data = Data })

	while Progress do
		Wait(0)
	end

	if Status ~= "undefined" then
		return Status
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYBOARD
-----------------------------------------------------------------------------------------------------------------------------------------
function KeyboardList(Data)
	if Progress then return end

	Progress = true
	Wait(100)
	SetNuiFocus(true,true)
    print(json.encode(Data))
	SendNUIMessage({ action = "OPEN_LIST", title = "Familia", data = Data })

	while Progress do
		Wait(0)
	end

	if Status ~= "undefined" then
		return Status
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSWORD
-----------------------------------------------------------------------------------------------------------------------------------------
function Password(First)
	local Array = Keyboard({
		rows = {
			{
				id = 0,
				txt = First,
				copy = "undefined",
				area = "undefined",
				word = true
			}
		}
	})

	if Array then
		if not Array[1]["input"] then
			return false
		end

		return { Array[1]["input"] }
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ONESTEP
-----------------------------------------------------------------------------------------------------------------------------------------
function OneStep(First,Table)
    if not Table then
        Table = {}
    end
    local FirstC = Table[1] or "undefined"
	local Array = Keyboard({
		rows = {
			{
				id = 0,
				txt = First,
				copy = FirstC,
				area = "undefined",
				word = "undefined"
			}
		}
	})

	if Array then
		if not Array[1] or not Array[1]["input"] then
			return false
		end

		return { Array[1]["input"] }
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TWOSTEP
-----------------------------------------------------------------------------------------------------------------------------------------
function TwoStep(First,Second, Table)
	if not Table then
        Table = {}
    end
	local FirstC = Table[1] or "undefined"
    local SecondC = Table[2] or "undefined"
	local Array = Keyboard({
		rows = {
			{
				id = 0,
				txt = First,
				copy = Table[1],
				area = "undefined",
				word = "undefined"
			},{
				id = 1,
				txt = Second,
				copy = Table[2],
				area = "undefined",
				word = "undefined"
			}
		}
	})

	if Array then
		if not Array[1] or not Array[2] or not Array[1]["input"] or not Array[2]["input"] then
			return false
		end

		return { Array[1]["input"],Array[2]["input"] }
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREESTEP
-----------------------------------------------------------------------------------------------------------------------------------------
function ThreeStep(First,Second,Third,Table)
    if not Table then
        Table = {}
    end
    local FirstC = Table[1] or "undefined"
    local SecondC = Table[2] or "undefined"
    local ThirdC = Table[3] or "undefined"
	local Array = Keyboard({
		rows = {
			{
				id = 0,
				txt = First,
				copy = FirstC,
				area = "undefined",
				word = "undefined"
			},{
				id = 1,
				txt = Second,
				copy = SecondC,
				area = "undefined",
				word = "undefined"
			},{
				id = 2,
				txt = Third,
				copy = ThirdC,
				area = "undefined",
				word = "undefined"
			}
		}
	})

	if Array then
		if not Array[1] or not Array[2] or not Array[3] or not Array[1]["input"] or not Array[2]["input"] or not Array[3]["input"] then
			return false
		end

		return { Array[1]["input"],Array[2]["input"],Array[3]["input"] }
	end

	return false
end

function FamilyStep(...)
    if not Table then
        Table = {}
    end
    local NumberRows = select("#", ...)
    local Table = {
        rows = {}
    }
    for i=1, NumberRows do
        local Row = {
            id = i-1,
            txt = select(i, ...),
            copy = "undefined",
            area = "undefined",
            word = "undefined"
        }
        table.insert(Table.rows, Row)
    end
	local Array = KeyboardFamily(Table)
	if Array then
		return { Array[1]["input"] }
	end

	return false
end

function InterComStep(Table)
	local Array = KeyboardInterCom(Table)
	if Array then
        print(json.encode(Array))
		return { Array["input"] }
	end

	return false
end

function RobberyStep(Table)
	local Array = KeyboardRobbery(Table)
	if Array then
		return { Array["input"] }
	end
	return false
end

function List(...)
    if not Table then
        Table = {}
    end
    local NumberRows = select("#", ...)
    local Table = {
        columns = {}
    }
    for i=1, NumberRows do
        local Row = {
            id = i-1,
            txt = select(i, ...),
            copy = "undefined",
            area = "undefined",
            word = "undefined"
        }
        table.insert(Table.columns, Row)
    end
	local Array = KeyboardList(Table)
	if Array then
		return { Array }
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREEFOURTH
-----------------------------------------------------------------------------------------------------------------------------------------
function ThreeFourth(First,Second,Third,Fourth)
	local Array = Keyboard({
		rows = {
			{
				id = 0,
				txt = First,
				copy = "undefined",
				area = "undefined",
				word = "undefined"
			},{
				id = 1,
				txt = Second,
				copy = "undefined",
				area = "undefined",
				word = "undefined"
			},{
				id = 2,
				txt = Third,
				copy = "undefined",
				area = "undefined",
				word = "undefined"
			},{
				id = 3,
				txt = Fourth,
				copy = "undefined",
				area = true,
				word = "undefined"
			}
		}
	})

	if Array then
		if not Array[1] or not Array[2] or not Array[3] or not Array[4] or not Array[1]["input"] or not Array[2]["input"] or not Array[3]["input"] or not Array[4]["input"] then
			return false
		end

		return { Array[1]["input"],Array[2]["input"],Array[3]["input"],Array[4]["input"] }
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- COPYSTEP
-----------------------------------------------------------------------------------------------------------------------------------------
function CopyStep(First,Copy)
	local Array = Keyboard({
		rows = {
			{
				id = 0,
				txt = First,
				copy = Copy,
				area = "undefined",
				word = "undefined"
			}
		}
	})

	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- AREASTEP
-----------------------------------------------------------------------------------------------------------------------------------------
function AreaStep(First)
	local Array = Keyboard({
		rows = {
			{
				id = 0,
				txt = First,
				copy = "undefined",
				area = true,
				word = "undefined"
			}
		}
	})

	if Array then
		if not Array[1]["input"] then
			return false
		end

		return { Array[1]["input"] }
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYWORD
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyWord(First)
	return Password(First)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYSINGLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keySingle(First,Table)
	return OneStep(First,Table)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYDOUBLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyDouble(First,Second,Table)
	return TwoStep(First,Second,Table)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYTRIPLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyTriple(First,Second,Third,Table)
	return ThreeStep(First,Second,Third,Table)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYFOURTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyFourth(First,Second,Third,Fourth)
	return ThreeFourth(First,Second,Third,Fourth)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYFOURTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyFourth(First,Second,Third,Fourth)
	return ThreeFourth(First,Second,Third,Fourth)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYFOURTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyFamily(...)
	return FamilyStep(...)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYFOURTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyIterCom(Table)
	return InterComStep(Table)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYFOURTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyRobbery(Table)
    print("Robbery 1")
	return RobberyStep(Table)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYFOURTH
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.List(...)
	return List(...)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYAREA
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyArea(First)
	return AreaStep(First)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYCOPY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.keyCopy(First,Copy)
	return CopyStep(First,Copy)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXPORTS
-----------------------------------------------------------------------------------------------------------------------------------------
exports("keyCopy",CopyStep)
exports("keyArea",AreaStep)
exports("keyWord",Password)
exports("keySingle",OneStep)
exports("keyDouble",TwoStep)
exports("keyTriple",ThreeStep)
exports("keyFourth",ThreeFourth)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)