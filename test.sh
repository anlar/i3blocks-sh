#! /usr/bin/env sh

find . -maxdepth 2 -mindepth 2 -type f -executable | xargs shellcheck -s sh
