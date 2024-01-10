Config = {}

Config.Ui = 'radial' -- 'radial' (ox_lib radial menu) -- 'text' (ox_lib textui)

Config.Shells = {

    CokeShell = {
        value = 'coke',
        label = 'Kokain lab',

        -- Shell offsets
        Udgang = vec3(904.2141, -3082.5073, -145.5523),
        Computer = vec3(901.74, -3092.09, -145.55),
        ComputerHeading = 85.9954
    },

    HashShell = {
        value = 'hash',
        label = 'Hash lab',

        -- Shell offsets
        Udgang = vec3(751.0382, -2140.6453, -81.5219),
        Computer = vec3(729.82, -2156.19, -80.52),
        ComputerHeading = 271.4190
    },

    MethShell = {
        value = 'meth',
        label = 'Meth lab',

        -- Shell offsets
        Udgang = vec3(642.7589, -2961.4731, -194.8713),
        Computer = vec3(640.5, -2968.71, -194.87),
        ComputerHeading = 96.8575
    },

}

--Missions
Config.Missions = {
    PEDModel = 'g_m_y_ballaorig_01',
    VehicleSpawnName = 'burrito3',
    Minigame = 'pure_minigame', -- "pure_minigame" (https://github.com/purescripts-fivem/pure-minigames) -- "ox" ox_lib skillcheck
    useT1ger = true, -- Bruger du T1ger_keys?
    VehicleDespawn = 5, -- minutter
    Item = 'lockpick', --Itemet der skal bruges, for at kunne hacke køretøjet

    Mission1 = {
        Price = 100000,
        VehiclesSpawn = {
            vec3(542.9192, -3053.3003, 6.0696),
            vec3(-1314.4203, -1256.9102, 4.5701),
            vec3(788.2706, 1285.0376, 360.3044),
            vec3(616.1477, 2729.2468, 41.8760),
            vec3(890.0698, 3648.7947, 32.8162),
            vec3(1362.4763, 4371.9243, 44.3052)

        },
        XP = 5.2,
        Items = {
            label = 'Sorte penge',
            item = 'black_money', --det item du ønsker man modtager
            antal = 300000 -- antallet af itemet
        }
    },
    Mission2 = {
        Price = 300000,
        VehiclesSpawn = {
            vec3(-410.3676, 1235.8726, 325.6372),
            vec3(1601.4126, 6623.1807, 15.8348),
            vec3(2941.7971, 4648.1694, 48.6277),
            vec3(2982.4775, 3492.9797, 71.3874),
            vec3(2665.8662, 1696.3341, 24.4827),
            vec3(1587.8411, -1717.3237, 88.1163)
        },
        XP = 7.55,
        Items = {
            label = 'Sorte penge',
            item = 'black_money', --det item du ønsker man modtager
            antal = 300000 -- antallet af itemet
        }
    },
    Mission3 = {
        Price = 500000,
        VehiclesSpawn = {
            vec3(1116.6666, -3195.6741, 5.9016),
            vec3(-164.8529, -2551.6121, 5.9994),
            vec3(-940.7399, 304.3731, 71.0109),
            vec3(-79.5410, 185.5811, 87.6579),
            vec3(688.1574, 256.1003, 93.6375),
            vec3(1014.2885, -2331.0042, 30.5840)
        },
        XP = 10.99,
        Items = {
            label = 'Sorte penge',
            item = 'black_money', --det item du ønsker man modtager
            antal = 300000 -- antallet af itemet
        }
    },
}

-- Notify styles
Config.Notify = {
    position = 'right-top',
    Style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
        color = '#909296'
        }
    },
}