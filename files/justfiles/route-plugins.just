route-plugins:
    @echo 'Adding /usr/lib64 to Reaper plugin paths...'

    mkdir ~/.config/REAPER
    touch ~/.config/REAPER/reaper.ini

    sed -i  '/^vstpath=/ s/$/;\/usr\/lib64\/vst3;\/usr\/lib64\/vst/' ~/.config/REAPER/reaper.ini
    sed -i  '/^lv2path=/ s/$/;\/usr\/lib64\/lv2/;' ~/.config/REAPER/reaper.ini
    sed -i  '/^clappath=/ s/$/;\/usr\/lib64\/clap/' ~/.config/REAPER/reaper.ini

    mkdir ~/.vst3
    mkdir ~/.vst

    cp -r /usr/lib64/vst3/* ~/.vst3/
    cp -r /usr/lib64/vst/* ~/.vst/
    @echo 'Paths updated. Please restart Reaper and clear cache/rescan'
