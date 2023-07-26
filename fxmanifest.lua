fx_version 'cerulean'
game 'gta5'
author 'atiysu'
lua54 'yes'

shared_scripts{
    'config.lua'
}

client_scripts {
    'client/utils.lua',
    'client/weapons.lua',
    'client/colors.lua',
    'client/client.lua',
}

server_scripts {
    'server/server.lua',
}

ui_page 'ui/index.html'

files {
    'ui/**/*.*',
    'ui/*.*',
}

export 'SendDispatch'