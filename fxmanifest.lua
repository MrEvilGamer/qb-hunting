fx_version 'cerulean'
game 'gta5'

client_script {
	'client/main.lua'
}

shared_script 'shared/config.lua',

shared_script {
	'@qb-core/import.lua',
	'shared/config.lua'
}

server_script {
	'server/main.lua'
}