fx_version 'cerulean'

game 'gta5'
description 'ARP - Druglabs'
version '1.10.2'
lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    '@es_extended/imports.lua'
}

server_scripts {
	'Server/*',
    '@oxmysql/lib/MySQL.lua'
}

client_scripts {
    'Client/*'
}