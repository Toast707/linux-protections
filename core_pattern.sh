#!/bin/sh

# Keywords para core_pattern
#     %p: pid
#     %: '%' is dropped
#     %%: output one '%'
#     %u: uid
#     %g: gid
#     %s: signal number
#     %t: UNIX time of dump
#     %h: hostname
#     %e: executable filename
#     %: both are dropped

[[ $(id -u) -ne 0 ]] && {
  echo "got r00t?"
  exit 1
}

pat='%e.%t.pid%p.sig%s.core'

echo -ne ">> Seting core pattern=\"\e[33m$pat\e[0m\" ... "

sysctl -q -w kernel.core_pattern="$pat" \
    && echo -e "\e[32m✔\e[0m" \
    || echo -e "\e[31m✘\e[0m"

exit $?
