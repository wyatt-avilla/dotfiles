#!/bin/bash

masterInfo=$(amixer -M get PCM,0 | grep "Front Left:")
echo "$masterInfo" | sed -n 's/.*\[\(.*\)%\].*/\1/p'
