#!/bin/bash

# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$

# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$
INPUT_PROMPT=/tmp/input_prompt.sh.$$
IH=15
TEMP=/tmp/temp_input.sh.$$
# trap and delete temp files
trap "rm $TEMP ; rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT

# decide which dialog to use:
dialogs="dialog kdialog zenity"
my_dial=none
for dial in $dialogs
do
	if [ ! -z $(which $dial) ]
	then
		my_dial=$dial
	fi
done

# create a switch for each command?
function display_info(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title 	
	case $my_dial in
		dialog) dialog --backtitle "non sono bello ma patcho - Laboratorio di Calcolo Numerico" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w};;
		kdialog) kdialog --msgbox --title "${t}" --msgbox "$(<$OUTPUT)" --geometry ${h}x${w};;
		zenity) zenity --info --title "${t}" --text "$(<$OUTPUT)" --width=${w}0 --height=${h}0;;
	esac
}

# main
echo "Grazie per aver scelto non sono bello ma patcho" > $OUTPUT
display_info 5 51 "bye"