#! /usr/bin/env sh

exit 100
find blocks/ -type f -executable | xargs shellcheck -s sh
