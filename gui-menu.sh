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
		kdialog) kdialog --msgbox --title "${t}" --msgbox "$(<$OUTPUT)" --geometry ${h}x${w} 2>/dev/null;;
		zenity) zenity --info --title "${t}" --text "$(<$OUTPUT)" --width=${w}0 --height=${h}0 2>/dev/null;;
	esac
}

# display menu for each type of interface
function display_menu(){
      while true; do
      	case $my_dial in
      		dialog)
				dialog --title "[ M A I N - M E N U ]" \
				--clear --backtitle "non sono bello ma patcho - Laboratorio di Calcolo Numerico" \
				--menu "You can use the UP/DOWN arrow keys, the first \n\
					letter of the choice as a hot key, or the \n\
					number keys 1-9 to choose an option.\n\
					Choose the TASK" 25 50 14 \
				ex1a " Display exercise 1a" \
				ex1b " Display exercise 1b" \
				ex1c " Display exercise 1c" \
				ex2 "Displays exercise 2" \
				ex3 "Display exercise 3" \
				Exit "Exit to the shell" 2>"${INPUT}";;
			kdialog)
				kdialog --title "Main Menu" \
				--menu "Seleziona la tua scelta, quindi clicca OK\nUsa la scelta \'Exit\' o il pulsante \'Cancel\' per uscire" --geometry 25x50 \
				ex1a " Display exercise 1a" \
				ex1b " Display exercise 1b" \
				ex1c " Display exercise 1c" \
				ex2 "Displays exercise 2" \
				ex3 "Display exercise 3" \
				Exit "Exit to the shell" > "${INPUT}" 2>/dev/null;;
			zenity)
		        zenity --height=250 --width=500 --text "Seleziona la tua scelta, quindi clicca OK\nUsa la scelta \'Exit\' o il pulsante \'Cancel\' per uscire"  --list --column "" --column "Description" --title="Main Menu" \
    	    	ex1 "Display exercise 1" \
    	    	ex2 "Display exercise 2" \
    	    	ex3 "Display exercise 3" \
    	    	Exit "Esci dal Programma" > "${INPUT}" 2> /dev/null ;;
    	esac

    	# Exit program when 'Cancel' is pressed
    	if [ $? -eq 1 ]
    	then
    		break
    	fi

    	menuitem=$(<"${INPUT}")
    	echo "Menu item is: $menuitem"
    	
    	case $menuitem in
    		Exit) break;;
		esac	
      done
}

# main
echo "Grazie per aver scelto non sono bello ma patcho" > $OUTPUT
display_info 5 51 "bye"
display_menu