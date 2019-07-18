#!/bin/bash

#make some temporary files
command_output=$(mktemp)
menu_config=$(mktemp)
menu_output=$(mktemp)

#make sure the temporary files are removed even in case of interruption
trap "rm $command_output;
      rm $menu_output;
      rm $menu_config;" SIGHUP SIGINT SIGTERM

#replace ls with what you want
ls >$command_output

#build a dialog configuration file
cat $command_output |
  awk '{print NR " \"" $0 "\""}' |
  tr "\n" " " >$menu_config

#launch the dialog, get the output in the menu_output file
dialog --no-cancel --title "Put you title here" \
       --menu "Choose the correct entry" 0 0 0 \
       --file $menu_config 2>$menu_output

#revcover the output value
menu_item=$(<$menu_output)

#recover the associated line in the output of the command
entry=$(cat $command_output | sed -n "${menu_item}p" $config_file)

#replace echo with whatever you want to process the chosen entry
echo $entry

#clean the temporary files
[ -f $command_output ] && rm $command_output
[ -f $menu_output ] && rm $menu_output
[ -f $menu_config ] && rm $menu_config
