local mission1Started = false
local mission2Started = false
local mission3Started = false
local targetZone
local blip
local CollectMoney

function StopAnimation()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    ExecuteCommand('e c')
end

function MissionerMenu(index, lvl)
    local ped = PlayerPedId()
    local mission1 = true
    local mission2 = true
    local mission3 = true

    if lvl >= '0' then
        mission1 = false
    end

    if lvl >= '2' then
        mission2 = false
    end

    if lvl >= '4' then
        mission3 = false
    end


    lib.registerContext({
        id = 'mission_menu',
        title = 'Missioner',
        menu = 'druglab_pc',
        onExit = function()
            FreezeEntityPosition(ped, false)
            ExecuteCommand('e c')
        end,
        options = {
          {
            title = 'Nuværende Level | '..lvl,
            readOnly = true
          },
          {
            title = 'Mission #1',
            description = 'Denne mission er forbeholdt til et lavt lvl for drug labbet. \nPris: 100.000 DKK \nFlere instrukser vil forekomme',
            disabled = mission1,
            icon = 'battery-empty',
            onSelect = function()
                ESX.TriggerServerCallback('th-druglabs:checkCooldown', function(cooldown)
                    if not cooldown then
                        notifyCooldown()
                    else
                        AreYouSure(Config.Missions.Mission1.Price, 1, index)
                    end
                end, index)
            end 
          },
          {
            title = 'Mission #2',
            description = 'Denne mission er forbeholdt til et mellemt lvl for drug labbet. \nPris: 300.000 DKK \nFlere instrukser vil forekomme',
            disabled = mission2,
            icon = 'battery-half',
            onSelect = function()
                ESX.TriggerServerCallback('th-druglabs:checkCooldown', function(canExecute, remainingHours, remainingMinutes)
                    if canExecute then
                        AreYouSure(Config.Missions.Mission2.Price, 2, index)
                    else
                        notifyCooldown(remainingHours, remainingMinutes)
                    end
                end, Config.Missions.Mission2.Cooldown.Timer, Config.Missions.Mission2.Cooldown.Minutter, index)
            end 
          },
          {
            title = 'Mission #3',
            description = 'Denne mission er forbeholdt til et højt lvl for drug labbet. \nPris: 500.000 DKK \nFlere instrukser vil forekomme',
            disabled = mission3,
            icon = 'battery-full',
            onSelect = function()
                ESX.TriggerServerCallback('th-druglabs:checkCooldown', function(canExecute, remainingHours, remainingMinutes)
                    if canExecute then
                        AreYouSure(Config.Missions.Mission3.Price, 3, index)
                    else
                        notifyCooldown(remainingHours, remainingMinutes)
                    end
                end, Config.Missions.Mission3.Cooldown.Timer, Config.Missions.Mission3.Cooldown.Minutter, index)
            end 
          }
        }
      })
      lib.showContext('mission_menu')
end

function AreYouSure(price, mission, index)
    local alert = lib.alertDialog({
        header = 'Start en mission',
        content = 'Er du sikker på at du gerne vil starte missionen?  \n Det koster som sagt '..price..' kr. at starte!',
        centered = true,
        cancel = true,
        labels = {
            cancel = 'Afbryd',
            confirm = 'Er sikker!'
        }
    })

    if alert == 'confirm' then
        StopAnimation()
        ESX.TriggerServerCallback('th-druglabs:tjekmoney', function(HasMoney)
            if HasMoney then
                TriggerServerEvent('th-druglabs:triggercooldown', index)
                if mission == 1 then
                    Mission(index)
                    mission1Started = true
                elseif mission == 2 then
                    Mission(index)
                    mission2Started = true
                elseif mission == 3 then
                    Mission(index)
                    mission3Started = true
                end
            else
                notifyIngenPenge()
                StopAnimation()
            end
        end, price)
    else
        StopAnimation()
    end

end

function Mission(index)
    Citizen.CreateThread(function()
        if mission1Started then
            while true do
                Citizen.Wait(1000)
                CreateTemporaryVehicle(index)
                break
            end    
        end

        if mission2Started then
            while true do
                Citizen.Wait(1000)
                CreateTemporaryVehicle(index)
                break
            end    
        end

        if mission3Started then
            while true do
                Citizen.Wait(1000)
                CreateTemporaryVehicle(index)
                break
            end    
        end
    end)
end

function CreateTemporaryVehicle(index)
    local randomSpawn1 = Config.Missions.Mission1.VehiclesSpawn[math.random(1, #Config.Missions.Mission1.VehiclesSpawn)]
    local randomSpawn2 = Config.Missions.Mission2.VehiclesSpawn[math.random(1, #Config.Missions.Mission2.VehiclesSpawn)]
    local randomSpawn3 = Config.Missions.Mission3.VehiclesSpawn[math.random(1, #Config.Missions.Mission3.VehiclesSpawn)]
    local vehicle
    local mission = nil

    Citizen.Wait(10000)

    if mission1Started then
        SetNewWaypoint(randomSpawn1)
        blip = AddBlipForCoord(randomSpawn1)
        CreateBlip()
        notifyBlipSendt()
        Citizen.CreateThread(function()
            while true do
                local ped = PlayerPedId()
                local pCoords = GetEntityCoords(ped)
                local distance = #(pCoords - randomSpawn1)
                if distance <= 100.0 then
                    DeleteVehiclesInRadius(randomSpawn1, 20)
                    ESX.Game.SpawnVehicle(Config.Missions.VehicleSpawnName, randomSpawn1, 100.0, function(vehicle)
                        CreateTarget(randomSpawn1, vehicle, index, blip)
                        SpawnGuardsNearVehicle(vehicle, 1)
                        if Config.Missions.useT1ger then
                            exports['t1ger_keys']:SetVehicleLocked(vehicle, 2)
                        else
                            SetVehicleDoorsLocked(vehicle, 2)
                        end
                    end)
                    print('vehicle spawned')
                    break
                end
                Citizen.Wait(1000)
            end
        end)
    elseif mission2Started then
        SetNewWaypoint(randomSpawn2)
        blip = AddBlipForCoord(randomSpawn2)
        CreateBlip()
        notifyBlipSendt()
        Citizen.CreateThread(function()
            while true do
                local ped = PlayerPedId()
                local pCoords = GetEntityCoords(ped)
                local distance = #(pCoords - randomSpawn2)
                if distance <= 100.0 then
                    ESX.Game.SpawnVehicle(Config.Missions.VehicleSpawnName, randomSpawn2, 100.0, function(vehicle)
                        CreateTarget(randomSpawn2, vehicle, index, blip)
                        SpawnGuardsNearVehicle(vehicle, 2)
                        if Config.Missions.useT1ger then
                            exports['t1ger_keys']:SetVehicleLocked(vehicle, 2)
                        else
                            SetVehicleDoorsLocked(vehicle, 2)
                        end
                    end)
                    print('vehicle spawned')
                    break
                end
                Citizen.Wait(1000)
            end
        end)
    elseif mission3Started then
        SetNewWaypoint(randomSpawn3)
        blip = AddBlipForCoord(randomSpawn3)
        CreateBlip()
        notifyBlipSendt()
        Citizen.CreateThread(function()
            while true do
                local ped = PlayerPedId()
                local pCoords = GetEntityCoords(ped)
                local distance = #(pCoords - randomSpawn3)
                if distance <= 100.0 then
                    ESX.Game.SpawnVehicle(Config.Missions.VehicleSpawnName, randomSpawn3, 100.0, function(vehicle)
                        CreateTarget(randomSpawn3, vehicle, index, blip)
                        SpawnGuardsNearVehicle(vehicle, 3)
                        if Config.Missions.useT1ger then
                            exports['t1ger_keys']:SetVehicleLocked(vehicle, 2)
                        else
                            SetVehicleDoorsLocked(vehicle, 2)
                        end
                    end)
                    print('vehicle spawned')
                    break
                end
                Citizen.Wait(1000)
            end
        end)
    end
end

function CreateBlip()
    SetBlipSprite(blip, 67)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName('Køretøj')
    EndTextCommandSetBlipName(blip)
end

function SpawnGuardsNearVehicle(vehicle, mission)
    local pedCoords = GetEntityCoords(vehicle)

    local modelHash = Config.Missions.PEDModel
    RequestModel(modelHash)

    while not HasModelLoaded(modelHash) do
        Wait(500)
    end

    if mission == 1 then
        for i = 1, 4 do
            CreateThread(function()
                local angle = math.rad(i * 90)
                local radius = 5.0
                local pedX = pedCoords.x + radius * math.cos(angle)
                local pedY = pedCoords.y + radius * math.sin(angle)
                local ped = CreatePed(4, modelHash, pedX, pedY, pedCoords.z, 0.0, true, false)
            
                SetPedCombatAttributes(ped, 46, true)
                SetPedCombatAttributes(ped, 5, true)
                SetPedCombatAttributes(ped, 1, true)
            
            
                GiveWeaponToPed(ped, GetHashKey("WEAPON_BAT"), 1000, false, true)
                AddRelationshipGroup('Mission1')
                SetPedArmour(ped, 100)
                SetPedAsEnemy(ped, true)
                SetPedRelationshipGroupHash(ped, 'Mission1') 
                TaskCombatPed(ped, GetPlayerPed(-1))
                SetPedDropsWeaponsWhenDead(ped, false)
                SetPedAccuracy(ped, 100)

            end)
        end
        
    elseif mission == 2 then
        for i = 1, 5 do
            CreateThread(function()
                local angle = math.rad(i * 90)
                local radius = 5.0
                local pedX = pedCoords.x + radius * math.cos(angle)
                local pedY = pedCoords.y + radius * math.sin(angle)
                local ped = CreatePed(4, modelHash, pedX, pedY, pedCoords.z, 0.0, true, false)
            
                SetPedCombatAttributes(ped, 46, true)
                SetPedCombatAttributes(ped, 5, true)
                SetPedCombatAttributes(ped, 1, true)
            
            
                GiveWeaponToPed(ped, GetHashKey("WEAPON_PISTOL"), 1000, false, true)
                AddRelationshipGroup('Mission2')
                SetPedArmour(ped, 100)
                SetPedAsEnemy(ped, true)
                SetPedRelationshipGroupHash(ped, 'Mission2') 
                TaskCombatPed(ped, GetPlayerPed(-1))
                SetPedDropsWeaponsWhenDead(ped, false)
                SetPedAccuracy(ped, 100)

            end)
        end
    elseif mission == 3 then
        for i = 1, 6 do
            CreateThread(function()
                local angle = math.rad(i * 90)
                local radius = 5.0
                local pedX = pedCoords.x + radius * math.cos(angle)
                local pedY = pedCoords.y + radius * math.sin(angle)
                local ped = CreatePed(4, modelHash, pedX, pedY, pedCoords.z, 0.0, true, false)
            
                SetPedCombatAttributes(ped, 46, true)
                SetPedCombatAttributes(ped, 5, true)
                SetPedCombatAttributes(ped, 1, true)
            
            
                GiveWeaponToPed(ped, GetHashKey("WEAPON_MACHINEPISTOL"), 1000, false, true)
                AddRelationshipGroup('Mission3')
                SetPedArmour(ped, 100)
                SetPedAsEnemy(ped, true)
                SetPedRelationshipGroupHash(ped, 'Mission3') 
                TaskCombatPed(ped, GetPlayerPed(-1))
                SetPedDropsWeaponsWhenDead(ped, false)
                SetPedAccuracy(ped, 100)

            end)
        end
    end
end

function CreateTarget(coord, vehicle, index, blip)
    targetZone = exports.ox_target:addSphereZone({
        coords = coord, 
        radius = 2,
        debug = drawZones,
        options = {
            {
                icon = 'fa-solid fa-car',
                label = 'Knæk køretøjet op',
                distance = 10,
                onSelect = function()
                    ESX.TriggerServerCallback('th-druglabs:tjeklockpick', function(item)
                        if item then
                            HackVehicle(vehicle, index, blip)
                        else
                            notifyMangler()
                        end
                    end)
                end,
                canInteract = function()
                    if mission1Started then
                        return true
                    elseif mission2Started then
                        return true
                    elseif mission3Started then
                        return true
                    else
                        return false
                    end
                end 
            },
        }
    })
end


function HackVehicle(vehicle, index, blip)
    local minigame
    local PlayerPed = GetPlayerServerId(PlayerId())

    ClethedTasks(PlayerPedId())
    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_STAND_MOBILE', -1, true)
    if lib.progressCircle({
        duration = 20000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
    }) then

        if Config.Missions.Minigame == 'pure_minigame' then
            minigame = exports['pure-minigames']:numberCounter({
                totalNumbers = 15,
                seconds = 20,
                timesToChangeNumbers = 4,
                amountOfGames = 2,
                incrementByAmount = 5,
            })
        elseif Config.Missions.Minigame == 'ox' then
            minigame = lib.skillCheck({'medium', 'hard', 'hard', 'hard', 'hard', 'medium', 'easy'}, {'e'})
        end
    
        if minigame then
            ClethedTasks(PlayerPedId())
            RemoveBlip(blip)
            if not CollectMoney then
                local trunkpos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "platelight"))
                local heading = GetEntityHeading(vehicle)
                TaskGoStraightToCoord(PlayerPedId(), trunkpos, 0, -1, heading, 1)
                Wait(3500)
                SetVehicleDoorOpen(vehicle, 2, false, false)
                SetVehicleDoorOpen(vehicle, 3, false, false)
                CollectMoney = true
                Wait(1000)
                if lib.progressCircle({
                    duration = 10000,
                    canCancel = true,
                    anim = {
                        dict = 'anim@heists@ornate_bank@grab_cash',
                        clip = 'grab'
                    },
                    prop = {
                        model = `p_ld_heist_bag_s`,
                        bone = 40269,
                        pos = vec3(0.0554, 0.2531, -0.1887),
                        rot = vec3(60.4762, 7.2424, -71.9051)
                    },
                }) then ClethedTasks(PlayerPedId()) Rewards(vehicle, index, blip) end

            end
        else
            notifyDuFejledeMinigamet()
            ClethedTasks(PlayerPedId())
        end
    else 
        ClethedTasks(PlayerPedId())
        notifyStoppetProgress()
    end

end

function Rewards(vehicle, index, blip)
    local PlayerPed = GetPlayerServerId(PlayerId())
    CollectMoney = false
    if mission1Started then
        NyDruglabLevel(index, Config.Missions.Mission1.XP)
        exports.ox_target:removeZone(targetZone)
        TriggerServerEvent('th-druglab:reward', 1, PlayerPed, Config.Missions.Mission1.XP)
        mission1Started = false
        RemoveSpawnedVehicle(vehicle)
    elseif mission2Started then
        NyDruglabLevel(index, Config.Missions.Mission2.XP)
        exports.ox_target:removeZone(targetZone)
        TriggerServerEvent('th-druglab:reward', 1, PlayerPed, Config.Missions.Mission2.XP)
        mission2Started = false
        RemoveSpawnedVehicle(vehicle)
        notifyPoint()
    elseif mission3Started then
        NyDruglabLevel(index, Config.Missions.Mission3.XP)
        exports.ox_target:removeZone(targetZone)
        TriggerServerEvent('th-druglab:reward', 1, PlayerPed, Config.Missions.Mission3.XP)
        mission3Started = false
        RemoveSpawnedVehicle(vehicle)
        notifyPoint()
    end
end

function RemoveSpawnedVehicle(vehicle)
    Wait(Config.Missions.VehicleDespawn * 60000)
    ESX.Game.DeleteVehicle(vehicle)
end

function DeleteVehiclesInRadius(coords, radius)
    local vehicles = ESX.Game.GetVehiclesInArea(coords, radius)
    for _, vehicle in pairs(vehicles) do
        ESX.Game.DeleteVehicle(vehicle)
    end
end


--exports['pure-minigames']:numberCounter(gameData)