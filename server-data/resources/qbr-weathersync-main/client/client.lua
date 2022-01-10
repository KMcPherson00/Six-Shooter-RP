local QBCore = exports['qbr-core']:GetCoreObject()
local CurrentWeather = Config.StartWeather
local lastWeather = CurrentWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local timer = 0
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local disable = Config.Disabled

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    disable = false
    TriggerServerEvent('qbr-weathersync:server:RequestStateSync')
    TriggerServerEvent('qbr-weathersync:server:RequestCommands')
end)

function DisableSync()
    disable = true

    CreateThread(function()
        while disable do
            Citizen.InvokeNative(0x59174F1AFE095B5A, `SUNNY`, false, true, true, 1.0, false) -- set weather
            NetworkClockTimeOverride(12, 0, 0, 0, true)
            NetworkClockTimeOverride_2(12, 0, 0, 0, true, true)
            Citizen.InvokeNative(0x193DFC0526830FD6, 0.0) -- set rain level
            Wait(5000)
        end
    end)
end

function EnableSync()
    disable = false
    TriggerServerEvent('qbr-weathersync:server:RequestStateSync')
end

RegisterNetEvent('qbr-weathersync:client:SyncWeather')
AddEventHandler('qbr-weathersync:client:SyncWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

RegisterNetEvent('qbr-weathersync:client:RequestCommands')
AddEventHandler('qbr-weathersync:client:RequestCommands', function(isAllowed)
    if isAllowed then
        TriggerEvent('chat:addSuggestion', '/freezetime', _U('help_freezecommand'), {})
        TriggerEvent('chat:addSuggestion', '/freezeweather', _U('help_freezeweathercommand'), {})
        TriggerEvent('chat:addSuggestion', '/weather', _U('help_weathercommand'), {
            { name=_U('help_weathertype'), help=_U('help_availableweather') }
        })
        TriggerEvent('chat:addSuggestion', '/blackout', _U('help_blackoutcommand'), {})
        TriggerEvent('chat:addSuggestion', '/morning', _U('help_morningcommand'), {})
        TriggerEvent('chat:addSuggestion', '/noon', _U('help_nooncommand'), {})
        TriggerEvent('chat:addSuggestion', '/evening', _U('help_eveningcommand'), {})
        TriggerEvent('chat:addSuggestion', '/night', _U('help_nightcommand'), {})
        TriggerEvent('chat:addSuggestion', '/time', _U('help_timecommand'), {
            { name=_U('help_timehname'), help=_U('help_timeh') },
            { name=_U('help_timemname'), help=_U('help_timem') }
        })
    end
end)


Citizen.CreateThread(function()
    while true do
        if not disable then
            Wait(100)
            if lastWeather ~= CurrentWeather then
                ClearWeatherTypePersist()

                Citizen.InvokeNative(0xFA3E3CA8A1DE6D5D, GetHashKey(lastWeather), GetHashKey(CurrentWeather), 0.7, 1)
                Citizen.InvokeNative(0x59174F1AFE095B5A, GetHashKey(CurrentWeather), false, true, true, 45.0, false)
                lastWeather = CurrentWeather
                Citizen.Wait(15000)
            end

        else
            Citizen.Wait(1000)
        end
    end
end)

RegisterNetEvent('qbr-weathersync:client:SyncTime')
AddEventHandler('qbr-weathersync:client:SyncTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        if not disable then
            Citizen.Wait(0)
            local newBaseTime = baseTime
            if GetGameTimer() - 500  > timer then
                newBaseTime = newBaseTime + 0.25
                timer = GetGameTimer()
            end
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime
            end
            baseTime = newBaseTime
            hour = math.floor(((baseTime+timeOffset)/60)%24)
            minute = math.floor((baseTime+timeOffset)%60)
            SetClockTime(hour, minute, 0)
            AdvanceClockTimeTo(hour, minute, 0)
            NetworkClockTimeOverride(hour, minute, 0, 0, true)
            NetworkClockTimeOverride_2(hour, minute, 0, 0, true, true)
        else
            Citizen.Wait(1000)
        end
    end
end)

exports('disableSync', DisableSync)
exports('enableSync', EnableSync)
