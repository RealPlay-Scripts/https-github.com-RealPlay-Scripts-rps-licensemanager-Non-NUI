fx_version 'cerulean'
game 'gta5'

author 'Unscalable'
description 'Realplay Scripts License Manager - Grant/Revoke licenses for QBCore using police/admin permissions'
version '0.1'

-- ✅ Dependencies
dependency 'ox_lib'
dependency 'oxmysql'
dependency 'qb-core'

shared_script {
    '@ox_lib/init.lua',
}


client_scripts {
	'client/**.lua',
}

server_scripts {
	'server/**.lua',
}

-- ✅ SQL Integration
lua54 'yes'
