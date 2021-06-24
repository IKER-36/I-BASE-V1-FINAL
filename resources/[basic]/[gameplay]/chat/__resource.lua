fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'CanarioTM - ! canario™#0001'
description 'CanarioTM_Chat'
version '1.2.0'

client_scripts       {'client/*.lua'} -- CLIENT_SCRIPTS 
server_scripts     {'server/*.lua'} -- SERVER_SCRIPTS

ui_page 'html/index.html' -- PAGINA HOST

files {
    '**/**/*.css', -- CSS DETECTOR AND VENDOR
    '**/**/*.ttf','**/**/*.otf', -- FONT STYLES
    '**/**/*.js',   -- JS SCRIPTS
    '**/**/**/*.woff2', -- VENDORS THEMES
    '**/*.html' -- INDEX.HTML - DONT QUIT THIS
}