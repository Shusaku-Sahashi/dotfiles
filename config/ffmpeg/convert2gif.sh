#!/bin/bash

#####
# This converts a movie file into gif file by using ffmpeg.
# The gif file is created in the same directory of input file.
#####

set -e

if command -v ffmpeg >/dev/null 2>&1; then
  echo "Couldn't find ffmpeg, please install it."
fi

if [[ $# -ne 2 ]]; then
  echo "convert2gif path_to_file [output_file_name]"
fi

if [[ "$2" == *.gif ]]; then
  echo "output_file must be end with '.gif' extension"
fi

DIR_PATH=$(dirname "$1")
DIF_FILE_NAME=${2:-$(uuidgen).gif}

ffmpeg -i "$1" -r 24 -vf "scale=1280:-1" "${DIR_PATH}/${DIF_FILE_NAME}"
