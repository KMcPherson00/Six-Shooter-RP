local QBCore = exports['qbr-core']:GetCoreObject()
local DoorInfo	= {}

RegisterServerEvent('qbr-doorlock:updatedoorsv')
AddEventHandler('qbr-doorlock:updatedoorsv', function(source, doorID, state, cb)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if not IsAuthorized(Player.PlayerData.job.name, Config.DoorList[doorID]) then
			TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1You do not have a key!^0")
            return
        else 
            TriggerClientEvent('qbr-doorlock:changedoor', src, doorID, state)
        end
end)

RegisterServerEvent('qbr-doorlock:updateState')
AddEventHandler('qbr-doorlock:updateState', function(doorID, state, cb)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if type(doorID) ~= 'number' then
			return
		end
		if not IsAuthorized(Player.PlayerData.job.name, Config.DoorList[doorID]) then
			return
		end
		DoorInfo[doorID] = {}
		TriggerClientEvent('qbr-doorlock:setState', -1, doorID, state)
end)

function IsAuthorized(jobName, doorID)
	for _,job in pairs(doorID.authorizedJobs) do
		if job == jobName then
			return true
		end
	end
	return false
end
