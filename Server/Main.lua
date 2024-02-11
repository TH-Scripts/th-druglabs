-- skal laves til ejendomsmægler

AddEventHandler('onResourceStop', function()
    MySQL.update.await('UPDATE druglabs SET cooldown = 0')
end)
  

RegisterCommand('createdruglab', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()

    if group == 'admin' then
        TriggerClientEvent('th-druglab:createdruglab', source)
    else
        return TriggerClientEvent('ox_lib:notify', source, {title = 'Du har ikke adgang til dette!', position = Config.Notify.position, style = Config.Notify.Style})
    end

    logs('Druglab oprettet', 'En spiller har lige oprettet et druglab', footer)
end)

ESX.RegisterServerCallback('th-druglabs:getPlayers', function(source, cb)
    local playersData = {}

    local xPlayers = ESX.GetExtendedPlayers()

    for _, xPlayer in pairs(xPlayers) do
        table.insert(playersData, {
            source = xPlayer.source,
            identifier = xPlayer.identifier,
            name = xPlayer.getName()
        })
    end

    cb(playersData)
end)

ESX.RegisterServerCallback('th-druglab:medlemmenu', function(source, cb, closetsplayer)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    local xTarget = ESX.GetPlayerFromId(closetsplayer)

    if xTarget then
        print("xTarget Name: " .. tostring(xTarget.getName()))

        local players = {}

        table.insert(players, {
            source = xTarget.source,
            identifier = xTarget.identifier,
            job = xTarget.getJob().grade_label,
            jobGrade = xTarget.getJob().grade_name,
            name = xTarget.name,
            firstname = xTarget.get('firstName'),
            lastname = xTarget.get('lastName'),
        })


        cb(players)
    else
        return
    end
end)


RegisterNetEvent('th-druglab:creatingdruglab', function(pinkode, shell, PlayerId, identifier)
    local xPlayer = ESX.GetPlayerFromId(PlayerId)
    local name = xPlayer.getName()
    local coords = xPlayer.getCoords(false)

    if not xPlayer then
        return
    end

    MySQL.insert.await('INSERT INTO druglabs (pinkode, coords, shell, lvl, exp, owner) VALUES (?, ?, ?, ?, ?, ?)',{
        pinkode, json.encode(coords), shell, '0', 0, identifier
    })

end)

ESX.RegisterServerCallback('th-druglabs:getlocations', function(source, cb)
    local table = MySQL.query.await('SELECT id, coords FROM druglabs')
    cb(table)
end)

ESX.RegisterServerCallback('th-druglabs:getpincodes', function(source, cb)
    local table = MySQL.query.await('SELECT id, pinkode, coords FROM druglabs')
    cb(table)
end)


ESX.RegisterServerCallback('th-druglabs:getshell', function(source, cb, index)
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

RegisterNetEvent('th-druglabs:enterrouting', function(index, PlayerId)
    SetPlayerRoutingBucket(PlayerId, index)
end)

RegisterNetEvent('th-druglabs:exitrouting', function(PlayerId)
    SetPlayerRoutingBucket(PlayerId, 0)

end)


ESX.RegisterServerCallback('th-druglabs:gotindex', function(source, cb, index)
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

ESX.RegisterServerCallback('th-druglabs:skiftkode', function(source, cb, pinkode, id, nyKode)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    local update = MySQL.update.await('UPDATE druglabs SET pinkode = ? WHERE id = ?', {
        nyKode, id
    })
    cb(update)


end)

ESX.RegisterServerCallback('th-druglabs:level', function(source, cb, id)
    local result = MySQL.query.await('SELECT exp, lvl FROM `druglabs` WHERE id = ?', {
        id
    })

    cb(result)
end)

RegisterNetEvent('th-druglab:reward', function(mission, ped, point)
    local xPlayer = ESX.GetPlayerFromId(ped)

    if not xPlayer then
        return
    end
    
    if mission == 1 then
        xPlayer.addInventoryItem(Config.Missions.Mission1.Items.item, Config.Missions.Mission1.Items.antal)
        TriggerClientEvent('ox_lib:notify', ped, ({
            id = 'dshf',
            title = 'Skynd dig væk',
            description = 'Du fik '..Config.Missions.Mission1.Items.antal.. ' '..Config.Missions.Mission1.Items.label.."'s for at røve varevogen. Samt "..point..' points til dit druglab!',
            position = Config.Notify.position,
            style = Config.Notify.Style,
            icon = 'person-running',
            iconColor = '#32a852'
        }))
    elseif mission == 2 then
        xPlayer.addInventoryItem(Config.Missions.Mission2.Items.item, Config.Missions.Mission2.Items.antal)
        TriggerClientEvent('ox_lib:notify', ped, ({
            id = 'dshf',
            title = 'Skynd dig væk',
            description = 'Du fik '..Config.Missions.Mission2.Items.antal.. ' '..Config.Missions.Mission2.Items.label.." for at røve varevogen. Samt "..point..' points til dit druglab!',
            position = Config.Notify.position,
            style = Config.Notify.Style,
            icon = 'person-running',
            iconColor = '#32a852'
        }))
    elseif mission == 3 then
        xPlayer.addInventoryItem(Config.Missions.Mission3.Items.item, Config.Missions.Mission3.Items.antal)
        TriggerClientEvent('ox_lib:notify', ped, ({
            id = 'dshf',
            title = 'Skynd dig væk',
            description = 'Du fik '..Config.Missions.Mission3.Items.antal.. ' '..Config.Missions.Mission3.Items.label.."'s for at røve varevogen. Samt "..point..' points til dit druglab!',
            position = Config.Notify.position,
            style = Config.Notify.Style,
            icon = 'person-running',
            iconColor = '#32a852'
        }))
    end
end)

ESX.RegisterServerCallback('th-druglabs:tjeklockpick', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not xPlayer then
        return
    end

    local item = exports.ox_inventory:GetItem(1, Config.Missions.Item)
    
    if item.count > 0 then
        xPlayer.removeInventoryItem(Config.Missions.Item, 1)
        cb(true)
    else
        cb(false)
    end

end)


RegisterNetEvent('th-druglabs:resetpoints', function(PlayerPed, index)
    xPlayer = ESX.GetPlayerFromId(PlayerPed)

    if not xPlayer then
        return
    end

    local output = MySQL.query.await('SELECT exp, lvl FROM druglabs WHERE id = ?', {
        index
    })

    for _,v in pairs(output) do

        if v.lvl == 4 then
            return
        end
        
        local newLevel = v.lvl + 1

        if newLevel == 4 then
            newLevel = 'Max level'
        end

        MySQL.update.await('UPDATE druglabs SET exp = ?, lvl = ? WHERE id = ?', {
            0, newLevel, index
        })
    end

end)

ESX.RegisterServerCallback('th-druglabs:tjekmoney', function(source, cb, price, ped)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerBank = xPlayer.getAccount('bank').money

    if not xPlayer then
        return
    end

    if playerBank >= price then
        xPlayer.removeAccountMoney('bank', price)
        TriggerClientEvent('ox_lib:notify', source, ({
            id = 'dshf',
            title = 'Mission betalt!',
            description = 'Du betalte '..price..' kr. for at begynde en mission. Pengene er allerede taget!',
            position = Config.Notify.position,
            style = Config.Notify.Style,
            icon = 'sack-dollar',
            iconColor = '#32a852'
        }))
        cb(true)
    else
        cb(false)
    end

end)


ESX.RegisterServerCallback('th-druglabs:getrightxp', function(source, cb, index, points)

    local output = MySQL.query.await('SELECT exp FROM `druglabs` WHERE id = ?', {
        index
    })

    for k,v in pairs(output) do
        local new_point = v.exp + points

        local updated = MySQL.update.await('UPDATE druglabs SET exp = ? WHERE id = ?', {
            new_point, index
        })
        cb(new_point)
    end
    
end)

ESX.RegisterServerCallback('th-druglabs:checkCooldown', function(source, cb, index)
    local getTimer = MySQL.query.await('SELECT cooldown, id FROM druglabs WHERE id = ?', {
        index
    })
    
    for k,v in pairs(getTimer) do
        print(v.cooldown)
        if v.cooldown == 0 then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('th-druglabs:triggercooldown', function(index)
    MySQL.update.await('UPDATE druglabs SET cooldown = 1 WHERE id = ?', {
        index
    })
end)

ESX.RegisterServerCallback('th-druglab:tjekpcaccess', function(source, cb, index)
    local access = MySQL.query.await('SELECT owner, members FROM druglabs WHERE id = ?', {
        index
    })
    local xPlayer = ESX.GetPlayerFromId(source)
    
    for _, v in pairs(access) do 
        if xPlayer.identifier == v.owner then
            cb(true)
        else
            cb(false)
        end 
    end
    

end)

RegisterNetEvent('th-druglabs:addmember', function(name, identifier, currentindex)
    local data = json.encode({identifier, name})
    MySQL.Async.execute('UPDATE druglabs SET members = ? WHERE id = ?', {data, currentindex})
end)

RegisterNetEvent('th-druglab:removemember', function(identifier, currentindex)
    
    MySQL.Async.fetchScalar('SELECT members FROM druglabs WHERE id = ?', {index}, function(membersJson)
        if membersJson then
            local members = json.decode(membersJson)

            local data = {}

            table.insert(data, {
                identifier = members[1],
                name = members[2]
            })

            cb(data)
        end
    end)

end)


ESX.RegisterServerCallback('th-druglabs:getmembers', function(source, cb, index)
    local xPlayer = ESX.GetPlayerFromId(source) 

    MySQL.Async.fetchScalar('SELECT members FROM druglabs WHERE id = ?', {index}, function(membersJson)
        if membersJson then
            local members = json.decode(membersJson)

            local data = {}

            table.insert(data, {
                identifier = members[1],
                name = members[2]
            })

            cb(data)
        end
    end)
end)

