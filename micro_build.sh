#!/bin/bash
# Sep 28, 2021, 00:14:51'


# ------------------------------SPIN CODE-----------------------------------#

function _spinner() {
    # $1 start/stop
    #
    # on start: $2 display message
    # on stop : $2 process exit status
    #           $3 spinner function pid (supplied from stop_spinner)

    local on_success="DONE"
    local on_fail="FAIL"
    local white="\e[1;37m"
    local green="\e[1;32m"
    local red="\e[1;31m"
    local nc="\e[0m"

    case $1 in
        start)
            # calculate the column where spinner and status msg will be displayed
            let column=$(tput cols)-${#2}-8
            # display message and position the cursor in $column column
            echo -ne ${2}
            printf "%${column}s"

            # start spinner
            i=1
            sp='\|/-'
            delay=${SPINNER_DELAY:-0.15}

            while :
            do
                printf "\b${sp:i++%${#sp}:1}"
                sleep $delay
            done
            ;;
        stop)
            if [[ -z ${3} ]]; then
                echo "spinner is not running.."
                exit 1
            fi

            kill $3 > /dev/null 2>&1

            # inform the user uppon success or failure
            echo -en "\b["
            if [[ $2 -eq 0 ]]; then
                echo -en "${green}${on_success}${nc}"
            else
                echo -en "${red}${on_fail}${nc}"
            fi
            echo -e "]"
            ;;
        *)
            echo "invalid argument, try {start/stop}"
            exit 1
            ;;
    esac
}

function start_spinner {
    # $1 : msg to display
    _spinner "start" "${1}" &
    # set global spinner pid
    _sp_pid=$!
    disown
}

function stop_spinner {
    # $1 : command exit status
    _spinner "stop" $1 $_sp_pid
    unset _sp_pid
}

# --------------------------------------------------------------------------#


title="Micropython Firmware Creator "
board="[ESP32]"
COLUMNS=$(tput cols)


clear
echo ""
echo -e "	\033[1;31m"$title"""\033[1;34m"$board"\033[m" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
echo ""
echo ""

#

start_spinner "   Getting esp-idf export..."
	cd esp-idf
	source 'export.sh' > /dev/null 2>&1
stop_spinner $?

#

start_spinner "   Getting micropython update..."
	cd ..
	cd micropython
	git pull > /dev/null 2>&1
stop_spinner $?

#

start_spinner "   Cleaning build space..."
	cd ports/esp32
	make clean > /dev/null 2>&1
	make submodules > /dev/null 2>&1
stop_spinner $?

#

start_spinner '   Compiling firmware (takes awhile) ...'
	make > /dev/null 2>&1
	# make USER_C_MODULES= ~/st7789_mpy/st7789/micropython.cmake all > /dev/null 2>&1
stop_spinner $?

#

start_spinner "   Uploading..."
esptool.py -p /dev/ttyUSB0 -b 460800 --before default_reset --after hard_reset --chip esp32  write_flash --flash_mode dio --flash_size detect --flash_freq 40m 0x1000 build-GENERIC/bootloader/bootloader.bin 0x8000 build-GENERIC/partition_table/partition-table.bin 0x10000 build-GENERIC/micropython.bin
stop_spinner $?

echo ""
echo ""
