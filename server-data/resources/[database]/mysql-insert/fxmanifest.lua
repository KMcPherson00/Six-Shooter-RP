fx_version 'cerulean'
game 'rdr3'

author 'K. McPherson'
description 'SixShooterRP database'
version '1.0.0'

client_script 'client.lua'

server_scripts {
	'server.lua',
	'@mysql-async/lib/MySQL.lua'
}

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'