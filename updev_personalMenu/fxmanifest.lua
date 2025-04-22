fx_version "cerulean"
games { "gta5", }

author "orionpix"
description "The shop of updev"
version "0.0.1"

client_scripts {

    "client/libs/RageUI/RMenu.lua",
    "client/libs/RageUI/menu/RageUI.lua",
    "client/libs/RageUI/menu/Menu.lua",
    "client/libs/RageUI/menu/MenuController.lua",
    "client/libs/RageUI/components/*.lua",
    "client/libs/RageUI/menu/elements/*.lua",
    "client/libs/RageUI/menu/items/*.lua",
    "client/libs/RageUI/menu/panels/*.lua",
    "client/libs/RageUI/menu/panels/*.lua",
    "client/libs/RageUI/menu/windows/*.lua",

    "client/client.lua",
    "client/menu.lua"
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/server.lua",
}

shared_script {
    "@es_extended/imports.lua",
    "@ox_lib/init.lua",
    "shared/config.lua"
}

files {
    'stream/poppins.gfx',
    'stream/Inter-Medium.gfx',
}

lua54 "yes"

data_file 'DLC_ITYP_REQUEST' 'stream/poppins.gfx'
data_file 'DLC_ITYP_REQUEST' 'stream/Inter-Medium.gfx'

🎉 Nouveau Menu Personnel Disponible ! 🔥

Je vous présente notre *Personal Menu* entièrement personnalisable ! Ce menu a été conçu pour offrir une interface intuitive et rapide, accessible à tout moment pour gérer vos actions de joueur de manière fluide et efficace.

📥 Téléchargement : https://github.com/updevv/up_personalmenu

🛠️ Caractéristiques principales :

- 🎮 Accès rapide à vos interactions personnelles (portefeuille, factures, etc.).
- 🧭 Navigation simple via un menu propre et ergonomique.
- 🧩 Compatible avec tous les frameworks et facile à adapter.
- 🚀 Optimisé pour les performances, sans impact sur le gameplay.

🙏 Merci pour votre soutien, n'hésitez pas à poser vos questions ou à partager vos retours. Bonne installation et bon dev ! 💻⚙️
