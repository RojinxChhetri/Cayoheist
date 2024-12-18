fx_version 'cerulean'
games {'gta5'}
version '1.0'
lua54 'yes'
description 'Cayo Perico heist by Rojin'

shared_scripts {
    'config.lua'
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    '@mka-lasers/client/client.lua',
    'client/*.lua',
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}
