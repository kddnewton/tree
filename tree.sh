#!/usr/bin/env bash

shopt -s nullglob

dir_count=0
file_count=0

traverse() {
  dir_count=$(($dir_count + 1))
  local directory=$1
  local prefix=$2

  local children=("$directory"/*)
  local child_count=${#children[@]}

  for idx in "${!children[@]}"; do 
    local child=${children[$idx]}

    local child_prefix="│   "
    local pointer="├── "

    if [ $idx -eq $((child_count - 1)) ]; then
      pointer="└── "
      child_prefix="    "
    fi

    echo "${prefix}${pointer}${child##*/}"
    [ -d "$child" ] &&
      traverse "$child" "${prefix}$child_prefix" ||
      file_count=$((file_count + 1))
  done
}

while getopts "a" o; do case "${o}" in a) show_hidden_files=true; ;; esac; done

echo $show_hidden_files;
shift $((OPTIND-1))

if [ "$show_hidden_files" = true ] ; then shopt -s dotglob; fi

if [ -z "${a}" ] || [ -z "${p}" ]; then
  root="."
  [ "$#" -ne 0 ] && root="$1"
  echo $root
  traverse $root ""
fi

echo
echo "$(($dir_count - 1)) directories, $file_count files"


if [ "$show_hidden_files" = true ] ; then shopt -s dotglob; fi
shopt -u nullglob
unset show_hidden_files;
