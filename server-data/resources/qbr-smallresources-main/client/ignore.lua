Citizen.CreateThread(function()
    while true do
        for _, sctyp in next, Config.BlacklistedScenarios['TYPES'] do
            SetScenarioTypeEnabled(sctyp, false)
        end
        for _, scgrp in next, Config.BlacklistedScenarios['GROUPS'] do
            SetScenarioGroupEnabled(scgrp, false)
        end
		Citizen.Wait(10000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local vehiclePool = GetGamePool('CVehicle')
		local pedPool = GetGamePool('CPed')
		local objectPool = GetGamePool('CObject')
        for k,v in pairs(vehiclePool) do
            if Config.BlacklistedVehicles[GetEntityModel(v)] then
				SetEntityAsMissionEntity(v, true, true)
                DeleteVehicle(v)
				SetEntityAsNoLongerNeeded(v)
            end
        end
		for k,v in pairs(pedPool) do
			SetPedDropsWeaponsWhenDead(v, false)
			if Config.BlacklistedPeds[GetEntityModel(v)] then
				SetEntityAsMissionEntity(v, true, true)
				DeletePed(v)
				SetEntityAsNoLongerNeeded(v)
			end
		end
		for k,v in pairs(objectPool) do
			if Config.BlacklistedObjects[GetEntityModel(v)] then
				SetEntityAsMissionEntity(v, true, true)
				DeleteObject(v)
				SetEntityAsNoLongerNeeded(v)
			end
		end
        Citizen.Wait(250)
    end
end)
