#!/bin/bash
readonly ANDROID='android'
readonly IOS='ios'
readonly PROD='prod' # or whatever you name your prod enviroment

export APP_ENV=$1

# clean folders when user need
function choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    local options=("$@") cur=0 count=${#options[@]} index=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    while true
    do
        # list all options (option list is zero-based)
        index=0 
        for o in "${options[@]}"
        do
            if [ "$index" == "$cur" ]
            then echo -e " >\e[7m$o\e[0m" # mark & highlight the current option
            else echo "  $o"
            fi
            index=$(( $index + 1 ))
        done
        read -s -n3 key # wait for user to key in arrows or ENTER
        if [[ $key == $esc[A ]] # up arrow
        then cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0
        elif [[ $key == $esc[B ]] # down arrow
        then cur=$(( $cur + 1 ))
            [ "$cur" -ge $count ] && cur=$(( $count - 1 ))
        elif [[ $key == "" ]] # nothing, i.e the read delimiter - ENTER
        then break
        fi
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}
selections=(
"YES"
"NO"
)

choose_from_menu "Do you need to delete platforms plugins www? " selected_choice "${selections[@]}"
echo "Selected choice: $selected_choice"

if [ $selected_choice == 'YES' ]; then
    rm -r platforms plugins www
fi

# build command processing 

if [ $2 == $ANDROID ]; then
    ionic cordova platform add android
    if [[ $1 != $PROD ]] && [[ $3 != 'run' ]]; then
        echo "build env is $1"
        sleep 2
        ionic cordova build android --c=$1
    fi
    if [[ $1 = $PROD ]] && [[ $3 != 'run' ]]; then
        echo "build env is prod"
        sleep 2
        ionic cordova build android --release --prod --aot
    fi
    if [[ $3 == 'run' ]] ; then
        echo "run env is $1"
        PS3='Please enter your choice: '
        options=("device" "emulator" "quit")
        select opt in "${options[@]}"
        do
            case $opt in
                "device")
                    echo "you chose choice 1"
                    ionic cordova run android --device --c=$1 -l
                ;;
                "emulator")
                    echo "you chose choice 2"
                    ionic cordova run android --emulator --c=$1 -l
                ;;
                "quit")
                    break
                ;;
                *) echo "invalid option $REPLY";;
            esac
        done
    fi
fi
if [ $2 == $IOS ]; then
    ionic cordova platform add ios
    if [[ $1 != $PROD ]] && [[ $3 != 'run' ]]; then
        echo "build env is $1"
        sleep 2
        ionic cordova build ios --c=$1
    fi
    if [[ $1 = $PROD ]] && [[ $3 != 'run' ]]; then
        echo "build env is prod"
        sleep 2
        ionic cordova build ios --prod --aot
    fi
    if [[ $3 == 'run' ]]; then
        echo "run env is $1"
        PS3='Please enter your choice: '
        options=("device" "emulator" "quit")
        select opt in "${options[@]}"
        do
            case $opt in
                "device")
                    echo "you chose choice 1"
                    ionic cordova run ios --device --c=$1 -l
                ;;
                "emulator")
                    echo "you chose choice 2"
                    ionic cordova run ios --emulator --c=$1 -l
                ;;
                "quit")
                    break
                ;;
                *) echo "invalid option $REPLY";;
            esac
        done
    fi
fi