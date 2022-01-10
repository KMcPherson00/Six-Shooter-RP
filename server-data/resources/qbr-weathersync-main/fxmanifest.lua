fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'vSyncRevamped'
version '1.0.2'

shared_scripts {
	'locale.lua',
	'locales/en.lua',
	'config.lua'
}

server_scripts {
	'server/server.lua'
}

client_scripts {
	'client/client.lua'
}
