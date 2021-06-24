Config = {}

Config.progressBars = false -- Using the script progresBars to more interaction

Config.LeaderRank = "boss" -- Rank of the gang leader

Config.MoneyWash = false -- Enable to the gangs wash money

Config.Gangs = {

    Ballas = {
        gangsociety = "society_ballas",
        name = "ballas", -- Gang job name
        Points = {
            Boss = {
                coords = {x = 111.4, y = -1961.12, z = 20.96}, -- Marker coords
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                colorm = {r = 76, g = 40, b = 255}, -- Marker color
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Boss", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the boss actions", -- Help notification
            },

            Weapons = {
                coords = {x = 117.64, y = -1950.0, z = 20.76}, -- Marker coords
                colorm = {r = 76, g = 40, b = 255}, -- Marker color
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Weapons", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the weapons menu", -- Help notification
            },

            Cars = {
                coords = {x = 85.88, y = -1971.52, z = 20.76}, -- Marker coords
                vehiclespawn = {x = 96.72, y = -1956.8, z = 20.72}, -- Coords where vehicle will spawn
                colorm = {r = 76, g = 40, b = 255}, -- Marker color
                heading = 328.28, -- Heading of the vehicle when it spawn
                recogn = "Cars", -- Do not touch this
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                models = { -- Cars that will spawn
                    car1 = "tornado", -- Car 1
                    car2 = "bf400", -- Car 2
                },
                color = {76, 40, 255}, -- IN RGB (if the value is not rgb, will not work). Color vehicle spawn.
                notification = "Press ~INPUT_CONTEXT~ to open the vehicle menu", -- Help notification
            },

            Storage = {
                coords = {x = 102.6, y = -1959.76, z = 20.84}, -- Marker coords
                colorm = {r = 76, g = 40, b = 255}, -- Color of the marker
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001},
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Storage", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the storage", -- Help notification
            },

            VehicleDeleter = {
                coords = {x = 91.56, y = -1964.64, z = 20.76}, -- Marker coords
                colorm = {r = 76, g = 40, b = 255}, -- Color of the marker
                markerbig = {a = 4.0000, b = 4.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 2.5, -- Distance to interact with the marker
                recogn = "Cardelete", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to delete the current vehicle", -- Help notification
            },
        },
        Job = "ballas", -- Gang job name
    },

    Thelost = {
        gangsociety = "society_thelost",
        name = "thelost", -- Gang job name
        Points = {
            Boss = {
                coords = {x = 959.12, y = -121.24, z = 74.96}, -- Marker coords
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                colorm = {r = 0, g = 0, b = 0}, -- Marker color
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Boss", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the boss actions", -- Help notification
            },

            Weapons = {
                coords = {x = 990.8, y = -104.0, z = 74.36}, -- Marker coords
                colorm = {r = 0, g = 0, b = 0}, -- Marker color
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Weapons", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the weapons menu", -- Help notification
            },

            Cars = {
                coords = {x = 977.28, y = -136.88, z = 74.12}, -- Marker coords
                vehiclespawn = {x = 985.4, y = -137.48, z = 73.08}, -- Coords where vehicle will spawn
                colorm = {r = 0, g = 0, b = 0}, -- Marker color
                heading = 60.68, -- Heading of the vehicle when it spawn
                recogn = "Cars", -- Do not touch this
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                models = { -- Cars that will spawn
                    car1 = "daemon", -- Car 1
                    car2 = "nightblade", -- Car 2
                },
                color = {0, 0, 0}, -- IN RGB (if the value is not rgb, will not work). Color vehicle spawn.
                notification = "Press ~INPUT_CONTEXT~ to open the vehicle menu", -- Help notification
            },

            Storage = {
                coords = {x = 973.36, y = -113.36, z = 74.64}, -- Marker coords
                colorm = {r = 0, g = 0, b = 0}, -- Color of the marker
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001},
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Storage", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the storage", -- Help notification
            },

            VehicleDeleter = {
                coords = {x = 955.16, y = -130.8, z = 74.64}, -- Marker coords
                colorm = {r = 0, g = 0, b = 0}, -- Color of the marker
                markerbig = {a = 4.0000, b = 4.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 2.5, -- Distance to interact with the marker
                recogn = "Cardelete", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to delete the current vehicle", -- Help notification
            },
        },
        Job = "thelost", -- Gang job name
    },

    Families = {
        gangsociety = "society_families",
        name = "families",
        Points = {
            Boss = {
                coords = {x = -145.28, y = -1641.6, z = 32.64}, -- Marker coords
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                colorm = {r = 0, g = 230, b = 0}, -- Marker color
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Boss", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the boss actions", -- Help notification
            },

            Weapons = {
                coords = {x = -138.08, y = -1632.88, z = 32.36}, -- Marker coords
                colorm = {r = 0, g = 230, b = 0}, -- Marker color
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Weapons", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the weapons menu", -- Help notification
            },

            Cars = {
                coords = {x = -130.56, y = -1624.24, z = 32.16}, -- Marker coords
                vehiclespawn = {x = -130.56, y = -1624.24, z = 32.16}, -- Coords where vehicle will spawn
                colorm = {r = 0, g = 230, b = 0}, -- Marker color
                heading = 77.36, -- Heading of the vehicle when it spawn
                recogn = "Cars", -- Do not touch this
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                models = { -- Cars that will spawn
                    car1 = "tornado", -- Car 1
                    car2 = "kamacho", -- Car 2
                },
                color = {0, 230, 0}, -- IN RGB (if the value is not rgb, will not work). Color vehicle spawn.
                notification = "Press ~INPUT_CONTEXT~ to open the vehicle menu", -- Help notification
            },

            Storage = {
                coords = {x = -121.76, y = -1614.2, z = 31.92}, -- Marker coords
                colorm = {r = 0, g = 230, b = 0}, -- Color of the marker
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001},
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Storage", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the storage", -- Help notification
            },

            VehicleDeleter = {
                coords = {x = -114.92, y = -1606.28, z = 31.76}, -- Marker coords
                colorm = {r = 0, g = 230, b = 0}, -- Color of the marker
                markerbig = {a = 4.0000, b = 4.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 2.5, -- Distance to interact with the marker
                recogn = "Cardelete", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to delete the current vehicle", -- Help notification
            },
        },
        Job = "families", -- Gang job name
    },

    Vagos = {
        gangsociety = "society_vagos",
        name = "vagos",
        Points = {
            Boss = {
                coords = {x = 314.88, y = -2039.84, z = 20.76}, -- Marker coords
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                colorm = {r = 255, g = 255, b = 0}, -- Marker color
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Boss", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the boss actions", -- Help notification
            },

            Weapons = {
                coords = {x = 330.6, y = -2020.88, z = 21.64}, -- Marker coords
                colorm = {r = 255, g = 255, b = 0}, -- Marker color
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Weapons", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the weapons menu", -- Help notification
            },

            Cars = {
                coords = {x = 313.64, y = -2028.48, z = 20.56}, -- Marker coords
                vehiclespawn = {x = 304.8, y = -2015.88, z = 19.88}, -- Coords where vehicle will spawn
                colorm = {r = 255, g = 255, b = 0}, -- Marker color
                heading = 51.32, -- Heading of the vehicle when it spawn
                recogn = "Cars", -- Do not touch this
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                models = { -- Cars that will spawn
                    car1 = "tornado", -- Car 1
                    car2 = "guardian", -- Car 2
                },
                color = {255, 255, 0}, -- IN RGB (if the value is not rgb, will not work). Color vehicle spawn.
                notification = "Press ~INPUT_CONTEXT~ to open the vehicle menu", -- Help notification
            },

            Storage = {
                coords = {x = 334.32, y = -2023.72, z = 21.72}, -- Marker coords
                colorm = {r = 255, g = 255, b = 0}, -- Color of the marker
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001},
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Storage", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the storage", -- Help notification
            },

            VehicleDeleter = {
                coords = {x = 315.36, y = -2019.96, z = 20.52}, -- Marker coords
                colorm = {r = 255, g = 255, b = 0}, -- Color of the marker
                markerbig = {a = 4.0000, b = 4.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 2.5, -- Distance to interact with the marker
                recogn = "Cardelete", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to delete the current vehicle", -- Help notification
            },
        },
        Job = "vagos", -- Gang job name
    },
    Mafia = {
        gangsociety = "society_mafia",
        name = "mafia",
        Points = {
            Boss = {
                coords = {x = -114.76, y = 985.64, z = 235.76}, -- Marker coords
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                colorm = {r = 255, g = 0, b = 0}, -- Marker color
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Boss", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the boss actions", -- Help notification
            },

            Weapons = {
                coords = {x = -112.72, y = 977.24, z = 235.76}, -- Marker coords
                colorm = {r = 255, g = 0, b = 0}, -- Marker color
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Weapons", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the weapons menu", -- Help notification
            },

            Cars = {
                coords = {x = -120.52, y = 993.28, z = 235.76}, -- Marker coords
                vehiclespawn = {x = -125.72, y = 993.44, z = 235.76}, -- Coords where vehicle will spawn
                colorm = {r = 255, g = 0, b = 0}, -- Marker color
                heading = 51.32, -- Heading of the vehicle when it spawn
                recogn = "Cars", -- Do not touch this
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 1, -- Distance to interact with the marker
                models = { -- Cars that will spawn
                    car1 = "zentorno", -- Car 1
                    car2 = "t20", -- Car 2
                },
                color = {0, 0, 0}, -- IN RGB (if the value is not rgb, will not work). Color vehicle spawn.
                notification = "Press ~INPUT_CONTEXT~ to open the vehicle menu", -- Help notification
            },

            Storage = {
                coords = {x = -112.52, y = 980.04, z = 235.76}, -- Marker coords
                colorm = {r = 255, g = 0, b = 0}, -- Color of the marker
                markerbig = {a = 2.0000, b = 2.0000, c = 0.6001},
                distancetomarker = 1, -- Distance to interact with the marker
                recogn = "Storage", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to open the storage", -- Help notification
            },

            VehicleDeleter = {
                coords = {x = -121.48, y = 983.28, z = 235.8}, -- Marker coords
                colorm = {r = 255, g = 0, b = 0}, -- Color of the marker
                markerbig = {a = 4.0000, b = 4.0000, c = 0.6001}, -- Size of the marker
                distancetomarker = 2.5, -- Distance to interact with the marker
                recogn = "Cardelete", -- Do not touch this
                notification = "Press ~INPUT_CONTEXT~ to delete the current vehicle", -- Help notification
            },
        },
        Job = "mafia", -- Gang job name
    },
    
}
