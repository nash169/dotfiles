#!/bin/bash

# Install battery package
sudo pacman -S tlp

# Modify fstab for ssd longer life
sed ‘s/<relatime>/& ,data=ordered,discard/’ /etc/fstab

# Modules
sudo tee -a /etc/modules > /dev/null <<EOT
coretemp
applesmc
EOT

# Services to block interrupt (grep . -r /sys/firmware/acpi/interrupts/gpe*)
sudo tee -a /etc/systemd/system/disable-gpe4E.service > /dev/null <<EOT
[Unit]
Description=Disable GPE4E interrupts

[Service]
ExecStart=/usr/bin/bash -c 'echo "disable" > /sys/firmware/acpi/interrupts/gpe4E'

[Install]
WantedBy=multi-user.target
EOT

sudo tee -a /etc/systemd/system/mask-gpe4E.service > /dev/null <<EOT
[Unit]
Description=Mask GPE 4E

[Service]
ExecStart=/usr/bin/bash -c 'echo "mask" > /sys/firmware/acpi/interrupts/gpe4E'

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl enable disable-gpe4E.service
sudo systemctl enable mask-gpe4E.service

# Fix unwanted laptop resume after lid is closed
sudo tee -a /etc/udev/rules.d/90-xhc_sleep.rules > /dev/null <<EOT
# disable wake from S3 on XHC1
SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
EOT

# Wireless driver
yay -S broadcom-wl

# Setup CPU governor and thermal daemons
yay -S mbpfan-git cpupower
sudo systemctl enable mbpfan
sudo systemctl enable cpupower

# Setup sound
sudo tee -a /etc/modprobe.d/snd_hda_intel.conf > /dev/null <<EOT
# Switch audio output from HDMI to PCH and Enable sound chipset powersaving
options snd-hda-intel index=1,0 power_save=1
EOT

# Install Facetime WebCam drivers
yay -S bcwc-pcie-git

# Touchpad
sudo tee -a /etc/X11/xorg.conf.d/30-touchpad.conf > /dev/null <<EOT
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
    Option "ClickMethod" "clickfinger"
    Option "AccelProfile" "flat"
EndSection
EOT

sudo tee -a /etc/X11/xorg.conf.d/30-pointer.conf > /dev/null <<EOT
Section "InputClass"
    Identifier "pointer"
    Driver "libinput"
    MatchIsPointer "on"
    Option "NaturalScrolling" "true"
EndSection
EOT
