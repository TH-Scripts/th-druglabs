-- skal laves til ejendomsmægler
local ox_inventory = exports.ox_inventory



AddEventHandler('onResourceStop', function()
    MySQL.update.await('UPDATE druglabs SET cooldown = 0')
end)


RegisterCommand('createdruglab', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()

    if group == 'admin' then
        TriggerClientEvent('arp-druglab:createdruglab', source)
    end
end)

ESX.RegisterServerCallback('arp-druglab:tjekOmdanItem', function(source, cb, value, access)
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomTake = math.random(2,3)
    local item

    if not xPlayer or not access == 'access' then
        return
    end

    if value == 'coke' then
        item = exports.ox_inventory:GetItem(1, Config.Shells.CokeShell.Omdan.omdanItem)
    elseif value == 'hash' then
        item = exports.ox_inventory:GetItem(1, Config.Shells.HashShell.Omdan.omdanItem)
    elseif value == 'meth' then
        item = exports.ox_inventory:GetItem(1, Config.Shells.MethShell.Omdan.omdanItem)
    end

    print(item.count)

    if item.count >= randomTake then
        cb(true)
        print('works')
    else
        cb(false)
        print('works, false')
    end




end)

RegisterNetEvent('arp-druglab:giveItem', function(value, omdan, status)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not access == true and status == 'success' or status == 'failed' then
        return
    end



    if value == Config.Shells.HashShell.value then
        xPlayer.addInventoryItem(Config.Shells.HashShell.Omdan.omdanModtag, math.random(1,2))
        xPlayer.removeInventoryItem(Config.Shells.HashShell.Omdan.omdanItem, math.random(2,3))
    elseif value == Config.Shells.MethShell.value then
        xPlayer.addInventoryItem(Config.Shells.MethShell.Omdan.omdanModtag, math.random(2,3))
        xPlayer.removeInventoryItem(Config.Shells.MethShell.Omdan.omdanItem, math.random(1,2))

    elseif value == Config.Shells.CokeShell.value then
        xPlayer.addInventoryItem(Config.Shells.CokeShell.Omdan.omdanModtag, math.random(2,3))
        xPlayer.removeInventoryItem(Config.Shells.CokeShell.Omdan.omdanItem, math.random(1,2))
    end
end)


ESX.RegisterServerCallback('arp-druglabs:getPlayers', function(source, cb)
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

-- ESX.RegisterServerCallback('arp-druglab:medlemmenu', function(source, cb, closetsplayer)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     if not xPlayer then
--         return
--     end

--     local xTarget = ESX.GetPlayerFromId(closetsplayer)

--     if xTarget then

--         local players = {}

--         table.insert(players, {
--             source = xTarget.source,
--             identifier = xTarget.identifier,
--             job = xTarget.getJob().grade_label,
--             jobGrade = xTarget.getJob().grade_name,
--             name = xTarget.name,
--             firstname = xTarget.get('firstName'),
--             lastname = xTarget.get('lastName'),
--         })


--         cb(players)
--     else
--         return
--     end
-- end)


RegisterNetEvent('arp-druglab:creatingdruglab', function(pinkode, shell, PlayerId, identifier)
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

ESX.RegisterServerCallback('arp-druglabs:getlocations', function(source, cb)
    local table = MySQL.query.await('SELECT id, coords FROM druglabs')
    cb(table)
end)

ESX.RegisterServerCallback('arp-druglabs:getpincodes', function(source, cb)
    local table = MySQL.query.await('SELECT id, pinkode, coords, stash FROM druglabs')
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

RegisterNetEvent('arp-druglabs:loadstash', function(index)
    local id = json.encode(index)

    for _,v in (Config.Stash) do
        ox_inventory:RegisterStash(id, v.label, v.slots, v.weight)
    end

	Wait(500)

	local inventory = ox_inventory:GetInventory({id = id})
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
    local result = MySQL.query.await('SELECT exp, lvl, stash FROM `druglabs` WHERE id = ?', {
        id
    })

    cb(result)
end)

RegisterNetEvent('arp-druglab:reward', function(mission, ped, point)
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

ESX.RegisterServerCallback('arp-druglabs:tjeklockpick', function(source, cb)
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


RegisterNetEvent('arp-druglabs:resetpoints', function(PlayerPed, index)
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

ESX.RegisterServerCallback('arp-druglabs:tjekmoney', function(source, cb, price, ped)
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


ESX.RegisterServerCallback('arp-druglabs:getrightxp', function(source, cb, index, points)

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

ESX.RegisterServerCallback('arp-druglabs:checkCooldown', function(source, cb, index)
    local getTimer = MySQL.query.await('SELECT cooldown, id FROM druglabs WHERE id = ?', {
        index
    })

    for k,v in pairs(getTimer) do
        if v.cooldown == 0 then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('arp-druglabs:triggercooldown', function(index)
    MySQL.update.await('UPDATE druglabs SET cooldown = 1 WHERE id = ?', {
        index
    })
end)

ESX.RegisterServerCallback('arp-druglab:tjekpcaccess', function(source, cb, index)
    local xPlayer = ESX.GetPlayerFromId(source)
    local access = MySQL.query.await('SELECT owner FROM druglabs WHERE id = ?', {
        index
    })

    for _, v in pairs(access) do
        if xPlayer.identifier == v.owner then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('arp-druglabs:addmember', function(id, name, isBoss)

    local memberData = MySQL.query.await('SELECT identifier FROM druglabs-members')
    local tPlayer = ESX.GetPlayerFromId(id)

    for _,v in pairs(memberData) do
        if v.identifier == identifier then
            TriggerClientEvent('ox_lib:notify', source, {title = 'Denne person er allerede medlem af et druglab', type = 'warning'})
        else
            MySQL.insert.await('INSERT INTO `druglabs-members` VALUES (?, ?, ?, ?)', {
                tPlayer.getIdentifier(), tPlayer.getJob(), name, isBoss
            })
        end
    end
    -- local data = json.encode({identifier = identifier, name = name})

    -- MySQL.Async.fetchScalar('SELECT members FROM druglabs WHERE id = ?', {currentindex}, function(membersJson)
    --     local members = {}

    --     if membersJson then
    --         members = json.decode(membersJson)
    --     end

    --     if not members then
    --         members = {}
    --     end

    --     table.insert(members, {identifier = identifier, name = name})

    --     local updatedMembersJson = json.encode(members)
    --     MySQL.Async.execute('UPDATE druglabs SET members = ? WHERE id = ?', {updatedMembersJson, currentindex})
    -- end)
end)


-- RegisterNetEvent('arp-druglabs:removemember', function(name, identifier, currentindex)
--     MySQL.Async.fetchScalar('SELECT members FROM druglabs WHERE id = ?', {currentindex}, function(membersJson)
--         if membersJson then
--             local members = json.decode(membersJson)

--             for i = #members, 1, -1 do
--                 local memberData = members[i]
--                 local memberIdentifier = memberData.identifier
--                 local memberName = memberData.name

--                 if memberName == name and memberIdentifier == identifier then
--                     table.remove(members, i)
--                 end
--             end

--             local updatedMembersJson = json.encode(members)
--             MySQL.Async.execute('UPDATE druglabs SET members = ? WHERE id = ?', {updatedMembersJson, currentindex})
--         end
--     end)
-- end)

-- ESX.RegisterServerCallback('arp-druglabs:getmembers', function(source, cb, index)
--     local xPlayer = ESX.GetPlayerFromId(source)

--     MySQL.Async.fetchScalar('SELECT members FROM druglabs WHERE id = ?', {index}, function(membersJson)
--         if membersJson then
--             local members = json.decode(membersJson)
--             print(json.encode(members))


--             local data = {}

--             if not json.encode(members) == 'null' then
--                 for _, memberData in pairs(members) do
--                     print('hello')
--                     table.insert(data, {
--                         identifier = memberData.identifier,
--                         name = memberData.name
--                     })
--                 end
--             end
--             cb(data)
--         end
--     end)
-- end)
