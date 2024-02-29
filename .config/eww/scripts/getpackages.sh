#!/bin/bash

installed=$(equery list @world | wc -l)
doas emerge --sync >/dev/null
old="$(emerge --pretend --update --verbose --changed-use --deep --newuse --complete-graph --with-bdeps=y --backtrack=30 --verbose-conflicts @world 2>/dev/null | rg "Total: ")"

printf '{"installed":"%s","old":"%s"}\n' \
    "$installed" "$old"
