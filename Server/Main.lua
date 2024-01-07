-- skal laves til ejendomsmægler



RegisterCommand('createdruglab', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()

    if group == 'admin' then
        TriggerClientEvent('arp-druglab:createdruglab', source)
    end
end)


RegisterNetEvent('arp-druglab:creatingdruglab', function(pinkode, shell, PlayerId)
    local xPlayer = ESX.GetPlayerFromId(PlayerId)
    local name = xPlayer.getName()
    local coords = xPlayer.getCoords(false)

    MySQL.insert.await('INSERT INTO druglabs (pinkode, coords, shell) VALUES (?, ?, ?)',{
        pinkode, json.encode(coords), shell
    })

end)

ESX.RegisterServerCallback('arp-druglabs:getlocations', function(source, cb)
    local table = MySQL.query.await('SELECT id, coords FROM druglabs')
    cb(table)
end)

ESX.RegisterServerCallback('arp-druglabs:getpincodes', function(source, cb)
    local table = MySQL.query.await('SELECT id, pinkode, coords FROM druglabs')
    cb(table)
end)


ESX.RegisterServerCallback('arp-druglabs:getshell', function(source, cb, index)
    local response = MySQL.query.await('SELECT `shell` FROM `druglabs` WHERE `id` = ?', {
        index
    })

    if response then
        for i = 1, #response do
            local row = response[i]
            local coords = row.shell
            cb(coords)
        end
    end
end)

RegisterNetEvent('arp-druglabs:enterrouting', function(index, PlayerId)
    SetPlayerRoutingBucket(PlayerId, index)
end)

RegisterNetEvent('arp-druglabs:exitrouting', function(PlayerId)
    SetPlayerRoutingBucket(PlayerId, 0)

end)



ESX.RegisterServerCallback('arp-druglabs:gotindex', function(source, cb, index)
    local response = MySQL.query.await('SELECT `coords` FROM `druglabs` WHERE `id` = ?', {
        index
    })

    if response then
        for i = 1, #response do
            local row = response[i]
            local coords = row.coords
            cb(coords)
        end
    end
end)

ESX.RegisterServerCallback('arp-druglabs:skiftkode', function(source, cb, pinkode, id, nyKode)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    local update = MySQL.update.await('UPDATE druglabs SET pinkode = ? WHERE id = ?', {
        nyKode, id
    })
    cb(update)


end)

ESX.RegisterServerCallback('arp-druglabs:level', function(source, cb, id)
    local result = MySQL.query.await('SELECT exp, lvl FROM `druglabs` WHERE id = ?', {
        id
    })

    cb(result)
end)


RegisterNetEvent('arp-druglabs:resetpoints', function(PlayerPed, index)
    -- xPlayer = ESX.GetPlayerFromId(PlayerPed)

    -- if not xPlayer then
    --     return
    -- end

    local output = MySQL.query.await('SELECT exp, lvl FROM druglabs WHERE id = ?', {
        index
    })

    for _,v in pairs(output) do

        if v.lvl == 5 then
            return
        end
        
        local newLevel = v.lvl + 1

        if newLevel == 5 then
            newLevel = 'Max level'
        end

        MySQL.update.await('UPDATE druglabs SET exp = ?, lvl = ? WHERE id = ?', {
            0, newLevel, index
        })
    end

end)


RegisterNetEvent('arp-druglabs:addpoint', function(index)
    local output = MySQL.query.await('SELECT exp FROM `druglabs` WHERE id = ?', {
        index
    })

    for k,v in pairs(output) do
        local new_point = v.exp + 10

        MySQL.update.await('UPDATE druglabs SET exp = ? WHERE id = ?', {
            new_point, index
        })
    end
end)