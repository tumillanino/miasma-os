# Miasma OS &nbsp; [![bluebuild build badge](https://github.com/tumillanino/miasma-os/actions/workflows/build.yml/badge.svg)](https://github.com/tumillanino/miasma-os/actions/workflows/build.yml)

<p align="center">
  <a href="https://github.com/tumillanino/miasma-os">
    <img src="https://raw.githubusercontent.com/tumillanino/miasma-os/refs/heads/main/docs/logo.png"  width=180 />
  </a>
</p>

## About
Miasma OS is a [Fedora Atomic desktop](https://fedoraproject.org/atomic-desktops/) built with love on top of a Bazzite base. It is a spin aimed at music producers and musicians utilising features found in [Fedora Jam Lab](https://fedoraproject.org/labs/jam/), [Av Linux](https://www.bandshed.net/avlinux/) and [Ubuntu Studio](https://ubuntustudio.org/) but on an immutable base thanks to [Bazzite](https://bazzite.gg/) and [Universal blue](https://universal-blue.org/).

## Some features and packages

### Windows compatibility tools for VST plugins

- [Wine-Staging](https://github.com/wine-staging/wine-staging)
- [Yabridge](https://github.com/robbert-vdh/yabridge) (for low latency compatibility for Windows VST plugins)

### Audio Plugins

- [The LSP suite](https://lsp-plug.in/)
- [The Calf suite](https://calf-studio-gear.org/)
- [Zam Audio](https://github.com/zamaudio/zam-plugins)
- [Guitarix](https://guitarix.org/)

### Virtual Instruments

- [Surge](https://surge-synthesizer.github.io/)
- [Yoshimi](https://yoshimi.sourceforge.io/)
- [Drumk by K Devices](https://k-devices.com/products/drumk/)
- [QSynth](https://qsynth.sourceforge.io/qsynth-downloads.html)

### DAWs, Plugin Hosts, and Sequencers

- [Ardour](https://ardour.org/)
- [Reaper](https://www.reaper.fm/) (Closed Source)
- [Renoise](https://www.renoise.com/) (Closed Source)
- [Hydrogen](https://sourceforge.net/projects/hydrogen/)
- [Tenacity](https://github.com/tenacityteam/tenacity) (Better Audacity fork)
- [Carla](https://github.com/falkTX/Carla)
- [Qtractor](https://www.qtractor.org/)

### Useful Composer Tools

- [Musescore](https://musescore.org/en) (Notation software)
- [SooperLooper](https://github.com/essej/sooperlooper) (Live looping)

### Additional Pre-installed Software

- [Neovim](https://neovim.io/)
- [Zen Browser](https://zen-browser.app/) (A stylish, modern Firefox clone with lots of quality of life features)
- [Alacritty](https://alacritty.org/)
- [Rsync](https://github.com/rsyncproject/rsync) (Recording artists that move between devices would benefit from learning this command)
- [Zsh](https://www.zsh.org/) with [Oh-My-Posh](https://ohmyposh.dev/) and [Oh-My-Zsh](https://ohmyz.sh/)

### Custom configurations optimized for musicians

- Start Ops kernel flag set to "performance"
- Real-time and memlock permissions for 'audio' and 'realtime' groups (requires just script to be run on first launch)

## Installation

> [!WARNING]  
> [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:

  ```
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/tumillanino/miasma-os:latest
  ```

- Reboot to complete the rebase:

  ```
  systemctl reboot
  ```

- Then rebase to the signed image, like so:

  ```
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/tumillanino/miasma-os:latest
  ```

- Reboot again to complete the installation

  ```
  systemctl reboot
  ```

- On first launch, please open Alacritty and run the script below in order to properly configure Wine with Yabridge, Reaper paths, and system flags.

```
  ujust first-run
```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## ISO

An ISO and website is coming soon ...

## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/tumillanino/miasma-os
```
