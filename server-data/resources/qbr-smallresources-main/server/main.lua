QBCore.Commands.Add("id", "Check Your ID #", {}, false, function(source, args)
    TriggerClientEvent('QBCore:Notify', source,  "ID: "..source)
end)

QBCore.Functions.CreateCallback('smallresources:server:GetCurrentPlayers', function(source, cb)
    cb(#QBCore.Functions.GetPlayers())
end)
