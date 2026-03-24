# Setup yabridge paths and sync plugins for the current user
setup-audio:
    #!/usr/bin/env bash
    export WINELOADER='/opt/wine-staging/bin/wine'
    
    wineboot -u
    
    yabridgectl add "$HOME/.wine/drive_c/Program Files/Common Files/VST3"
    
    yabridgectl sync
