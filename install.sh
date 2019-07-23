sudo dnf update -y && sudo dnf upgrade -y # General Update After Install
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

################################################################################
# User Software
################################################################################

# General Software
sudo dnf install thunderbird -y
sudo dnf install wget curl -y
sudo dnf install klavaro -y
sudo dnf install playonlinux -y
sudo dnf install chromium-browser -y
sudo dnf install dropbox nautilus-dropbox -y
if [[ "$@" == *"steam"* ]]
then
  echo "Installing steam"
  sudo dnf install steam -y
else
  echo "No steam option passed, steam installation skipped"
fi
sudo dnf install telegram-desktop -y
sudo dnf install transmission -y
sudo dnf install gparted -y
sudo dnf install mpv youtube-dl -y
sudo dnf install chrome-gnome-shell -y
sudo dnf install gimp -y
sudo dnf install xclip -y
sudo dnf install htop -y

# Skype
mkdir -p ~/temp/skype && cd ~/temp/skype
wget --trust-server-names https://go.skype.com/skypeforlinux-64.rpm
sudo dnf install ./skypeforlinux-64.rpm -y
cd ~ && rm -rf ~/temp

# Slack
mkdir -p ~/temp/slack && cd ~/temp/slack
wget --trust-server-names https://downloads.slack-edge.com/linux_releases/slack-2.8.2-0.1.fc21.x86_64.rpm
sudo dnf install ./slack-2.8.2-0.1.fc21.x86_64.rpm -y
cd ~ && rm -rf ~/temp


# NodeJS configure
sudo dnf install nodejs -y
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' > ~/.profile
source ~/.profile
npm i -g yarn
npm install -g jekyll-posts-generator

# Zsh & Oh My Zsh setup
sudo dnf install zsh util-linux-user -y
chsh -s $(which zsh) && sudo chsh -s $(which zsh)
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
npm install -g spaceship-zsh-theme

# Dash To Dock
git clone https://github.com/micheleg/dash-to-dock.git ~/temp/dash
cd ~/temp/dash
make && sudo make install
cd ~ && rm -rf ~/temp


sudo dnf install intel-gpu-tools libva-intel-driver libva-utils libva mesa-libOSMesa cairo-gobject cairo mesa-dri-drivers mesa-filesystem mesa-libEGL mesa-libGL mesa-libGLES mesa-libgbm mesa-libglapi mesa-libwayland-egl mesa-libxatracker -y


################################################################################
# Bumblebee
################################################################################

if [[ "$@" == *"bumblebee"* ]]
then
  echo "Installing bumblebee"
  sudo dnf -y --nogpgcheck install http://install.linux.ncsu.edu/pub/yum/itecs/public/bumblebee/fedora$(rpm -E %fedora)/noarch/bumblebee-release-1.2-1.noarch.rpm
  # Managed Nvidia Repo
  sudo dnf -y --nogpgcheck install http://install.linux.ncsu.edu/pub/yum/itecs/public/bumblebee-nonfree/fedora$(rpm -E %fedora)/noarch/bumblebee-nonfree-release-1.2-1.noarch.rpm
  sudo dnf install bumblebee-nvidia bbswitch-dkms VirtualGL.x86_64 VirtualGL.i686 primus.x86_64 primus.i686 kernel-devel -y
else
  echo "No bumblebee option passed, bumblebee installation skipped"
fi

################################################################################
# Theme Setup
################################################################################

# Install Needed Software
sudo dnf install gnome-tweak-tool -y # Tweak tool for configuring Gnome
sudo dnf install google-roboto-fonts google-roboto-mono-fonts -y # Fonts for Adapta Theme
sudo dnf install breeze-cursor-theme -y # Breeze Cursor from KDE
sudo dnf install autoconf automake inkscape gdk-pixbuf2-devel glib2-devel libsass libxml2 pkgconfig sassc parallel -y # List of pacakages for Adapta Theme according to https://github.com/adapta-project/adapta-gtk-theme

# Prepare Theme
sudo rm -rf /usr/share/themes/{Adapta,Adapta-Eta,Adapta-Nokto,Adapta-Nokto-Eta} # Remove old theme
rm -rf ~/.local/share/themes/{Adapta,Adapta-Eta,Adapta-Nokto,Adapta-Nokto-Eta}
rm -rf ~/.themes/{Adapta,Adapta-Eta,Adapta-Nokto,Adapta-Nokto-Eta}

#Install Theme
git clone https://github.com/adapta-project/adapta-gtk-theme.git ~/temp/adapta
cd ~/temp/adapta
./autogen.sh --enable-parallel --disable-cinnamon --disable-unity --disable-mate --disable-openbox --enable-gtk_legacy --enable-gtk_next
make && sudo make install
cd ~ && rm -rf ~/temp

# Icon Theme
wget -qO- https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-icon-theme/master/install-papirus-root.sh | sh


################################################################################
# Developer Software
################################################################################
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf check-update
sudo dnf install code -y
sudo dnf install emacs -y
sudo dnf install jekyll -y
gem install jekyll bundler
sudo dnf install gitflow -y
sudo dnf install hexchat -y

# Fira Code
mkdir -p ~/.local/share/fonts
for type in Bold Light Medium Regular Retina; do
    wget -O ~/.local/share/fonts/FiraCode-${type}.ttf \
    "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true";
done
fc-cache -f

sudo dnf install ocaml -y
wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin
opam install utop

################################################################################
# Documents & Work Setup
################################################################################
cd ~/Documents && mkdir Learn && mkdir Work && mkdir Home