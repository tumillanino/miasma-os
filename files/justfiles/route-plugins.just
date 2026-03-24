route-plugins:
    @echo 'Adding /usr/lib64 to Reaper plugin paths...'

    mkdir ~/.config/REAPER
    touch ~/.config/REAPER/reaper.ini

    sed -i  '/^vstpath=/ s/$/;\/usr\/lib64\/vst3;\/usr\/lib64\/vst/' ~/.config/REAPER/reaper.ini
    sed -i  '/^lv2path=/ s/$/;\/usr\/lib64\/lv2/;' ~/.config/REAPER/reaper.ini
    sed -i  '/^clappath=/ s/$/;\/usr\/lib64\/clap/' ~/.config/REAPER/reaper.ini

    @echo 'Paths updated. Please restart Reaper and clear cache/rescan'
