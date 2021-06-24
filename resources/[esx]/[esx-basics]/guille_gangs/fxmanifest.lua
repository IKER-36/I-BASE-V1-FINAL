fx_version "cerulean"

game "gta5"

version "1.0.0"

author "guillerp#1928"

client_scripts {
    "config.lua",
    "client/client.lua",

}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "webhook.lua",
    "server/server.lua",
}

