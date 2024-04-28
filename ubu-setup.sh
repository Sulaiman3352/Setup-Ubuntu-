#!/bin/sh

snap list

echo "start removing packages"

sudo snap remove --purge firefox
sudo snap remove --purge snap-store
sudo snap remove --purge gtk-common-themes
sudo snap remove --purge snapd-desktop-integration
echo "what is the version of gnome?"
read gnome
sudo snap remove --purge gnome*
sudo snap remove --purge bare
echo "what is the version of core?"
read core
sudo snap remove --purge core*

echo "removing snapd... "
sudo snap remove --purge snapd
sudo apt remove --autoremove snapd

echo "adding firefox repo"
sudo add-apt-repository ppa:mozillateam/ppa

echo "block apt to download firefox from snapd... "
touch /etc/apt/preferences.d/nosnap.pref && echo "Package: snapd
Pin: release a=*
Pin-Priority: -10" > /etc/apt/preferences.d/nosnap.pref

sudo apt update

sudo apt install -t 'o=LP-PPA-mozillateam' firefox
sudo apt install --install-suggests gnome-software

echo "installing flatpak"
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo apt install gnome-software-plugin-flatpak gnome-software

echo "Final touch"

echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

touch /etc/apt/preferences.d/mozillateamppa && echo "Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 501" > /etc/apt/preferences.d/mozillateamppa
