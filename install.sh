#!/usr/bin/env bash

set -o nounset
set -o errexit

DATE_NOW=$(date +'%Y/%m/%d %r')
WORK_DIR=$(pwd)


install_pkgs() {
    sudo pacman -Syy

    build_yay() {
        local DOMAIN="https://aur.archlinux.org/yay.git"

        if [ ! -f "/usr/bin/yay" ]; then
            sudo pacman -Sy --needed git base-devel && \
            git clone $DOMAIN /tmp && cd /tmp/yay && \
            makepkg -si && cd $WORK_DIR
        fi
        yay_soft
    }

    yay_soft() {
        yay -Syy
    }

    i3_desktop() {
        pacman -Sy --needed i3-wm i3status i3lock dmenu
    }

    tools() {
        sudo pacman -Sy --needed \
        ttf-ubuntu-font-family \
        xfce4-screenshooter \
        xfce4-power-manager \
        picom feh keepassxc \
        rxvt-unicode rxvt-unicode-terminfo
    }

    utils() {
        oh_my_zsh() {
            local DOMAIN="https://raw.githubusercontent.com"
            local URL="ohmyzsh/ohmyzsh/master/tools/install.sh"

            if [ ! -d "~/.oh-my-zsh" ]; then
                sh -c "$(curl -fsSL ${DOMAIN}/${URL})"
            fi
        }

        sudo pacman -Sy --needed git vim tmux zsh tldr mc
        oh_my_zsh
    }

    build_yay

    tools
    utils
    i3_desktop
}

sync_configs_links() {
    echo "hello"
}

main() {
    install_pkgs
}
main
