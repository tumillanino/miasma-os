#!/usr/bin/env bash

################################################################################

usage() {
  echo "usage: `basename $0` [-u] [-r]"
  echo " -u: Uninstall (remove all installed resources and relink previous installed versions)"
  echo " -r: Relink (recreate the exe symlink and reinstall desktop integration files)"
}


################################################################################

RENOISE_VERSION=3.5.4

# allow starting the script from any path, but run from ./ to avoid 
# troubles with spaces in ABS_SCRIPT_PATH
cd "`dirname "$0"`"; ABS_SCRIPT_PATH=`pwd`
cd "$ABS_SCRIPT_PATH"; SCRIPT_PATH=.

# all dests are /usr/local based...
BINARY_PATH=/usr/local/bin
SYSTEM_LOCAL_SHARE=/usr/local/share
RESOURCES_PATH=$SYSTEM_LOCAL_SHARE/renoise-$RENOISE_VERSION

# append our xdg-utils path: this uses the systems xdg-utils, if available...
export PATH=$PATH:"$SCRIPT_PATH/Installer/xdg-utils"
export PATH=$PATH:"$RESOURCES_PATH/Installer/xdg-utils"


################################################################################

UNINSTALL=0
INSTALL=1
RELINK=2

INSTALLATION_MODE=$INSTALL

while [ "$1" ]; do	
  if [ "$1" = "-u" ]; then
	  INSTALLATION_MODE=$UNINSTALL; shift
  elif [ "$1" = "-r" ]; then
	  INSTALLATION_MODE=$RELINK; shift
  elif [ "$1" = "--help" ] || [ "$1" = "--h" ]; then
    usage; exit 1
  else
    usage; exit 0
  fi
done


################################################################################

bail_out() {
  if [ $INSTALLATION_MODE -eq $UNINSTALL ]; then
    echo " ** Uninstallation of Renoise $RENOISE_VERSION FAILED ** ";
  else
    echo " ** Installation of Renoise $RENOISE_VERSION FAILED ** ";
  fi  

  exit 0
}


################################################################################

if [ `id -u` -ne 0 ]; then 
  echo "Sorry, must be root to (un)install..."
  exit 1
fi

if [ $INSTALLATION_MODE -eq $UNINSTALL ]; then

  ### Uninstall

  echo "Removing the executable..."
  rm $BINARY_PATH/renoise-$RENOISE_VERSION || bail_out
  rm $BINARY_PATH/renoise || bail_out

  echo "Removing the man file..."
  rm /usr/local/share/man/man1/renoise.1.gz || bail_out
  rm /usr/local/share/man/man5/renoise-pattern-effects.5.gz || bail_out

  # ignore errors from now on (to completely remove bogus installations and 
  # to support desktop environments where installation of MIMES/Icons/Shortcuts failed...) 
  
  echo "Unregistering MIME types"
  xdg-mime uninstall $RESOURCES_PATH/Installer/renoise.xml
  
  echo "Removing icons..."
  xdg-icon-resource uninstall --size 48 --context mimetypes renoise \
    application-x-renoise-module
  xdg-icon-resource uninstall --size 64 --context mimetypes renoise \
    application-x-renoise-module
  xdg-icon-resource uninstall --size 128 --context mimetypes renoise \
    application-x-renoise-module
  xdg-icon-resource uninstall --size 48 --context apps renoise
  xdg-icon-resource uninstall --size 64 --context apps renoise
  xdg-icon-resource uninstall --size 128 --context apps renoise

  echo "Removing desktop/menu shortcuts..."
  xdg-desktop-menu uninstall $RESOURCES_PATH/Installer/renoise.desktop

  echo "Removing shared resources..."
   # as last step, because we have the xdg-utils fallbacks in $RESOURCES_PATH...
  rm -r $RESOURCES_PATH
  
  echo " ** Uninstallation of Renoise$RENOISE_VERSION SUCCEEDED ** ";

  # this links the last renoise version again (if there is one) 
  if [[ -n `find $SYSTEM_LOCAL_SHARE -name "renoise-*"` ]]; then
    LAST_RENOISE=`ls -d -x1 --sort=time $SYSTEM_LOCAL_SHARE/renoise* | head -n 1`
    echo " ** Relinking $LAST_RENOISE..."
    $LAST_RENOISE/install.sh -r
  fi

else

  ### Install

  if [ $INSTALLATION_MODE -eq $INSTALL ]; then

    echo "Fixing file permissions..."
    # (woraround for regged version downloads which are tared with 777 on the server)
    find $SCRIPT_PATH -type d -exec chmod 755 {} \; && \
      find $SCRIPT_PATH -type f -exec chmod 644 {} \; && \
      find $SCRIPT_PATH -type f -name "*.sh" -exec chmod 755 {} \; && \
      find $SCRIPT_PATH/Installer/xdg-utils -type f -name "xdg-*" -exec chmod 755 {} \; && \
      chmod 755 $SCRIPT_PATH/renoise && \
      chmod 755 $SCRIPT_PATH/Resources/AudioPluginServer_* && \
      chmod 755 $SCRIPT_PATH/Resources/3rdParty/LuaLS/bin/lua-language-server-linux_* || bail_out
    
    echo "Installing shared resources..."
    mkdir -p $RESOURCES_PATH || bail_out

    cp -r $SCRIPT_PATH/Resources/* $RESOURCES_PATH || bail_out
    
    for f in "License.txt" "install.sh" "uninstall.sh" "Installer"; do
      cp -r $SCRIPT_PATH/$f $RESOURCES_PATH || bail_out
    done

    echo "Installing the executable..."
    mkdir -p $BINARY_PATH || bail_out
    cp $SCRIPT_PATH/renoise $BINARY_PATH/renoise-$RENOISE_VERSION || bail_out
  fi
  
  ### Install or Relink

  if [ $INSTALLATION_MODE -eq $INSTALL ] || [ $INSTALLATION_MODE -eq $RELINK ]; then
    echo "Linking the executable..."
    ln -sf $BINARY_PATH/renoise-$RENOISE_VERSION $BINARY_PATH/renoise || bail_out
  
    echo "Installing the man file..."
    install -D -m644 $SCRIPT_PATH/Installer/renoise.1.gz \
      $SYSTEM_LOCAL_SHARE/man/man1/renoise.1.gz || bail_out
    install -D -m644 $SCRIPT_PATH/Installer/renoise-pattern-effects.5.gz \
      $SYSTEM_LOCAL_SHARE/man/man5/renoise-pattern-effects.5.gz || bail_out
    
    echo "Registering MIME types..."
    xdg-mime install --novendor $RESOURCES_PATH/Installer/renoise.xml || \
      (echo "  Warning: failed to register the Renoise MIME types (not critical)."; \
       echo "  Your desktop environment might not support the installation of MIME types...\n")
  
    echo "Installing icons..."
    (xdg-icon-resource install --novendor --size 48 --context apps \
       $RESOURCES_PATH/Installer/renoise-48.png renoise && \
     xdg-icon-resource install --novendor --size 48 --context mimetypes \
       $RESOURCES_PATH/Installer/renoise-48.png application-x-renoise-module) || \
      (echo "  Warning: failed to install the Renoise 48x48 icon files (not critical)."; \
       echo "  Your desktop environment might not support the installation of app icon files...\n")
       
    (xdg-icon-resource install --novendor --size 64 --context apps \
       $RESOURCES_PATH/Installer/renoise-64.png renoise && \
     xdg-icon-resource install --novendor --size 64 --context mimetypes \
       $RESOURCES_PATH/Installer/renoise-64.png application-x-renoise-module) || \
      (echo "  Warning: failed to install the Renoise 64x64 icon files (not critical)."; \
       echo "  Your desktop environment might not support the installation of app icon files...\n")

    (xdg-icon-resource install --novendor --size 128 --context apps \
       $RESOURCES_PATH/Installer/renoise-128.png renoise && \
     xdg-icon-resource install --novendor --size 128 --context mimetypes \
       $RESOURCES_PATH/Installer/renoise-128.png application-x-renoise-module) || \
      (echo "  Warning: failed to install the Renoise 128x128 resolution icon files (not critical)."; \
       echo "  Your desktop environment might not support the installation of app icon files...\n")

    echo "Installing desktop-menu shortcuts..."
    xdg-desktop-menu install --novendor $RESOURCES_PATH/Installer/renoise.desktop || \
      (echo "  Warning: failed to install desktop-menu shortcuts for Renoise (not critical)."; \
       echo "  Your desktop environment might not support the installation of app shortcuts...\n")
  fi  
  
  if [ $INSTALLATION_MODE -eq $INSTALL ]; then

    echo "Checking CPU frequency scaling..."

    if `grep -E "performance" /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null`; then
      echo "  OK - Your CPU frequency governor seems to be set to 'performance'."
    else
      echo "  Your CPU frequency governor is NOT set to 'performance'."
      echo "  It's HIGHLY RECOMMENDED to disable CPU frequency scaling for realtime audio applications."
      echo "  Please have a look at 'https://wiki.linuxaudio.org/wiki/system_configuration#cpu_frequency_scaling' \
for more information about this..."
    fi

    echo "Checking audio configuration..."

    if [ -f "/etc/security/limits.d/audio.conf" ] || \
       `grep -E "^[^#]+(rtprio).*$" /etc/security/limits.conf > /dev/null`; then

      echo "  OK - PAM seems to be installed and configured for audio applications."
      echo "  If you nevertheless have problems with ALSA or Jack (such as crackles \
or too high latencies) take a look at 'https://wiki.linuxaudio.org/wiki/system_configuration#limitsconfaudioconf' \
for help please..."
    
    else
      echo "  PAM seems not to be installed or not configured for audio applications."
      echo "  It's HIGHLY RECOMMENDED to tweak your system for realtime audio applications to \
get acceptable audio/MIDI latencies with Jack and ALSA. Please have a look at \
'https://wiki.linuxaudio.org/wiki/system_configuration#limitsconfaudioconf' for more information about this topic..."
    fi
  fi
  
  if [ $INSTALLATION_MODE -eq $INSTALL ] || [ $INSTALLATION_MODE -eq $RELINK ]; then
    echo; echo "Installation of Renoise $RENOISE_VERSION SUCCEEDED."
  fi  
fi

exit 1

