#!/bin/bash
# Sep 28, 2021, 03:28:22


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


title="Micropython Build Kit"

blue="\e[1;34m"
white="\e[1;37m"
green="\e[1;32m"
red="\e[1;31m"
blue="\e[1;34m"
nc="\e[0m"


echo -en "	  ${blue}${title}${nc}" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
echo -e "\n \n \n"
read -p "Press [Enter] to start the installation"


clear
echo ""
echo -en "	  ${blue}${title}${nc}" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
echo -e "\n \n \n"
echo -en "${red}Install requires root privlages${nc}\n \n"
sudo echo""
clear
echo ""
echo -en "	  ${blue}${title}${nc}" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
echo -e "\n \n \n"





if [ -d "esp" ]
then
	echo -en "${red}""	  WARNING: ""${white}""esp directory already exists?""${nc}" | sed  -e :a -e "s/^.\{1,$(tput cols)\}$/ & /;ta" | tr -d '\n' | head -c $(tput cols)
	echo -e "\n \n \n \n \n \n \n \n"
	read -p ""
   
	
else


#start_spinner "ㅤGetting esp-idf export..."
#command /dev/null 2>&1
#stop_spinner $?

	
	start_spinner "ㅤInstalling Required Libraries..."
	sudo apt-get -y install build-essential libffi-dev git pkg-config cmake virtualenv python3-pip python3-virtualenv > /dev/null 2>&1
	pip3 install esptool > /dev/null 2>&1
	stop_spinner $?
	
	
	start_spinner "ㅤSymlink python3 to python..."
	sudo ln -s /usr/bin/python3 /usr/bin/python > /dev/null 2>&1
	stop_spinner $?
	
	
	mkdir esp
	cd esp
	
	
	start_spinner "ㅤDownloading MicroPython..."
	git clone --depth 2 https://github.com/micropython/micropython.git > /dev/null 2>&1
	stop_spinner $?
	
	
	start_spinner "ㅤDownloading Esp-idf..."
	git clone -b v4.3-dev --recursive --depth 2 https://github.com/espressif/esp-idf.git > /dev/null 2>&1
	stop_spinner $?
	
	
	start_spinner "ㅤInstall idf modules (slow!)..."
	cd esp-idf/
	./install.sh > /dev/null 2>&1
	source export.sh > /dev/null 2>&1
	stop_spinner $?
	
	
	cd ..
	cd micropython/
	
	
	start_spinner "ㅤInstall MicroPython submodules (slow!)..."
	git submodule update --init > /dev/null 2>&1
	stop_spinner $?
	
	
	start_spinner "ㅤMPY cross compile setup"
	cd mpy-cross/
	make > /dev/null 2>&1
	stop_spinner $?
	
	cd ../..
	
	start_spinner "ㅤExport auto-build firmware script..."
	echo IyEvYmluL2Jhc2gKIyBTZXAgMjgsIDIwMjEsIDAwOjE0OjUxJwoKCiMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tU1BJTiBDT0RFLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0jCgpmdW5jdGlvbiBfc3Bpbm5lcigpIHsKICAgICMgJDEgc3RhcnQvc3RvcAogICAgIwogICAgIyBvbiBzdGFydDogJDIgZGlzcGxheSBtZXNzYWdlCiAgICAjIG9uIHN0b3AgOiAkMiBwcm9jZXNzIGV4aXQgc3RhdHVzCiAgICAjICAgICAgICAgICAkMyBzcGlubmVyIGZ1bmN0aW9uIHBpZCAoc3VwcGxpZWQgZnJvbSBzdG9wX3NwaW5uZXIpCgogICAgbG9jYWwgb25fc3VjY2Vzcz0iRE9ORSIKICAgIGxvY2FsIG9uX2ZhaWw9IkZBSUwiCiAgICBsb2NhbCB3aGl0ZT0iXGVbMTszN20iCiAgICBsb2NhbCBncmVlbj0iXGVbMTszMm0iCiAgICBsb2NhbCByZWQ9IlxlWzE7MzFtIgogICAgbG9jYWwgbmM9IlxlWzBtIgoKICAgIGNhc2UgJDEgaW4KICAgICAgICBzdGFydCkKICAgICAgICAgICAgIyBjYWxjdWxhdGUgdGhlIGNvbHVtbiB3aGVyZSBzcGlubmVyIGFuZCBzdGF0dXMgbXNnIHdpbGwgYmUgZGlzcGxheWVkCiAgICAgICAgICAgIGxldCBjb2x1bW49JCh0cHV0IGNvbHMpLSR7IzJ9LTgKICAgICAgICAgICAgIyBkaXNwbGF5IG1lc3NhZ2UgYW5kIHBvc2l0aW9uIHRoZSBjdXJzb3IgaW4gJGNvbHVtbiBjb2x1bW4KICAgICAgICAgICAgZWNobyAtbmUgJHsyfQogICAgICAgICAgICBwcmludGYgIiUke2NvbHVtbn1zIgoKICAgICAgICAgICAgIyBzdGFydCBzcGlubmVyCiAgICAgICAgICAgIGk9MQogICAgICAgICAgICBzcD0nXHwvLScKICAgICAgICAgICAgZGVsYXk9JHtTUElOTkVSX0RFTEFZOi0wLjE1fQoKICAgICAgICAgICAgd2hpbGUgOgogICAgICAgICAgICBkbwogICAgICAgICAgICAgICAgcHJpbnRmICJcYiR7c3A6aSsrJSR7I3NwfToxfSIKICAgICAgICAgICAgICAgIHNsZWVwICRkZWxheQogICAgICAgICAgICBkb25lCiAgICAgICAgICAgIDs7CiAgICAgICAgc3RvcCkKICAgICAgICAgICAgaWYgW1sgLXogJHszfSBdXTsgdGhlbgogICAgICAgICAgICAgICAgZWNobyAic3Bpbm5lciBpcyBub3QgcnVubmluZy4uIgogICAgICAgICAgICAgICAgZXhpdCAxCiAgICAgICAgICAgIGZpCgogICAgICAgICAgICBraWxsICQzID4gL2Rldi9udWxsIDI+JjEKCiAgICAgICAgICAgICMgaW5mb3JtIHRoZSB1c2VyIHVwcG9uIHN1Y2Nlc3Mgb3IgZmFpbHVyZQogICAgICAgICAgICBlY2hvIC1lbiAiXGJbIgogICAgICAgICAgICBpZiBbWyAkMiAtZXEgMCBdXTsgdGhlbgogICAgICAgICAgICAgICAgZWNobyAtZW4gIiR7Z3JlZW59JHtvbl9zdWNjZXNzfSR7bmN9IgogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAgICBlY2hvIC1lbiAiJHtyZWR9JHtvbl9mYWlsfSR7bmN9IgogICAgICAgICAgICBmaQogICAgICAgICAgICBlY2hvIC1lICJdIgogICAgICAgICAgICA7OwogICAgICAgICopCiAgICAgICAgICAgIGVjaG8gImludmFsaWQgYXJndW1lbnQsIHRyeSB7c3RhcnQvc3RvcH0iCiAgICAgICAgICAgIGV4aXQgMQogICAgICAgICAgICA7OwogICAgZXNhYwp9CgpmdW5jdGlvbiBzdGFydF9zcGlubmVyIHsKICAgICMgJDEgOiBtc2cgdG8gZGlzcGxheQogICAgX3NwaW5uZXIgInN0YXJ0IiAiJHsxfSIgJgogICAgIyBzZXQgZ2xvYmFsIHNwaW5uZXIgcGlkCiAgICBfc3BfcGlkPSQhCiAgICBkaXNvd24KfQoKZnVuY3Rpb24gc3RvcF9zcGlubmVyIHsKICAgICMgJDEgOiBjb21tYW5kIGV4aXQgc3RhdHVzCiAgICBfc3Bpbm5lciAic3RvcCIgJDEgJF9zcF9waWQKICAgIHVuc2V0IF9zcF9waWQKfQoKIyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSMKCgp0aXRsZT0iTWljcm9weXRob24gRmlybXdhcmUgQ3JlYXRvciAiCmJvYXJkPSJbRVNQMzJdIgoKcmVkPSJcZVsxOzMxbSIKYmx1ZT0iXGVbMTszNG0iCm5jPSJcZVswbSIKCgpjbGVhcgplY2hvICIiCmVjaG8gLWVuICIJICAke3JlZH0ke3RpdGxlfSR7Ymx1ZX0ke2JvYXJkfSR7bmN9IiB8IHNlZCAgLWUgOmEgLWUgInMvXi5cezEsJCh0cHV0IGNvbHMpXH0kLyAmIC87dGEiIHwgdHIgLWQgJ1xuJyB8IGhlYWQgLWMgJCh0cHV0IGNvbHMpCmVjaG8gIiIKZWNobyAiIgplY2hvICIiCgojCgpzdGFydF9zcGlubmVyICLjhaRHZXR0aW5nIGVzcC1pZGYgZXhwb3J0Li4uIgoJY2QgZXNwLWlkZgoJc291cmNlICdleHBvcnQuc2gnID4gL2Rldi9udWxsIDI+JjEKc3RvcF9zcGlubmVyICQ/CgojCgpzdGFydF9zcGlubmVyICLjhaRHZXR0aW5nIG1pY3JvcHl0aG9uIHVwZGF0ZS4uLiIKCWNkIC4uCgljZCBtaWNyb3B5dGhvbgoJZ2l0IHB1bGwgPiAvZGV2L251bGwgMj4mMQpzdG9wX3NwaW5uZXIgJD8KCiMKCnN0YXJ0X3NwaW5uZXIgIuOFpENsZWFuaW5nIGJ1aWxkIHNwYWNlLi4uIgoJY2QgcG9ydHMvZXNwMzIKCW1ha2UgY2xlYW4gPiAvZGV2L251bGwgMj4mMQoJbWFrZSBzdWJtb2R1bGVzID4gL2Rldi9udWxsIDI+JjEKc3RvcF9zcGlubmVyICQ/CgojCgpzdGFydF9zcGlubmVyICLjhaRDb21waWxpbmcgZmlybXdhcmUgKHRoaXMgdGFrZXMgYXdoaWxlKSAuLi4iCgltYWtlID4gL2Rldi9udWxsIDI+JjEKCSMgbWFrZSBVU0VSX0NfTU9EVUxFUz0gfi9zdDc3ODlfbXB5L3N0Nzc4OS9taWNyb3B5dGhvbi5jbWFrZSBhbGwgPiAvZGV2L251bGwgMj4mMQpzdG9wX3NwaW5uZXIgJD8KCiMKCnN0YXJ0X3NwaW5uZXIgIuOFpFVwbG9hZGluZyB0byBib2FyZC4uLiIKZXNwdG9vbC5weSAtcCAvZGV2L3R0eVVTQjAgLWIgNDYwODAwIC0tYmVmb3JlIGRlZmF1bHRfcmVzZXQgLS1hZnRlciBoYXJkX3Jlc2V0IC0tY2hpcCBlc3AzMiAgd3JpdGVfZmxhc2ggLS1mbGFzaF9tb2RlIGRpbyAtLWZsYXNoX3NpemUgZGV0ZWN0IC0tZmxhc2hfZnJlcSA0MG0gMHgxMDAwIGJ1aWxkLUdFTkVSSUMvYm9vdGxvYWRlci9ib290bG9hZGVyLmJpbiAweDgwMDAgYnVpbGQtR0VORVJJQy9wYXJ0aXRpb25fdGFibGUvcGFydGl0aW9uLXRhYmxlLmJpbiAweDEwMDAwIGJ1aWxkLUdFTkVSSUMvbWljcm9weXRob24uYmluID4gL2Rldi9udWxsIDI+JjEKc3RvcF9zcGlubmVyICQ/CgplY2hvICIiCmVjaG8gIiIK | base64 --decode > micro_build.sh
	chmod +x micro_build.sh
	stop_spinner $?
   
	echo
	echo
	echo   
	read -p "Press [Enter] key to exit"
   
fi
