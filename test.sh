#! /usr/bin/env sh

find blocks/ -type f -executable | xargs shellcheck -s sh
