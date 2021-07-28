fx_version 'cerulean'
game 'gta5'

author 'Kilichi | Kilichi#0001'
description 'Ks Shop Script'
version '0.1.0'
 
ui_page 'html/index.html'

file {
	'html/*.html',
	'html/*.css',
	'html/*.js'
}

shared_scripts {
	'config/*.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/*.lua'
}
client_scripts {
	'client/*.lua'
}