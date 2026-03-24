first-run:
    usermod -aG audio $USER

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete

    {echo 'plugins=(git'
    echo 'zsh-autosuggestions'
    echo 'zsh-syntax-highlighting'
    echo 'fast-syntax-highlighting'
    echo 'zsh-autocomplete'
    echo ')'
    } >> ~/.zshrc

    @echo 'eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/json.omp.json')"' >> ~/.zshrc

    @echo 'Adding /usr/lib64 to Reaper plugin paths...'

    mkdir ~/.config/REAPER
    touch ~/.config/REAPER/reaper.ini

    sed -i  '/^vstpath=/ s/$/;\/usr\/lib64\/vst3;\/usr\/lib64\/vst/' ~/.config/REAPER/reaper.ini
    sed -i  '/^lv2path=/ s/$/;\/usr\/lib64\/lv2/;' ~/.config/REAPER/reaper.ini
    sed -i  '/^clappath=/ s/$/;\/usr\/lib64\/clap/' ~/.config/REAPER/reaper.ini

    @echo 'Paths updated. Please restart Reaper and clear cache/rescan'

    export WINELOADER='/opt/wine-staging/bin/wine'

    wineboot -u

    yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/VST3"

    yabridgectl sync
