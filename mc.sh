#!/bin/bash
# Oct 04, 2021, 17:03:24


# ---------------------------SPIN CODE--------------------------------#

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

# -------------------------------------------------------------------#



# --------------------------MENU CODE--------------------------------#

# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "  $ESC[7m $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

function select_opt {
    select_option "$@" 1>&2
    local result=$?
    echo $result
    return $result
}

# -------------------------------------------------------------------#


grey="\e[1;30m"
green="\e[1;32m"
orange="\e[38;5;166m"
white="\e[1;37m"
nc="\e[0m"


t1="${green}Mine${nc}"
t2="${orange}Craft${nc} "
t3="${grey}Updater${nc}"

ttt="This is a test"


block="■■■■■■■■■■■■■■■■■■■■■"

#

clear
echo
echo -en "${green}" 
echo -en "MineCraft Updater" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
echo -en "${orange}" 
echo -e "◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
echo -en "${nc}"
echo ""
echo ""
echo ""
echo "Select one option using up/down keys and enter to confirm:"
echo ""
echo ""

case `select_opt "Start" "Install" "Update" "Cancel"` in
	0)  clear
		cd minecraft
		echo
		LD_LIBRARY_PATH=. ./bedrock_server;;
	
    1) if [ -d "minecraft" ]; 
    	then
			clear
			echo
			echo -en "${green}" 
			echo -en "MineCraft Updater" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
			echo -en "${orange}" 
			echo -e "◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
			echo -en "${nc}"
			echo ""
			echo ""
			echo ""
    		echo -en "Minecraft Server is already installed" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
    		read -p "Press [Enter] key to exit"
    		clear
    		
 	   	else
			clear
			echo
			echo -en "${green}" 
			echo -en "MineCraft Updater" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
			echo -en "${orange}" 
			echo -e "◼◼◼◼◼◼◼◼◼◼◼◼◼◼◼" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
			echo -en "${nc}"
			echo ""
			echo ""
			start_spinner "Downloading Server..."
			mkdir minecraft
			cd minecraft
			wget https://minecraft.azureedge.net/bin-linux/bedrock-server-1.17.33.01.zip > /dev/null 2>&1
			stop_spinner $?
			
			#
			
			start_spinner "Installing Server..."
			unzip bedrock-server*.zip > /dev/null 2>&1
			rm bedrock-server*.zip
			stop_spinner $?
			
			#
			
			start_spinner "Setting Up..."
			# LD_LIBRARY_PATH=. ./bedrock_server /dev/null 2>&1 && pkill bedrock_server
			stop_spinner $?
			
    		read -p "Press [Enter] key to exit"
    	fi
    	;;
    
    2) sudo fstrim -a -v
    ;;
    
    3) echo "selected Cancel"
    ;;
    
esac

