#!/bin/bash
if ! [ -f options.txt ]; then # yield on first launch bc I can't figure out a way to get Prism to delay the script until after the game does first-time setup
  exit 0
fi
if ! [ -z "$INST_DIR" ]; then
    script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)
    options_pre=${script_dir}/options_precursor.txt
    keybinds=$(grep key_key $options_pre)
    affected_options="$(cut -d':' -f1 $options_pre)"
fi

IFS=$'\n'
set -f
for option in $affected_options; do  # for each line in options precursor...
  sed -i 's/'"$(grep $option: options.txt)"'/'"$(grep $option: $options_pre)"'/g' options.txt # replace its corresponding line in options.txt with precursor value
done

for option in $keybinds; do
  keybind=${option#*:}
  action=${option%:*}
  sed -i '/^'"${action}"'/! s/'"${keybind}"'/key.keyboard.unknown/g' options.txt  # nullify every line that ends with the bind but doesn't start with the action
done
