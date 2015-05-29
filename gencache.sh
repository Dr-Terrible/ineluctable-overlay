#!/bin/sh

exec egencache --repo=ineluctable-overlay --update --update-use-local-desc --jobs=$(( $(nproc) + 1 ))
