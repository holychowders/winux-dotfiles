#!/usr/bin/env bash

# TODO

# shfmt: SH, Zsh - Config: .editorconfig
shfmt -w install.sh format.sh home/.config/zsh/*.zsh*

# Stylua: Lua - Config: .editorconfig
stylua home/.config/hypr/*.lua

# Prettier: JSON, YAML - Config: .editorconfig
#prettier

# TOML
taplo fmt .taplo.toml home/.config/hyde/*.toml
