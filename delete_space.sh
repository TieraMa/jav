#!/bin/bash
find /data/hdd/JAV -type f -size +500M -name '* *' -print -exec rename " " "" '{}' \;
