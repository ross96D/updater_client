# WTF

Fork xdg_directories dependency and fix it (we need to fork path_provider to change the xdg_directories dependency).. because is using external commands like xdg-user-dir wich is completely unnecessary and could break in a system without it... the spec is enough :)
