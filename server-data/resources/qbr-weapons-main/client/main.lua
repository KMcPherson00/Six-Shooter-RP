local QBCore = exports['qbr-core']:GetCoreObject()
local CurrentWeaponData = {}
local PlayerData = {}
local CanShoot = true

function DrawText3Ds(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)

    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
end

local MultiplierAmount = 0

Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state['isLoggedIn'] then
            local ped = PlayerPedId()
            --if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
            --    if IsPedShooting(ped) or IsControlJustPressed(0, 0x07CE1E61) then
            --        if CanShoot then
            --            local weapon = GetCurrentPedWeapon(ped, true, 0, true)
            --            local ammo = GetAmmoInPedWeapon(ped, weapon)
            --                if ammo > 0 then
            --                    MultiplierAmount = MultiplierAmount + 1
            --                end
            --        else
			--            local weapon = GetCurrentPedWeapon(ped, true, 0, true)
            --            if weapon ~= -1569615261 then
            --                TriggerEvent('inventory:client:CheckWeapon', QBCore.Shared.Weapons[weapon]["name"])
            --                QBCore.Functions.Notify("This weapon is broken and can not be used..", "error")
            --                MultiplierAmount = 0
            --            end
            --        end
            --    end
            --end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        -- local ped = PlayerPedId()
        -- local player = PlayerId()
        -- local retval, weapon = GetCurrentPedWeapon(ped, true, 0, true)
        -- local ammo = GetAmmoInPedWeapon(ped, weapon)
        -- if ammo == 1 then
        --     DisableControlAction(0, 0x07CE1E61, true) -- Attack
        --     DisableControlAction(0, 257, true) -- Attack 2
        --     if IsPedInAnyVehicle(ped, true) then
        --         SetPlayerCanDoDriveBy(player, false)
        --     end
        -- else
        --     EnableControlAction(0, 0x07CE1E61, true) -- Attack
		-- 	EnableControlAction(0, 257, true) -- Attack 2
        --     if IsPedInAnyVehicle(ped, true) then
        --         SetPlayerCanDoDriveBy(player, true)
        --     end
        -- end

        -- if IsPedShooting(ped) then
        --     if ammo - 1 < 1 then
        --         SetAmmoInClip(ped, GetHashKey(QBCore.Shared.Weapons[weapon]["name"]), 0)
        --     end
        -- end

        Citizen.Wait(0)
    end
end)

local allowList = {
    GetHashKey('weapon_lasso'),
    GetHashKey('weapon_lasso_reinforced'),
    GetHashKey('weapon_melee_knife'),
    GetHashKey('weapon_melee_knife_jawbone'),
    GetHashKey('weapon_melee_hammer'),
    GetHashKey('weapon_melee_cleaver'),
    GetHashKey('weapon_melee_lantern'),
    GetHashKey('weapon_melee_davy_lantern'),
    GetHashKey('weapon_melee_torch'),
    GetHashKey('weapon_melee_hatchet'),
    GetHashKey('weapon_melee_machete'),
}

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsControlJustReleased(0, 0x07CE1E61) or IsDisabledControlJustReleased(0, 0x07CE1E61) then
            local retval, weapon = GetCurrentPedWeapon(ped, true, 0, true)
            for k,v in pairs(allowList) do
                if (v == weapon) then
                    return
                end
            end
            if allowList[GetHashKey(weapon)] then return end
            local ammo = GetAmmoInPedWeapon(ped, weapon)
            if ammo > 0 then
                TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, tonumber(ammo))
            else
                TriggerEvent('inventory:client:CheckWeapon')
                TriggerServerEvent("weapons:server:UpdateWeaponAmmo", CurrentWeaponData, 0)
            end

            if MultiplierAmount > 0 then
                TriggerServerEvent("weapons:server:UpdateWeaponQuality", CurrentWeaponData, MultiplierAmount)
                MultiplierAmount = 0
            end
        end
        Citizen.Wait(1)
    end
end)

RegisterNetEvent('weapon:client:AddAmmo')
AddEventHandler('weapon:client:AddAmmo', function(type, amount, itemData)
    local ped = PlayerPedId()
    if CurrentWeaponData ~= nil then
        local _, weapon = GetCurrentPedWeapon(ped, false, 0, false)
        if QBCore.Shared.Weapons[weapon]["ammotype"] == type:upper() then
            local total = Citizen.InvokeNative(0x015A522136D7F951, PlayerPedId(), weapon, Citizen.ResultAsInteger())
            local retval = GetMaxAmmoInClip(PlayerPedId(), weapon, 1)
            retval = tonumber(retval)
            local maxAmmo = Citizen.InvokeNative(0xDC16122C7A20C933, PlayerPedId(), weapon, Citizen.ResultAsInteger())
                QBCore.Functions.Progressbar("taking_bullets", "Loading bullets..", math.random(4000, 6000), false, true, {
                    disableMovement = false,
                    disableCarMovement = false,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function() -- Done
                    if QBCore.Shared.Weapons[weapon] ~= nil then
                        Citizen.InvokeNative(0xB190BCA3F4042F95, ped, weapon, retval, 0xCA3454E6)
                        TaskReloadWeapon(ped)
                        TriggerServerEvent("weapons:server:AddWeaponAmmo", CurrentWeaponData, total + retval)
                        TriggerServerEvent('QBCore:Server:RemoveItem', itemData.name, 1, itemData.slot)
                        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemData.name], "remove")
                        TriggerEvent('QBCore:Notify', 'Reloaded', "success")
                    end
                end, function()
                    QBCore.Functions.Notify("Canceled", "error")
                end)
        else
            QBCore.Functions.Notify("You Have No Weapon", "error")
        end
    else
        QBCore.Functions.Notify("You Have No Weapon.", "error")
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()

    QBCore.Functions.TriggerCallback("weapons:server:GetConfig", function(RepairPoints)
        for k, data in pairs(RepairPoints) do
            Config.WeaponRepairPoints[k].IsRepairing = data.IsRepairing
            Config.WeaponRepairPoints[k].RepairingData = data.RepairingData
        end
    end)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerData = QBCore.Functions.GetPlayerData()

        QBCore.Functions.TriggerCallback("weapons:server:GetConfig", function(RepairPoints)
            for k, data in pairs(RepairPoints) do
                Config.WeaponRepairPoints[k].IsRepairing = data.IsRepairing
                Config.WeaponRepairPoints[k].RepairingData = data.RepairingData
            end
        end)
    end
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
    CanShoot = bool
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    for k, v in pairs(Config.WeaponRepairPoints) do
        Config.WeaponRepairPoints[k].IsRepairing = false
        Config.WeaponRepairPoints[k].RepairingData = {}
    end
end)

RegisterNetEvent('weapons:client:SetWeaponQuality')
AddEventHandler('weapons:client:SetWeaponQuality', function(amount)
    if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
        TriggerServerEvent("weapons:server:SetWeaponQuality", CurrentWeaponData, amount)
    end
end)

Citizen.CreateThread(function()
    while true do
        if LocalPlayer.state['isLoggedIn'] then
            local inRange = false
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)

            for k, data in pairs(Config.WeaponRepairPoints) do
                local distance = #(pos - vector3(data.coords.x, data.coords.y, data.coords.z))

                if distance < 10 then
                    inRange = true

                    if distance < 1 then
                        if data.IsRepairing then
                            if data.RepairingData.CitizenId ~= PlayerData.citizenid then
                                DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'The repairshop is this moment  ~r~NOT~w~ usable..')
                            else
                                if not data.RepairingData.Ready then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'Your weapon will be repaired')
                                else
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] to take weapon back')
                                end
                            end
                        else
                            if CurrentWeaponData ~= nil and next(CurrentWeaponData) ~= nil then
                                if not data.RepairingData.Ready then
                                    local WeaponData = QBCore.Shared.Weapons[GetHashKey(CurrentWeaponData.name)]
                                    local WeaponClass = (QBCore.Shared.SplitStr(WeaponData.ammotype, "_")[2]):lower()
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] Repair weapon, ~g~$'..Config.WeaponRepairCotsts[WeaponClass]..'~w~')
                                    if IsControlJustPressed(0, 38) then
                                        QBCore.Functions.TriggerCallback('weapons:server:RepairWeapon', function(HasMoney)
                                            if HasMoney then
                                                CurrentWeaponData = {}
                                            end
                                        end, k, CurrentWeaponData)
                                    end
                                else
                                    if data.RepairingData.CitizenId ~= PlayerData.citizenid then
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'The repairshop is this moment ~r~NOT~w~ usable..')
                                    else
                                        DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] to take weapon back')
                                        if IsControlJustPressed(0, 38) then
                                            TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                        end
                                    end
                                end
                            else
                                if data.RepairingData.CitizenId == nil then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, 'You dont have a weapon in ur hands..')
                                elseif data.RepairingData.CitizenId == PlayerData.citizenid then
                                    DrawText3Ds(data.coords.x, data.coords.y, data.coords.z, '[E] to take weapon back')
                                    if IsControlJustPressed(0, 38) then
                                        TriggerServerEvent('weapons:server:TakeBackWeapon', k, data)
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if not inRange then
                Citizen.Wait(1000)
            end
        end
        Citizen.Wait(3)
    end
end)

RegisterNetEvent("weapons:client:SyncRepairShops")
AddEventHandler("weapons:client:SyncRepairShops", function(NewData, key)
    Config.WeaponRepairPoints[key].IsRepairing = NewData.IsRepairing
    Config.WeaponRepairPoints[key].RepairingData = NewData.RepairingData
end)

RegisterNetEvent("weapons:client:EquipAttachment")
AddEventHandler("weapons:client:EquipAttachment", function(ItemData, attachment)
    local ped = PlayerPedId()
    local retval, weapon = GetCurrentPedWeapon(ped, true, 0, true)
    local WeaponData = QBCore.Shared.Weapons[weapon]

    if weapon ~= GetHashKey("WEAPON_UNARMED") then
        WeaponData.name = WeaponData.name:upper()
        if WeaponAttachments[WeaponData.name] ~= nil then
            if WeaponAttachments[WeaponData.name][attachment] ~= nil then
                TriggerServerEvent("weapons:server:EquipAttachment", ItemData, CurrentWeaponData, WeaponAttachments[WeaponData.name][attachment])
            else
                QBCore.Functions.Notify("This weapon does not support this attachment..", "error")
            end
        end
    else
        QBCore.Functions.Notify("You dont have a weapon in ur hand..", "error")
    end
end)

RegisterNetEvent("addAttachment")
AddEventHandler("addAttachment", function(component)
    local ped = PlayerPedId()
    local retval, weapon = GetCurrentPedWeapon(ped, true, 0, true)
    local WeaponData = QBCore.Shared.Weapons[weapon]
    GiveWeaponComponentToPed(ped, GetHashKey(WeaponData.name), GetHashKey(component))
end)

RegisterNetEvent('weapons:client:EquipTint')
AddEventHandler('weapons:client:EquipTint', function(tint)
    local player = PlayerPedId()
    local retval, weapon = GetCurrentPedWeapon(ped, true, 0, true)
    SetPedWeaponTintIndex(player, weapon, tint)
end)
