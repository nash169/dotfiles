read -p "Do you want to install tlp for battery life (laptops)?[y/n] " name
if [ "$name" == "y" ]; then
    sudo pacman -S --noconfirm --needed tlp
    sudo systemctl enable tlp.service
    sudo systemctl start tlp.service
fi