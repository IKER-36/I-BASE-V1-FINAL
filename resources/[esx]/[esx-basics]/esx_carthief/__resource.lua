resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Car Thief'

version '1.0.0'

server_scripts {
    '@es_extended/locale.lua',
	'config.lua',
	'server/*.lua',
	'locales/en.lua',
	'locales/es.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/*.lua',
	'locales/en.lua',
	'locales/es.lua'
}

dependency 'es_extended'
