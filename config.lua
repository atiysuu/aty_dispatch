Config = {
    Framework = "qb", -- qb / esx

    UseGPS = true, -- Players will receive an alert if only they have a gps 
    GPSItem = "gps",

    SetWaypoingKey = "G",

    WaitTimes = { -- Cooldown after a dispatch to send another one.
        Shooting = 45, -- Seconds
        Speeding = 60, -- Seconds
    },

    Enable = { -- Enable or disable built-in dispatches
        Speeding = true,
        Shooting = true,
        PlayerDeath = true,
    },

    WhitelistedJobs = { -- Jobs that won't going to give an alert.
        "police",
        "sheriff",
        "ambulance"
    },

    BlipRemoveTime = 30, -- Seconds

    Notification = function(title, message, type, length)
        -- Your notification here
    end,

    BlackListedWeapons = { -- Weapons that wont give andalert
        'WEAPON_STUNGUN',
        'WEAPON_BZGAS',
        'WEAPON_SNOWBALL',
        'WEAPON_MOLOTOV',
        'WEAPON_FLARE',
        'WEAPON_BALL',
        'WEAPON_PETROLCAN',
        'WEAPON_HAZARDCAN',
        'WEAPON_FIREEXTINGUISHER',
    }
}