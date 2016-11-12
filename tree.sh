#!/usr/bin/env bash
# Depends on having `expr` and `ls` in the path

dir_count=0
file_count=0

traverse() {
  dir_count=$(expr $dir_count + 1)
  local directory=$1
  local prefix=$2

  local children=($(ls $directory))
  local child_count=${#children[@]}

  for idx in "${!children[@]}"; do 
    local child="${children[$idx]}"
    local child_prefix="│   "
    local pointer="├── "

    if [ $idx -eq $(expr ${#children[@]} - 1) ]; then
      pointer="└── "
      child_prefix="    "
    fi

    echo "${prefix}${pointer}$child"
    [ -d "$directory/$child" ] &&
      traverse "$directory/$child" "${prefix}$child_prefix" ||
      file_count=$(expr $file_count + 1)
  done
}

root="."
[ "$#" -ne 0 ] && root="$1"
echo $root

traverse $root ""
echo
echo "$(expr $dir_count - 1) directories, $file_count files"

