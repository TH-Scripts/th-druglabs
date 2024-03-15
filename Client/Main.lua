local DruglabLocation
local RadialIsShowing = false
local currentIndex = nil
local isBoss = false
local isInDruglab
local ox_inventory = exports.ox_inventory
local omdan = ''


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

function OmdanEnter(self)
    if Config.Ui == 'radial' then
        if not RadialIsShowing then
            lib.addRadialItem({
                id = 'omdan_enter',
                icon = 'recycle',
                label = 'Omdan',
                onSelect = function()
                    StartOmdannelse(self.index)
                end
            })
            RadialIsShowing = true
        end
    elseif Config.Ui == 'text' then
        lib.showTextUI('[E] - Omdan')
        Citizen.CreateThread(function()
            while true do
                Wait(1)
                if IsControlJustPressed(0, 38) then
                    Wait(100)
                    StartOmdannelse(self.index)
                    break
                end
            end
        end)
    end
end

function OmdanExit(self)
    if Config.Ui == 'radial' then
        if RadialIsShowing then
            lib.removeRadialItem('omdan_enter')
            RadialIsShowing = false
        end
    elseif Config.Ui == 'text' then
        lib.hideTextUI()
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
                        distance = 3,
                        onEnter = onEnter,
                        onExit = onExit
                    })
                end
            end
        end)

        for _, v in pairs(Config.Shells) do
            if v.value == Config.Shells.HashShell.value then
                lib.points.new({
                    index = Config.Shells.HashShell.value,
                    coords = Config.Shells.HashShell.Omdan.omdanLokation,
                    distance = 2,
                    onEnter = OmdanEnter,
                    onExit = OmdanExit
                })
            elseif v.value == Config.Shells.CokeShell.value then
                lib.points.new({
                    index = Config.Shells.CokeShell.value,
                    coords = Config.Shells.CokeShell.Omdan.omdanLokation,
                    distance = 2,
                    onEnter = OmdanEnter,
                    onExit = OmdanExit
                })
            elseif v.value == Config.Shells.MethShell.value then
                lib.points.new({
                    index = Config.Shells.MethShell.value,
                    coords = Config.Shells.MethShell.Omdan.omdanLokation,
                    distance = 2,
                    onEnter = OmdanEnter,
                    onExit = OmdanExit
                })
            end
        end

        ESX.TriggerServerCallback('arp-druglabs:getpincodes', function(data)
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
                    if data == Config.Shells.CokeShell.value then
                        SetEntityCoords(ped, Config.Shells.CokeShell.Udgang)
                    elseif data == Config.Shells.HashShell.value then
                        SetEntityCoords(ped, Config.Shells.HashShell.Udgang)
                    elseif data == Config.Shells.MethShell.value then
                        SetEntityCoords(ped, Config.Shells.MethShell.Udgang)
                    end
                    TriggerServerEvent('arp-druglabs:enterrouting', index, PlayerPed)
                    TriggerEvent('arp-druglabs:captureindex', index)
                    if v.stash == 'false' then
                        TriggerServerEvent('arp-druglabs:loadstash', index)
                        print('stashed created')
                    end
                end, index)
            else
                notifyForkertKode()
            end
        end
       end
    end)
end

function StartOmdannelse(value) 
    omdan = true
    local player = PlayerPedId()

    if omdan then
        lib.removeRadialItem('omdan_enter')
        lib.addRadialItem({
            id = 'omdan_exit',
            icon = 'circle-xmark',
            label = 'Stop Omdan',
            onSelect = function()
                omdan = false
                Wait(100)
                FreezeEntityPosition(player, false)
                ExecuteCommand('e c')
                lib.hideTextUI()
                lib.removeRadialItem('omdan_exit')
            end
        })
    end
    ExecuteCommand('e parkingmeter')
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            if omdan then
                local player = PlayerPedId()
                FreezeEntityPosition(player, true)
                TextUi('Stop omdan', 'recycle', '#06915a')
                Wait(math.random(1000, 5000))
                local success = lib.skillCheck({'easy', 'easy'}, {'g'})
                ESX.TriggerServerCallback('arp-druglab:tjekOmdanItem', function(gotItem)
                    if gotItem then
                        if success then
                            TriggerServerEvent('arp-druglab:giveItem', value, omdan, 'success')
                            print('success')
                        else
                            TriggerServerEvent('arp-druglab:giveItem', value, omdan, 'failed')
                        end
                    else
                        omdan = false
                        Wait(100)
                        FreezeEntityPosition(player, false)
                        ExecuteCommand('e c')
                        lib.hideTextUI()
                        notifyNotItem()
                        lib.removeRadialItem('omdan_exit')
                    end
                end, value, omdan)
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
            
            local vCoordsStr = index
            local xValue, yValue, zValue = extractCoordinates(vCoordsStr)
            SetEntityCoords(ped, xValue, yValue, zValue)
            TriggerServerEvent('arp-druglabs:exitrouting', PlayerPed)
    end, index)
end

RegisterNetEvent('arp-druglabs:captureindex', function(index)
    currentIndex = index
end)

RegisterNetEvent('arp-druglab:createdruglab', function()
    ESX.TriggerServerCallback('arp-druglabs:getPlayers', function(data)
        local playerOptions = {}
        local shellOptions = {}
    
        for _, playerData in pairs(data) do
            table.insert(playerOptions, {value = playerData.identifier, label = '['..playerData.source..'] '..playerData.name})
        end
    
    
        for _, v in pairs(Config.Shells) do
            table.insert(shellOptions, {value = v.value, label = v.label})
        end
    
    
        local input = lib.inputDialog('Lav et druglab', {
            {type = 'select', label = 'Vælg et druglab - shell', options = shellOptions, icon = 'home', required = true},
            {type = 'number', label = 'Pin-kode', description = 'Skriv den midlertige pinkode', icon = 'hashtag', max = 9999, required = true},
            {type = 'select', label = 'Vælg ejeren', description = 'Vælg ejeren af druglabbet', options = playerOptions, icon = 'user', required = true},
            {type = 'checkbox', label = 'Nuværende coords som indgang', required = true},
        })
        
        local PlayerPed  = GetPlayerServerId(PlayerId())
        
        if input == nil then
            return 
        end
        
        local identifier = input[3]
    
        
        if input[1] == 'coke' then
            local lab = 'coke'
            TriggerServerEvent('arp-druglab:creatingdruglab', input[2], lab, PlayerPed, identifier)
        elseif input[1] == 'hash' then
            local lab = 'hash'
            TriggerServerEvent('arp-druglab:creatingdruglab', input[2], lab, PlayerPed, identifier)
        elseif input[1] == 'meth' then
            local lab = 'meth'
            TriggerServerEvent('arp-druglab:creatingdruglab', input[2], lab, PlayerPed, identifier)
        end
    
    end)
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
                    ESX.TriggerServerCallback('arp-druglab:tjekpcaccess', function(CanAccess)
                        if CanAccess then
                            print('virker')
                            local ped = PlayerPedId()
                            local pCoords = GetEntityCoords(ped)
                            local distance = #(pCoords - v.Computer)
                            if distance < 1 then
                                FreezeEntityPosition(ped, true)
                                ExecuteCommand('e type')
                                DrugLabPc(currentIndex) 
                            else
                                TaskGoStraightToCoord(ped, v.Computer, 0, -1, v.ComputerHeading, -1)
                                Wait(2500)
                                FreezeEntityPosition(ped, true)
                                ExecuteCommand('e type')
                                DrugLabPc(currentIndex)
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
    DrugLabPc(46)
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
                        title = 'Stash',
                        description = 'Tilgå dit druglab stash',
                        icon = 'box-archive',
                        onSelect = function()
                            local stashOpen = json.encode(currentIndex)
                            ox_inventory:openInventory('stash', {id=stashOpen})
                            StopAnimation()
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

    ESX.TriggerServerCallback('arp-druglabs:getpincodes', function(data)
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
                    }
                })
            end
        end
        lib.showContext('druglab_settings')
    end)
end

function Medlemmer(index)
    lib.registerContext({
        id = 'members',
        title = 'Medlemmer',
        options = {
            {
                title = 'Tilføj nyt medlem',
                onSelect = function()
                    addMember(index)
                end
            },
            {
                title = 'Medlemsliste',
                onSelect = function()
                    GetMembers(index)
                end
            }
        }
    })
end

function addMember(index)
    
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


    ESX.TriggerServerCallback('arp-druglabs:skiftkode', function(data)
        notifyKodeSkiftet(nyKode)
    end, pinkode, id, nyKode)
end

function NyDruglabLevel(index, points)
    ESX.TriggerServerCallback('arp-druglabs:getrightxp', function(output)
        local PlayerPed  = GetPlayerServerId(PlayerId())
        if output >= 100 then
            TriggerServerEvent('arp-druglabs:resetpoints', PlayerPed, index)
        end
    end, index, points)
end
-- mission slut nydruglab skal også triggers