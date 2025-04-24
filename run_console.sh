#!/bin/bash

cleanup() {
  rm -f "$input_file" "$output_file"
  kill $TAIL_PID 2>/dev/null
}

while getopts "n:t:p:" opt; do
  case $opt in
    p) port=$OPTARG ;;
    *) echo "Invalid option"; exit 1 ;;
  esac
done

if [ -z "$port" ]; then
  echo "Error: -p is a required argument."
  exit 1
fi

mkdir -p /tmp/ss_console/

input_file="/tmp/ss_console/${port}.i.ss_console"
output_file="/tmp/ss_console/${port}.o.ss_console"

touch "$input_file" "$output_file"

echo -e "\033[1;37m                                    _         _             _ _       \033[0m"
echo -e "\033[1;37m ___  __ _ _   _  __ _ _ __ ___  __| |    ___| |_ _   _  __| (_) ___  \033[0m"
echo -e "\033[1;37m/ __|/ _' | | | |/ _' | '__/ _ \/ _' |___/ __| __| | | |/ _' | |/ _ \ \033[0m"
echo -e "\033[1;36m\__ \ (_| | |_| | (_| | | |  __/ (_| |___\__ \ |_| |_| | (_| | | (_) |\033[0m"
echo -e "\033[1;36m|___/\__, |\__,_|\__,_|_|  \___|\__,_|   |___/\__|\__,_|\__,_|_|\___/ \033[0m"
echo -e "\033[1;36m        |_|                                                2023-$(date +%Y)\033[0m\n"

echo -e "Monitoring:\n${input_file}\n${output_file}\n"

sleep 2

clear

trap 'cleanup; kill $TAIL_PID; exit' SIGINT

tail -f "$output_file" &

TAIL_PID=$!

while true
do
  read -r user_input
  echo "$user_input" >> "$input_file"
done

