#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Append Memos
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗒️
# @raycast.argument1 { "type": "text", "placeholder": "Take memos" }

current_time=$(date +"%H:%M")
memo=$(echo "$1" | sed 's/ /%20/g' )
vault="Ideastorage"
open --background "obsidian://advanced-uri?vault=${valut}&daily=true&mode=append&data=-%20$current_time%20$memo"
