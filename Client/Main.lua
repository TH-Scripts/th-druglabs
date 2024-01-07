local DruglabLocation
local RadialIsShowing = false
local currentIndex = nil
local isBoss = false

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    if job.grade_name == 'boss' then
        isBoss = false
    else
        isBoss = true
    end
end)

function onEnter(self)
    DruglabLocation = self.index
    if not RadialIsShowing then
        lib.addRadialItem({
            id = 'druglab',
            icon = 'flask',
            label = 'Tilgå Druglab',
            onSelect = function()
                EnterDruglab(DruglabLocation)
            end
        })
        RadialIsShowing = true
    end
end

function onExit(self)
    if RadialIsShowing then
        lib.removeRadialItem('druglab')
        RadialIsShowing = false
    end
end

function onEnterLab(self)
    if not RadialIsShowing then
        lib.addRadialItem({
            id = 'druglab_exit',
            icon = 'flask',
            label = 'Gå ud af Druglab',
            onSelect = function()
                ExitDrugLab(DruglabLocation)
            end
        })
        RadialIsShowing = true
    end
end

function onExitLab(self)
    if RadialIsShowing then
        lib.removeRadialItem('druglab_exit')
        RadialIsShowing = false
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        ESX.TriggerServerCallback('arp-druglabs:getlocations', function(data)
            if not RadialIsShowing then   
                for _, v in pairs(data) do
                    local coords = v.coords
                    lib.points.new({
                        index = v.id,
                        coords = json.decode(coords),
                        distance = 5,
                        onEnter = onEnter,
                        onExit = onExit
                    })
                end
            end
        end)

        ESX.TriggerServerCallback('arp-druglabs:getpincodes', function(data)
            if not RadialIsShowing then   
                for _, v in pairs(data) do
                    lib.points.new({
                        index = v.id,
                        coords = Config.Shells.CokeShell.Udgang,
                        distance = 5,
                        onEnter = onEnterLab,
                        onExit = onExitLab
                    })
                end
            end
        end)

        ESX.TriggerServerCallback('arp-druglabs:getpincodes', function(data)
            if not RadialIsShowing then    
                for _, v in pairs(data) do
                    lib.points.new({
                        index = v.id,
                        coords = Config.Shells.HashShell.Udgang,
                        distance = 5,
                        onEnter = onEnterLab,
                        onExit = onExitLab
                    })
                end
            end
        end)
    end
end)

RegisterNetEvent('arp-druglab:createdruglab', function()
    local input = lib.inputDialog('Lav et druglab', {
        {type = 'select', label = 'Vælg et druglab - shell', options = {{value = 'coke', label = 'Kokain lab'}, {value = 'hash', label = 'Hash lab'}}, icon = 'home'},
        {type = 'number', label = 'Pin-kode', description = 'Skriv den midlertige pinkode', icon = 'hashtag', max = 9999},
        {type = 'checkbox', label = 'Nuværende coords som indgang', required = true},
    })
    local PlayerPed  = GetPlayerServerId(PlayerId())

    if input == nil then
        return 
    end

    if input[1] == 'coke' then
        local lab = 'coke'
        TriggerServerEvent('arp-druglab:creatingdruglab', input[2], lab, PlayerPed)
    elseif input[1] == 'hash' then
        local lab = 'hash'
        TriggerServerEvent('arp-druglab:creatingdruglab', input[2], lab, PlayerPed)
    end

end)

function EnterDruglab(index)
    local input = lib.inputDialog('', {
        {type = 'number', label = 'Pin-kode', description = 'Skriv den korrekte pinkode til labbet', icon = 'hashtag', max = 9999},
    })
    local ped = PlayerPedId()

    if input == nil then
        return
    end

    ESX.TriggerServerCallback('arp-druglabs:getpincodes', function(data)
       for _, v in pairs(data) do
        if index == v.id then
            if input[1] == v.pinkode then
                local PlayerPed  = GetPlayerServerId(PlayerId())
                ESX.TriggerServerCallback('arp-druglabs:getshell', function(data)
                    if data == 'coke' then
                        SetEntityCoords(ped, Config.Shells.CokeShell.Udgang)
                    elseif data == 'hash' then
                        SetEntityCoords(ped, Config.Shells.HashShell.Udgang)
                        
                    end
                    TriggerServerEvent('arp-druglabs:enterrouting', index, PlayerPed)
                    TriggerEvent('arp-druglabs:captureindex', index)
                end, index)
            else
                notifyForkertKode()
            end
        end
       end
    end)
       
end

function ExitDrugLab(index)
    local ped = PlayerPedId()
    local PlayerPed  = GetPlayerServerId(PlayerId())
        ESX.TriggerServerCallback('arp-druglabs:gotindex', function(index)

            function extractCoordinates(coordsStr)
                local coords = json.decode(coordsStr)
                local x = coords.x or 0
                local y = coords.y or 0
                local z = coords.z or 0
                return x, y, z
            end
            
            -- Example usage:
            local vCoordsStr = index
            local xValue, yValue, zValue = extractCoordinates(vCoordsStr)
            SetEntityCoords(ped, xValue, yValue, zValue)
            TriggerServerEvent('arp-druglabs:exitrouting', PlayerPed)
    end, index)
end

RegisterNetEvent('arp-druglabs:captureindex', function(index)
    currentIndex = index
    print(currentIndex)
end)


exports.ox_target:addSphereZone({
    coords = Config.Shells.CokeShell.Computer, 
    radius = 1,
    debug = drawZones,
    options = {
        {
            icon = 'fa-solid fa-hashtag',
            label = 'Tilgå computeren',
            onSelect = function()
                print(currentIndex)
                local ped = PlayerPedId()
                TaskGoStraightToCoord(ped, 1087.1700, -3194.2849, -38.9935, 1, -1, 95.5092, 1)
                Wait(2000)
                FreezeEntityPosition(ped, true)
                ExecuteCommand('e type')
                Wait(1000)
                DrugLabPc(currentIndex)
            end
        },
    }
})

RegisterCommand('testdruglab', function()
    DrugLabPc(26)
end)

function DrugLabPc(currentIndex)
    ESX.TriggerServerCallback('arp-druglabs:level', function(data)
        for _, exp in pairs(data) do
            lib.registerContext({
                id = 'druglab_pc',
                title = 'Druglab Computer',
                onExit = function()
                    local ped = PlayerPedId()
                    FreezeEntityPosition(ped, false)
                    ExecuteCommand('e c')
                end,
                options = {
                    {
                        title = 'Drug lab XP',
                        description = 'Dit nuværende level: '..exp.lvl.. ' \n\nSe hvor meget XP dit drug lab har',
                        progress = exp.exp,
                        colorScheme = 'teal',
                        icon = 'database',
                        readOnly = true
                    },
                    {
                        title = 'Missioner',
                        description = 'Se hvor meget XP dit drug lab har',
                        icon = 'truck-fast',
                        onSelect = function()
                            print('mission menu')
                        end
                    },
                    {
                        title = 'Druglab settings',
                        icon = 'gear',
                        iconAnimation = 'spin',
                        disabled = isBoss,
                        description = 'Se forskellige ændringer du kan foretage i dit drug lab',
                        onSelect = function()
                            SettingsPc(currentIndex)
                        end
                    }
                }
                
            })

            lib.showContext('druglab_pc')
        end
    end, currentIndex)
end

RegisterCommand('addpoints', function()
    TriggerServerEvent('arp-druglabs:addpoint', 26)
    NyDruglabLevel(26)
end)

function SettingsPc(currentIndex)

    local elements = {}

    ESX.TriggerServerCallback('arp-druglabs:getpincodes', function(data)
        for _, data in pairs(data) do
        if data.id == currentIndex then
                table.insert(elements, {
                    title = 'Skift pin-kode',
                    description = 'Din nuværende pinkode er '..data.pinkode,
                    icon = 'spinner',
                    iconAnimation = 'spin',
                    onSelect = function()
                        SkiftPin(data.pinkode, currentIndex)
                    end
                })
            end
        end

        lib.registerContext({
            id = 'druglab_settings',
            title = 'Drug lab Settings',
            menu = 'druglab_pc',
            onExit = function()
                local ped = PlayerPedId()
                FreezeEntityPosition(ped, false)
                ExecuteCommand('e c')
            end,
            options = elements
        })
  
        lib.showContext('druglab_settings')
     end)

end

function SkiftPin(pinkode, id)
    local input = lib.inputDialog('Ændre din nuværende pinkode', {
        {type = 'number', label = 'Ny pin-kode', description = 'Skriv din nye pin-kode', icon = 'hashtag', max = 9999},
    })

    local nyKode = input[1]

    if input ~= nil then
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        ExecuteCommand('e c')
    else
        return
    end

    ESX.TriggerServerCallback('arp-druglabs:skiftkode', function(data)
        notifyKodeSkiftet(nyKode)
    end, pinkode, id, nyKode)
end

function NyDruglabLevel(index)
    ESX.TriggerServerCallback('arp-druglabs:level', function (output)
        for k,v in pairs(output) do
            local PlayerPed  = GetPlayerServerId(PlayerId())
            if v.exp >= 90 then
                TriggerServerEvent('arp-druglabs:resetpoints', PlayerPed, index)
            end
        end
    end, index)
end


-- mission slut nydruglab skal også triggers
