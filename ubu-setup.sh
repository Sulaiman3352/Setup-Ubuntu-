#!/bin/sh
echo " Disable snapd services "
sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket
sudo systemctl disable snapd.seeded.service
sudo systemctl mask snapd.service
snap list
echo "what is the version of core?"
read core

echo "start removing packages"

sudo snap remove $core
sudo snap remove firefox
sudo snap remove snap-store
sudo snap remove gtk-common-themes
sudo snap remove snapd-desktop-integration
echo "what is the version of gnome?"
read gnome
sudo snap remove $gnome

echo "deleting cache snapd... "
sudo rm -rf /var/cache/snapd/

echo "purge snapd... "
sudo apt autoremove --purge snapd

rm -rf ~/snap

echo "block apt to download firefox from snapd... "

touch /etc/apt/preferences.d/firefox-no-snap && echo "Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1" > /etc/apt/preferences.d/firefox-no-snap

echo "adding repo and install firfox"
sudo add-apt-repository ppa:mozillateam/ppa
sudo apt update
sudo apt install firefox

echo "installing flatpak"
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo apt install gnome-software-plugin-flatpak gnome-software

