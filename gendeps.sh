#!/bin/sh
exec qlist --exact "$@" | sudo scanelf --needed --quiet --use-ldpath --format '%n#F' | tr ',' '\n' | sort -u | qfile -S --from - | cut -d" " -f1 | sort -u
