#!/usr/bin/env bash
# Collection of customization/tweaks for Clean RetroPie Installs.


function custom_collection(){
  echo -n 'Copying custom collections...'
  cd es-collections;
  cp *.cfg /opt/retropie/configs/all/emulationstation/collections/;
  echo ' done'
}


function rpi_cmdline_mod(){
  # XXX add check to ensure it only runs on RPi hardware.
  cmdline='/boot/cmdline.txt'
  echo -n 'Moving console to tty3 and Disabling RPi logo at boot...'
  sudo sed -i 's/tty1/tty3 logo\.nologo/g' ${cmdline}
  echo 'done'
}


function mame_row(){
  # XXX find a nicer way to modify gamelist.xml
  echo -n 'Installing MAME ROW Script...'
  cd ~/RetroPie/retropiemenu/
  wget -nv https://raw.githubusercontent.com/asdfgasfhsn/retropie-mame-row/master/mame-row-custom-collection.sh
  chmod +x mame-row-custom-collection.sh
  echo ' done'

  echo -n 'Installing MAME ROW icon...'
  cd ~/RetroPie/retropiemenu/icons/
  wget -nv https://raw.githubusercontent.com/asdfgasfhsn/retropie-mame-row/master/artwork/mame-row.png
  echo ' done'

  echo -n 'Adding MAME ROW metadata to RetroPie gamelist.xml...'
  echo $(sed \$d /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml) > /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
  echo "<game><path>./mame-row-custom-collection.sh</path><name>MAME ROW</name><desc>Install and update MAME Random Of the Week Custom Collections. Requires and active internet connection. You will need to restart EmulationStation after running this script.</desc><image>./icons/mame-row.png</image></game></gameList>" >> /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
  echo ' done'
}


function install_theme(){
  echo -n 'Installing custom theme (art-book)...'
  cd /etc/emulationstation/themes/
  sudo git clone --depth 1 https://github.com/asdfgasfhsn/es-theme-art-book.git my-art-book
  echo ' done'
}

function get_overlays(){
  wget -nv https://github.com/cosmo0/retropie-overlays/releases/download/v1.2/overlays_shaders.zip
  wget -nv https://github.com/cosmo0/retropie-overlays-arcade-realistic/releases/download/v1.1/overlays.zip
}

function enable_screeper(){
  echo 'screenshot_directory = "/home/pi/screenshots/"' >> /opt/retropie/configs/all/retroarch.cfg
  echo ' auto_screenshot_filename = "false"' >> /opt/retropie/configs/all/retroarch.cfg
  cp screeper.sh /opt/retropie/configs/all/runcommand-onend.sh
  chmod +x /opt/retropie/configs/all/runcommand-onend.sh
}

function force_x11_resolution(){
cat >/usr/share/X11/xorg.conf.d/05-monitor.conf <<EOL
Section "Monitor"
   Identifier "Monitor0"
   Modeline "1920x1080_60.00" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
EndSection
Section "Device"
   Identifier "Device0"
   Driver "intel"
EndSection
Section "Screen"
   Identifier "Screen0"
   Device "Device0"
   Monitor "Monitor0"
   DefaultDepth 24
   SubSection "Display"
      Depth 24
      Modes "1920x1080"
   EndSubSection
EndSection
EOL
}

function disable_x11_ps_controller_mouse(){
cat >/usr/share/X11/xorg.conf.d/90-dualshock3.conf <<EOL
Section "InputClass"
  Identifier	"Disable PS3"
  MatchProduct	"PLAYSTATION"
  Option	"Ignore" "on"
EndSection
EOL

}

function force_pulse_hdmi_audio(){
  echo "set-card-profile 0 output:hdmi-stereo-extra2" >> /etc/pulse/default.pa
}
