#!/bin/bash -eu

files=$(git status --porcelain|grep Chart.yaml|cut -d " " -f 3)

for file in $files
do
  echo "Bumping ${file}..."
  current_version=$(cat $file | grep "^version:" | sed 's/[^0-9\.]//g')
  if [[ ! -z $current_version ]]; then
    major=$(echo "${current_version}" | awk -F '.' '{print $1}')
    minor=$(echo "${current_version}" | awk -F '.' '{print $2}')
    patch=$(echo "${current_version}" | awk -F '.' '{print $3}')
    new_patch=$(( patch + 1 ))
    new_version="${major}.${minor}.${new_patch}"
    echo "${current_version} -> ${new_version}"
    sed -i "s|^version.*|version: ${new_version}|" "${file}"
  fi
done
