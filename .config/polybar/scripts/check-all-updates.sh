#!/bin/sh
#source https://github.com/x70b1/polybar-scripts

get_updates_count() {
    if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
        updates_arch=0
    fi
    if ! updates_aur=$(yay -Qum --aur | wc -l); then
        updates_aur=0
    fi

    updates=$(("$updates_arch" + "$updates_aur"))
    if [ "$updates" -gt 0 ]; then
        echo $updates
    else
        echo ""
    fi
}

case "$1" in
    --all)
          get_updates_count
          ;;
    --arch)
          $(checkupdates 2> /dev/null | xargs -0 notify-send 'Arch packages' -u critical)
          ;;
    --aur)
          $(yay -Qum --aur 2> /dev/null | xargs -0 notify-send 'AUR packages' -u critical)
          ;;
    *)
      echo ""
esac

