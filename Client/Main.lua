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

-- shells
Citizen.CreateThread(function()
    local coke  = CreateObject(`shell_coke2`, 910.3247, -3091.1299, -146.5903)
    FreezeEntityPosition(coke, true)
    
    local meth  = CreateObject(`shell_meth`, 649.0597, -2970.1235, -195.8800)
    FreezeEntityPosition(meth, true)
    
    local weed  = CreateObject(`shell_weed2`, 733.2026, -2152.4561, -82.5409)
    FreezeEntityPosition(weed, true)
end)


function onEnter(self)
    DruglabLocation = self.index
    if Config.Ui == 'radial' then
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
    elseif Config.Ui == 'text' then
        lib.showTextUI('[E] - Druglab')
        Citizen.CreateThread(function()
            while true do
                Wait(5)
                if IsControlJustPressed(0, 38) then
                    EnterDruglab(DruglabLocation)
                    break
                end
            end
        end)
    end
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            local pCoords = GetEntityCoords(PlayerPedId())
            local distance = #(pCoords - self.coords)
            local sleep = true

            if distance < 5 then
                sleep = false
                DrawMarker(20, self.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5,0.5,0.5, 6, 145, 90, 255, 0, false, true, 2, false, false, false, false)     
            end

            if sleep then Citizen.Wait(1500) end
        end
    end)
end

function onExit(self)
    if Config.Ui == 'radial' then
        if RadialIsShowing then
            lib.removeRadialItem('druglab')
            RadialIsShowing = false
        end
    elseif Config.Ui == 'text' then
        lib.hideTextUI()
    end
end

function onEnterLab(self)
    if Config.Ui == 'radial' then
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
    elseif Config.Ui == 'text' then
        lib.showTextUI('[E] - Gå ud af Druglab')
        Citizen.CreateThread(function()
            while true do
                Wait(1)
                if IsControlJustPressed(0, 38) then
                    Wait(100)
                    ExitDrugLab(DruglabLocation)
                    break
                end
            end
        end)
    end
end

function onExitLab(self)
    if Config.Ui == 'radial' then
        if RadialIsShowing then
            lib.removeRadialItem('druglab_exit')
            RadialIsShowing = false
        end
    elseif Config.Ui == 'text' then
        lib.hideTextUI()
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        ESX.TriggerServerCallback('th-druglabs:getlocations', function(data)
            if not RadialIsShowing then   
                for _, v in pairs(data) do
                    local coords = v.coords
                    lib.points.new({
                        index = v.id,
                        coords = json.decode(coords),
                        distance = 3,
                        onEnter = onEnter,
                        onExit = onExit
                    })
                end
            end
        end)

        ESX.TriggerServerCallback('th-druglabs:getpincodes', function(data)
            if not RadialIsShowing then   
                for _, v in pairs(data) do
                    for _, v2 in pairs(Config.Shells) do
                        lib.points.new({
                            index = v.id,
                            coords = v2.Udgang,
                            distance = 3,
                            onEnter = onEnterLab,
                            onExit = onExitLab
                        })
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent('th-druglab:createdruglab', function()
    ESX.TriggerServerCallback('th-druglabs:getPlayers', function(data)
        local playerOptions = {}
        local shellOptions = {}
    
        for _, playerData in pairs(data) do
            table.insert(playerOptions, {value = playerData.identifier, label = '['..playerData.source..'] '..playerData.name})
        end
    
    
        for _, v in pairs(Config.Shells) do
            table.insert(shellOptions, {value = v.value, label = v.label})
        end
    
    
        local input = lib.inputDialog('Lav et druglab', {
            {type = 'select', label = 'Vælg et druglab - shell', options = shellOptions, icon = 'home'},
            {type = 'number', label = 'Pin-kode', description = 'Skriv den midlertige pinkode', icon = 'hashtag', max = 9999},
            {type = 'select', label = 'Vælg ejeren', description = 'Vælg ejeren af druglabbet', options = playerOptions, icon = 'user'},
            {type = 'checkbox', label = 'Nuværende coords som indgang', required = true},
        })
        
        local PlayerPed  = GetPlayerServerId(PlayerId())
        
        if input == nil then
            return 
        end
        
        local identifier = input[3]
    
        
        if input[1] == 'coke' then
            local lab = 'coke'
            TriggerServerEvent('th-druglab:creatingdruglab', input[2], lab, PlayerPed, identifier)
        elseif input[1] == 'hash' then
            local lab = 'hash'
            TriggerServerEvent('th-druglab:creatingdruglab', input[2], lab, PlayerPed, identifier)
        elseif input[1] == 'meth' then
            local lab = 'meth'
            TriggerServerEvent('th-druglab:creatingdruglab', input[2], lab, PlayerPed, identifier)
        end
    
    end)
end)

function EnterDruglab(index)
    local input = lib.inputDialog('', {
        {type = 'number', label = 'Pin-kode', description = 'Skriv den korrekte pinkode til labbet', icon = 'hashtag', max = 9999},
    })
    local ped = PlayerPedId()

    if input == nil then
        return
    end

    ESX.TriggerServerCallback('th-druglabs:getpincodes', function(data)
       for _, v in pairs(data) do
        if index == v.id then
            if input[1] == v.pinkode then
                local PlayerPed  = GetPlayerServerId(PlayerId())
                ESX.TriggerServerCallback('th-druglabs:getshell', function(data)
                    if data == 'coke' then
                        SetEntityCoords(ped, Config.Shells.CokeShell.Udgang)
                    elseif data == 'hash' then
                        SetEntityCoords(ped, Config.Shells.HashShell.Udgang)
                    elseif data == 'meth' then
                        SetEntityCoords(ped, Config.Shells.MethShell.Udgang)
                    end
                    TriggerServerEvent('th-druglabs:enterrouting', index, PlayerPed)
                    TriggerEvent('th-druglabs:captureindex', index)
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
        ESX.TriggerServerCallback('th-druglabs:gotindex', function(index)

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
            TriggerServerEvent('th-druglabs:exitrouting', PlayerPed)
    end, index)
end

RegisterNetEvent('th-druglabs:captureindex', function(index)
    currentIndex = index
end)


for _, v in pairs(Config.Shells) do
    exports.ox_target:addSphereZone({
        coords = v.Computer, 
        radius = 1,
        debug = drawZones,
        options = {
            {
                icon = 'fa-solid fa-laptop',
                label = 'Tilgå computeren',
                distance = 3,
                onSelect = function()
                    ESX.TriggerServerCallback('th-druglab:tjekpcaccess', function(CanAccess)
                        if CanAccess then
                            local ped = PlayerPedId()
                            local pCoords = GetEntityCoords(ped)
                            local distance = #(pCoords - v.Computer)
                            if distance < 1 then
                                FreezeEntityPosition(ped, true)
                                ExecuteCommand('e type')
                                if lib.progressCircle({
                                    duration = 5000,
                                    label = 'Tjekker legitimationsoplysninger',
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        car = true,
                                    },
                                }) then DrugLabPc(currentIndex) end
                            else
                                TaskGoStraightToCoord(ped, v.Computer, 0, -1, v.ComputerHeading, -1)
                                Wait(2500)
                                FreezeEntityPosition(ped, true)
                                ExecuteCommand('e type')
                                if lib.progressCircle({
                                    duration = 5000,
                                    label = 'Tjekker legitimationsoplysninger',
                                    position = 'bottom',
                                    useWhileDead = false,
                                    canCancel = true,
                                    disable = {
                                        car = true,
                                    },
                                }) then DrugLabPc(currentIndex) end
                            end
                        else
                            notifyIngenAdgang()
                        end
                    end, currentIndex)
                end
            },
        }
    })
end

RegisterCommand('testdruglab', function()
    DrugLabPc(34)
end)

function DrugLabPc(currentIndex)
    ESX.TriggerServerCallback('th-druglabs:level', function(data)
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
                        description = 'Dit nuværende level: '..exp.lvl.. ' \n\nProgress til næste level',
                        progress = exp.exp,
                        colorScheme = 'teal',
                        icon = 'database',
                        metadata = {
                            {label = 'Points', value = exp.exp}
                          },
                        readOnly = true
                    },
                    {
                        title = 'Missioner',
                        description = 'Påbegynd missioner som der er tilgængeligt for dit nuværende level',
                        icon = 'truck-fast',
                        onSelect = function()
                            MissionerMenu(currentIndex, exp.lvl)
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

function SettingsPc(currentIndex)

    local elements = {}

    ESX.TriggerServerCallback('th-druglabs:getpincodes', function(data)
        for _, data in pairs(data) do
            if data.id == currentIndex then
                lib.registerContext({
                    id = 'druglab_settings',
                    title = 'Drug lab Settings',
                    menu = 'druglab_pc',
                    onExit = function()
                        local ped = PlayerPedId()
                        FreezeEntityPosition(ped, false)
                        ExecuteCommand('e c')
                    end,
                    options = {
                        {
                            title = 'Skift pin-kode',
                            description = 'Din nuværende pinkode er '..data.pinkode,
                            icon = 'spinner',
                            iconAnimation = 'spin',
                            onSelect = function()
                                SkiftPin(data.pinkode, currentIndex)
                            end
                        },
                        {
                            title = 'Medlemmer',
                            description = 'Se alt ang. medlemmer',
                            icon = 'users',
                            onSelect = function()
                                Medlemmer(currentIndex)
                            end
                        },
                        {
                            title = 'Opgraderinger',
                            description = 'Opgrader dit druglab',
                            icon = 'circle-up',
                            onSelect = function()
                                opgradePc(currentIndex)
                            end
                        }
                    }
                })
            end
        end
        lib.showContext('druglab_settings')
     end)

end

function opgradePC(index)
    lib.registerContext({
        id = 'opgrade',
        title = 'Druglab - Opgraderinger',
        options = {
            {
                title = 'Politi-opgradering',
                description = 'Tilkøb mulighed for at få en besked, når politiet begynder at raide dit lab',
                icon = 'police',
                onSelect = function()
                    local input = lib.inputDialog('Angiv darkchat kanal', {
                        {type = 'input', label = 'Angiv navnet på jers darkchat', description = 'Det er vigtigt, at dette er 100% det samme, som jeres darkchat kanal'},
                    })

                    buy_opgrade('police', input[1])
                end
            }
        }
    })
end

function Medlemmer(index)
    lib.registerContext({
        id = 'medlemmer',
        title = 'Medlem settings',
        menu = 'druglab_pc',
        onExit = function()
            local ped = PlayerPedId()
            FreezeEntityPosition(ped, false)
            ExecuteCommand('e c')
        end,
        options = {
            {
                title = 'Tilføj medlemmer',
                description = 'Tilføj et medlem til dit druglab',
                icon = 'plus',
                iconAnimation = 'shake',
                onSelect = function()
                    ClosestsPeople(index)
                end
            },
            {
                title = 'Medlemmer',
                description = 'Se alle dine medlemmer',
                icon = 'list',
                onSelect = function()
                    GetMembers(index)
                end
            },
        }
    })
    lib.showContext('medlemmer')
end


function GetMembers(index)
    local elements = {}

    ESX.TriggerServerCallback('th-druglabs:getmembers', function(data)
        for _, v in pairs(data) do
            table.insert(elements, {
                title = 'Medlem: '..v.name,
                description = "Person's identifier: "..v.identifier,
                icon = 'user',
                onSelect = function()
                    MemberChange(v.identifier, v.name, index)
                end
            })
        end

        lib.registerContext({
            id = 'see_members',
            title = 'Medlemmer',
            options = elements
        })
    
        lib.showContext('see_members')

    end, index)
end

function MemberChange(name, identifier, index)
    lib.registerContext({
        id = 'change_members',
        title = 'Navn: '..name,
        options = {
            {
                title = 'Fjern '..name,
                description = 'Slet personen fra computeren',
                icon = 'circle-xmark',
                onSelect = function()
                    TriggerServerEvent('th-druglab:removemember', identifier, index)
                end
            },
            {
                title = 'Adgang',
                description = 'Giv personen adgang til settings',
                icon = 'circle-xmark',
                onSelect = function()
                    -- TriggerServerEvent('th-druglab:removemember', identifier, index)
                end
            },
        }
    })
end

function ClosestsPeople(index)
    local elements = {}

    local closestPlayer, closestPlayerDistance = ESX.Game.GetClosestPlayer()

    if closestPlayerDistance < 3.0 then
        local ClosestsPlayer = GetPlayerServerId(closestPlayer)
        ESX.TriggerServerCallback('th-druglab:medlemmenu', function(data)
            local elements = {}
        
            for _, v in pairs(data) do
                if v.name then
                    table.insert(elements, {
                        title = '['..v.source..'] '..v.name,
                        description = 'Job: '..v.job..' \nRangering: '..v.jobGrade,
                        icon = 'user',
                        onSelect = function()
                            TriggerServerEvent('th-druglabs:addmember', v.name, v.identifier, index)
                        end
                    })
                end
            end
        
            lib.registerContext({
                id = 'add_members',
                title = 'Tilføj et medlem',
                options = elements
            })
        
            lib.showContext('add_members')
        end, ClosestsPlayer)
    else
        notifyNoPlayers()
    end
end

function SkiftPin(pinkode, id)
    local input = lib.inputDialog('Ændre din nuværende pinkode', {
        {type = 'number', label = 'Ny pin-kode', description = 'Skriv din nye pin-kode', icon = 'hashtag', max = 9999},
    })

    if input then
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        ExecuteCommand('e c')
    else
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        ExecuteCommand('e c')
    end

    if input == nil then
        return
    end

    local nyKode = input[1]


    ESX.TriggerServerCallback('th-druglabs:skiftkode', function(data)
        notifyKodeSkiftet(nyKode)
    end, pinkode, id, nyKode)
end

function NyDruglabLevel(index, points)
    ESX.TriggerServerCallback('th-druglabs:getrightxp', function(output)
        local PlayerPed  = GetPlayerServerId(PlayerId())
        if output >= 100 then
            TriggerServerEvent('th-druglabs:resetpoints', PlayerPed, index)
        end
    end, index, points)
end
-- mission slut nydruglab skal også triggers