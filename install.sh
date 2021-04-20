#!/usr/bin/env bash
# TEST

set -o nounset
set -o errexit

RED='\033[0;31m'
GRAY='\033[0;37m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NORMAL='\033[0m'

DATE_NOW=$(date +'%Y/%m/%d %r')
WORK_DIR=$(pwd)


install_pkgs() {
    sudo pacman -Syy

    build_yay() {
        echo -e "${GREEN}Check yay${NORMAL}"

        local DOMAIN="https://aur.archlinux.org/yay.git"

        if [ ! -f "/usr/bin/yay" ]; then
            echo "${GREEN}Build yay${NORMAL}"

            sudo pacman -Sy --needed git base-devel && \
            git clone $DOMAIN /tmp/yay && cd /tmp/yay && \
            makepkg -si && cd $WORK_DIR
        fi
        yay_soft
    }

    yay_soft() {
        echo -e "${GREEN}Yay soft${NORMAL}"
        yay -Syy
    }

    i3_desktop() {
        echo -e "${GREEN}i3 desktop env installing${NORMAL}"
        sudo timedatectl set-ntp 1

        sudo pacman -Sy --needed \
        xterm xorg-xrandr \
        i3-wm i3status i3lock dmenu jq \
        wpa_supplicant \
        wireless_tools \
        networkmanager \
        network-manager-applet \
        sudo systemctl enable NetworkManager.service
    }

    tools() {
        echo -e "${GREEN}Tools installing${NORMAL}"
        sudo pacman -Sy --needed \
        rxvt-unicode rxvt-unicode-terminfo \
        ttf-ubuntu-font-family \
        ttf-font-awesome \
        xfce4-screenshooter \
        xfce4-power-manager \
        picom feh keepassxc
    }

    utils() {
        echo -e "${GREEN}Utils installing${NORMAL}"
        oh_my_zsh() {
            local DOMAIN="https://raw.githubusercontent.com"
            local URL="ohmyzsh/ohmyzsh/master/tools/install.sh"

            if [ ! -d "~/.oh-my-zsh" ]; then
                sh -c "$(curl -fsSL ${DOMAIN}/${URL})"
            fi
        }

        sudo pacman -Sy --needed \
        git vim tmux zsh tldr htop mc
        oh_my_zsh
    }

    build_yay

    tools
    utils
    i3_desktop
}

sync_configs_links() {
    echo -e "${GREEN}Updating config symlinks${NORMAL}"
    ln -sfn ${WORK_DIR}/env/.xinitrc ~/.xinitrc
    ln -sfn ${WORK_DIR}/env/.Xresources ~/.Xresources

    ln -sfn ${WORK_DIR}/env/.zshrc ~/.zshrc
    ln -sfn ${WORK_DIR}/env/.vimrc ~/.vimrc

    rm -rf ~/bin
    ln -sfn ${WORK_DIR}/env/bin ~/bin

    rm -rf ~/.config/i3
    ln -sfn ${WORK_DIR}/env/.config/i3 ~/.config/i3

    rm -rf ~/.config/i3status
    ln -sfn ${WORK_DIR}/env/.config/i3status ~/.config/i3status
}

main() {
    if [ "$(id -u)" == "0" ]; then
        echo -e "${RED}This script must not be run as root${NORMAL}"
        exit 1
    fi
    case "$1" in
        "--all")
            install_pkgs
            sync_configs_links
            ;;
        "--sync")
            sync_configs_links
            ;;
        "--help")
            local flag_all="${GREEN}--all${NORMAL} - for install soft and make configs symlinks"
            local flag_sync="${GREEN}--sync${NORMAL} - for only update configs symlinks"
            echo -e "${YELLOW}flags${NORMAL}:\n${flag_all}\n${flag_sync}"
            exit 0
            ;;
        *)
        echo -e "use ${GREEN}--help${NORMAL}"
        exit 1
        ;;
    esac
    exit 0
}
echo -e "${RED}Caution!!! Running this script can break your environment configuration!${NORMAL}"
main ${1:---help}
