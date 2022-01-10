Config                  = {}
Config.DynamicWeather   = true -- Set this to false if you don't want the weather to change automatically every 10 minutes.

-- On server start
Config.StartWeather     = 'SUNNY' -- Default weather                       default: 'SUNNY'
Config.BaseTime         = 0 -- Time                                             default: 8
Config.TimeOffset       = 0 -- Time offset                                      default: 0
Config.FreezeTime       = false -- freeze time                                  default: false
Config.Blackout         = false -- Set blackout                                 default: false
Config.BlackoutVehicle  = false -- Set blackout affects vehicles                default: false
Config.NewWeatherTimer  = 1 -- Time (in minutes) between each weather change   default: 10
Config.Disabled         = false -- Set weather disabled                         default: false

Config.Locale           = 'en' -- Languages : en, fr, pt, tr, pt_br

Config.AvailableWeatherTypes = { -- DON'T TOUCH EXCEPT IF YOU KNOW WHAT YOU ARE DOING
    "BLIZZARD",
    "CLOUDS",
    "DRIZZLE",
    "FOG",
    "GROUNDBLIZZARD",
    "HAIL",
    "HIGHPRESSURE",
    "HURRICANE",
    "MISTY",
    "OVERCAST",
    "OVERCASTDARK",
    "RAIN",
    "SANDSTORM",
    "SHOWER",
    "SLEET",
    "SNOW",
    "SNOWCLEARING",
    "SNOWLIGHT",
    "SUNNY",
    "THUNDER",
    "THUNDERSTORM",
    "WHITEOUT",
}