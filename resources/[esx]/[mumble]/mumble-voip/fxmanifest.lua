fx_version "adamant"
game "gta5"

name "mumble-voip"
description "A tokovoip replacement that uses fivems mumble voip"
author "Frazzle (frazzle9999@gmail.com)"
version "1.3"

ui_page "ui/index.html"

files {
	"ui/*.html",
	"ui/*.ogg",
	"ui/*.otf",
	"ui/*.ttf"
}

shared_scripts {
	"config.lua",
}

client_scripts {
    "client.lua",
}

server_scripts {
    "server.lua",
}

provide "tokovoip_script"