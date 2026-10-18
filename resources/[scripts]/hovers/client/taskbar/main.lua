local TaskbarClient = {}
Tunnel.bindInterface("inventory/taskbar",TaskbarClient)
Proxy.addInterface("inventory/taskbar",TaskbarClient)
local Status = ""
local Progress = false
local TaskCount = 0
local CAPTCHA_THRESHOLD = math.random(15, 35)

local VerificationFinished = false
local VerificationResult = false

RegisterNUICallback("verificationSuccess",function(Data,Callback)
    SetNuiFocus(false,false)
    VerificationResult = true
    VerificationFinished = true
    Callback("Ok")
end)

RegisterNUICallback("verificationFailure",function(Data,Callback)
    SetNuiFocus(false,false)
    VerificationResult = false
    VerificationFinished = true
    Callback("Ok")
end)

function checkVerification()
    TaskCount = TaskCount + 1
    if TaskCount >= CAPTCHA_THRESHOLD then
        TaskCount = 0
        CAPTCHA_THRESHOLD = math.random(15, 25)
        
        VerificationFinished = false
        VerificationResult = false
        
        SetNuiFocus(true,true)
        SendNUIMessage({ page = "verification", action = "open" })
        
        while not VerificationFinished do
            Wait(100)
        end
        
        return VerificationResult
    end
    return true
end

RegisterNUICallback("taskFailure",function(Data,Callback)
	if Progress == false then
		return
	end
	SetNuiFocus(false,false)
	Status = "failure"
	Progress = false

	Callback("Ok")
end)
RegisterNUICallback("taskSuccess",function(Data,Callback)
	if Progress == false then
		return
	end
	SetNuiFocus(false,false)
	Status = "success"
	Progress = false

	Callback("Ok")
end)
function taskBar(Timer)
	if Progress then return end

	Progress = true
	SetNuiFocus(true,false)
	SendNUIMessage({ page = "taskbar", action = "open", time = Timer })

	while Progress do
		Wait(0)
	end

	if Status == "success" then
		return true
	end

	return false
end
exports("Task",function(Amount,Speed)
	local Return = true

	for Number = 1,Amount do
		if not taskBar(Speed) then
			Return = false
			break
		end
	end

	return Return
end)
function TaskbarClient.Task(Amount,Speed)
	local Return = true

	for Number = 1,Amount do
		if not taskBar(Speed) then
			Return = false
			break
		end
	end

	return Return
end

