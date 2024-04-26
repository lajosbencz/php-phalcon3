#!/bin/sh
set -e;

DIR_SOURCE="/usr/lib/php7/modules"
DIR_CONFIG="/etc/php7/conf.d"
PRIORITY_DEFAULT="50"

for so in "${DIR_SOURCE:?}"/*.so; do
  # get basename of so
  name=$(basename "${so}" | sed 's/\.so$//g')
  echo -ne "\033[1;37m${name}\033[0m"
  skip_list=""
#  skip_list="$skip_list apcu event pdo phar simplexml"
  skip_list="opcache"
  do_skip="0"
  for skip in $skip_list; do
    if [ "$name" = "$skip" ]; then
      do_skip="1"
      break
    fi
  done
  if [ "${do_skip}" = "1" ]; then
    # skip
    echo -e "\033[32m S\033[0m"
    continue
  fi
  if [ "$(php -m | grep -ie ^${name}\$)" ]; then
    # loaded
    echo -e "\033[32m L\033[0m"
    continue
  fi
  # enable
  chmod 755 "${so}"
  echo "extension=${name}.so" > "${DIR_CONFIG:?}/${PRIORITY_DEFAULT:-50}_${name}.ini"
  echo -e "\033[32m C\033[0m"
  err="$(php -r 'echo ''Ok'';' 1>/dev/null 2>&1)"
  if [ "${err}" ]; then
    echo -e "\033[31m ${err}\033[0m"
    exit 1
  fi
done
