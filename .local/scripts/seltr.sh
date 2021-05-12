#!/usr/bin/env bash

to_lang=${1:-"pt-BR"}
from_lang=${2:-"auto"}

CUR_DIR="$(dirname "$(realpath "$0")")"
notify-send -u normal -t 15000 -i applications-education-language "$(python3 $CUR_DIR/seltr.py "$(xsel -o | sed "s/[\"'<>]//g")" $to_lang $from_lang)"
