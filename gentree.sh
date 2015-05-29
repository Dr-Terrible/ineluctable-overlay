#!/bin/sh

exec tree -dAnS --prune -L 2 -I "skels|metadata|profiles|sets|licenses" "${HOME}"/Dropbox/git-repositories/ineluttabile/ineluctable-overlay/
