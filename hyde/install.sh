#!/usr/bin/env bash
set -Eeuo pipefail

######################################################################
## Globals
######################################################################

DOTS_DIR="$HOME/docs/cs/winux-dotfiles"
PACMAN_PACKAGES=(
    yazi neovim tmux trash-cli man-db man-pages
    git git-delta git-lfs # git-filter-repo gitleaks
    clang cmake ninja make gdb cgdb rustup go python npm
    cloc shellcheck shfmt stylua prettier taplo-cli
    flatpak steam ffmpeg
)

######################################################################
## Main
######################################################################

main() {
    printf "[INFO] Running %s\n" "$0"

    # Pre-checks
    ensure_no_sudo
    ensure_no_args "$@"

    # Installation
    make_dirs

    # Install Packages and Applications
    install_pacman_packages
    install_flatpak_packages
    install_apps_from_source
    install_tmux_plugin_manager

    # Configure fonts
    configure_fonts

    # Configure dotfiles
    configure_kitty_dotfiles
    configure_hyde_dotfiles
    configure_hyprland_dotfiles
    configure_zsh_dotfiles
    configure_git_dotfiles
    configure_nvim_dotfiles
    configure_yazi_dotfiles
    configure_npm_dotfiles
    configure_tmux_dotfiles
    configure_gdb_dotfiles
    configure_cgdb_dotfiles

    # Finish
    printf '[DONE] All done.\n'
    exit 0
}

######################################################################
## Core Functions
######################################################################

ensure_no_sudo() {
    if ((EUID == 0)); then
        printf '[FAIL] This utility should not be run as superuser. Exiting.\n' >&2
        exit 1
    fi
    return 0
}

ensure_no_args() {
    if (($# > 0)); then
        printf '[FAIL] This utility takes no arguments. Exiting.\n' >&2
        exit 1
    fi
    return 0
}

make_dirs() {
    printf '[NEXT] Creating basic directories.\n'
    mkdir -p "$HOME"/.config \
        "$HOME"/docs/ \
        "$HOME"/docs/cs \
        "$HOME"/docs/cs/oss \
        "$HOME"/docs/downloads \
        "$HOME"/.local/bin \
        "$HOME"/.local/share
    printf '[DONE] Finished creating basic directories.\n'
    return 0
}

install_pacman_packages() {
    printf '[NEXT] Upgrading Pacman packages.\n'
    sudo pacman -Syu
    printf '[DONE] Finished upgrading Pacman packages.\n'

    printf '[NEXT] Installing Pacman packages.\n'
    sudo pacman -S --needed --noconfirm -- "${PACMAN_PACKAGES[@]}"
    rustup default stable
    printf '[DONE] Finished installing Pacman packages.\n'

    return 0
}
install_flatpak_packages() {
    printf '[NEXT] Installing Flatpak packages.\n'
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    sudo flatpak install --assumeyes flathub com.bitwarden.desktop
    printf '[DONE] Finished installing Flatpak packages.\n'
    return 0
}
install_apps_from_source() {
    printf '[NEXT] Installing applications from source.\n'
    _install_raddbg_from_source
    _install_gf2_from_source
    printf '[DONE] Finished installing applications from source.\n'
    return 0
}
install_tmux_plugin_manager() {
    printf '[NEXT] Installing TMUX Plugin Manager.\n'
    mkdir -p "$HOME/.tmux/plugins"
    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [[ -d "$tpm_dir" ]]; then
        printf "[SKIP] Directory exists: %s.\n" "$tpm_dir"
        return 0
    fi
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    printf '[DONE] Finished installing TMUX Plugin Manager.\n'
    return 0
}

configure_fonts() {
    printf '[NEXT] Configuring fonts.\n'
    cp -r "$DOTS_DIR/common/fonts/." "$HOME/.local/share/fonts"
    fc-cache -f
    printf '[DONE] Finished configuring fonts.\n'
    return 0
}

configure_kitty_dotfiles() {
    printf '[NEXT] Configuring Kitty dotfiles.\n'
    local config='.config/kitty/kitty.conf'
    _create_reg_file_symlink "$DOTS_DIR/hyde/home/$config" "$HOME/$config"
    printf '[DONE] Finished configuring Kitty dotfiles.\n'
    return $?
}
configure_hyde_dotfiles() {
    printf '[NEXT] Configuring HyDE dotfiles.\n'
    local config='.config/hyde/config.toml'
    _create_reg_file_symlink "$DOTS_DIR/hyde/home/$config" "$HOME/$config"
    printf '[DONE] Finished configuring HyDE dotfiles.\n'
    return 0
}
configure_hyprland_dotfiles() {
    printf '[NEXT] Configuring Hyprland dotfiles.\n'

    local configs=(
        '.config/hypr/hyprland.lua'
        '.config/hypr/hypridle.conf'
        '.config/hypr/hyprlock/holychowders.conf'
    )
    local config
    for config in "${configs[@]}"; do
         _create_reg_file_symlink "$DOTS_DIR/hyde/home/$config" "$HOME/$config"
    done

    hyde-shell animations --set Minimal-2

    printf '[DONE] Finished configuring Hyprland dotfiles.\n'
    return 0
}
configure_zsh_dotfiles() {
    printf '[NEXT] Configuring Zsh dotfiles.\n'
    local configs=(
        '.config/zsh/.zshrc'
        '.config/zsh/user.zsh'
    )
    local config
    for config in "${configs[@]}"; do
         _create_reg_file_symlink "$DOTS_DIR/hyde/home/$config" "$HOME/$config"
    done
    printf '[DONE] Finished configuring Zsh dotfiles.\n'
    return 0
}
configure_git_dotfiles() {
    printf '[NEXT] Configuring Git dotfiles.\n'
    local configs=(
        'themes.gitconfig'
        '.gitconfig'
    )
    local config
    for config in "${configs[@]}"; do
         _create_reg_file_symlink "$DOTS_DIR/common/home/$config" "$HOME/$config"
    done
    printf '[DONE] Finished configuring Git dotfiles.\n'
    return 0
}
configure_nvim_dotfiles() {
    printf '[NEXT] Configuring NeoVIM dotfiles.\n'
    # FIXME: Symlink creation is wrong since this deals with directories.
    _create_reg_file_symlink "$DOTS_DIR/common/home/.config/nvim" "$HOME/.config/nvim"
    printf '[DONE] Finished configuring NeoVIM dotfiles.\n'
    return 0
}
configure_yazi_dotfiles() {
    printf '[NEXT] Configuring Yazi dotfiles.\n'
    # FIXME: Symlink creation is wrong since this deals with directories.
    _create_reg_file_symlink "$DOTS_DIR/common/home/.config/yazi" "$HOME/.config/yazi"
    printf '[DONE] Finished configuring Yazi dotfiles.\n'
    return 0
}
configure_npm_dotfiles() {
    printf '[NEXT] Configuring NPM dotfiles.\n'
    _create_reg_file_symlink "$DOTS_DIR/common/home/.npmrc" "$HOME/.npmrc"
    printf '[DONE] Finished configuring NPM dotfiles.\n'
    return 0
}
configure_tmux_dotfiles() {
    printf '[NEXT] Configuring TMUX dotfiles.\n'
    _create_reg_file_symlink "$DOTS_DIR/hyde/home/.tmux.conf" "$HOME/.tmux.conf"
    printf '[DONE] Finished configuring TMUX dotfiles.\n'
    return 0
}
configure_gdb_dotfiles() {
    printf '[NEXT] Configuring GDB dotfiles.\n'
    _create_reg_file_symlink "$DOTS_DIR/hyde/home/.gdbinit" "$HOME/.gdbinit"
    printf '[DONE] Finished configuring GDB dotfiles.\n'
    return 0
}
configure_cgdb_dotfiles() {
    printf '[NEXT] Configuring CGDB dotfiles.\n'
    mkdir -p "$HOME"/.cgdb
    _create_reg_file_symlink "$DOTS_DIR/hyde/home/.cgdb/cgdbrc" "$HOME/.cgdb/cgdbrc"
    printf '[DONE] Finished configuring CGDB dotfiles.\n'
    return 0
}

######################################################################
## Helpers
######################################################################

_create_reg_file_symlink() {
    local src="$1" dst="$2" answer

    # FIXME: Check that source file exists.
    #
    # NOTE: We may want to link non-existent source files for convenience.
    #       Maybe warn instead.
    #
    if [[ -e "$dst" || -L "$dst" ]]; then
        read -r -p "[CONF] Overwrite configuration at $dst? [y/N] " answer
        if [[ "$answer" != [yY] ]]; then
            printf "[SKIP] Skipped %s.\n" "$dst"
            return 0
        fi
    fi

    ln -sfT -- "$src" "$dst"
}

_install_raddbg_from_source() {
    local project_dir="$HOME/docs/cs/oss/raddebugger"
    # FIXME: Maybe don't cancel this installation unit just because of this.
    if [[ -d "$project_dir" ]]; then
        printf "[SKIP] Source directory exists for RAD Debugger: %s.\n" "$project_dir"
        return 0
    fi

    printf '[NEXT] Installing RAD Debugger from source.\n'

    # Dependencies
    git clone https://github.com/EpicGames/raddebugger.git "$project_dir"
    sudo pacman -S --needed --noconfirm clang llvm
    sudo pacman -S --needed --noconfirm freetype2 libx11 libxext libxfixes libxrandr libglvnd

    # Build
    pushd "$project_dir"
    ./build.sh release
    popd

    # Symlinks
    _create_reg_file_symlink "$project_dir/build/raddbg" "$HOME/.local/bin/raddbg"
    _create_reg_file_symlink "$DOTS_DIR/hyde/home/.local/share/applications/raddbg.desktop" "$HOME/.local/share/applications/raddbg.desktop"

    # Finish
    printf '[DONE] Finished installing RAD Debugger from source.\n'
    return 0
}
_install_gf2_from_source() {
    local project_dir="$HOME/docs/cs/oss/gf"
    # FIXME: Maybe don't cancel this installation unit just because of this.
    if [[ -d "$project_dir" ]]; then
        printf "[SKIP] Source directory exists for gf2: %s.\n" "$project_dir"
        return 0
    fi

    printf '[NEXT] Installing gf2 from source.\n'

    git clone https://github.com/nakst/gf.git "$HOME/docs/cs/oss/gf"
    pushd "$HOME/docs/cs/oss/gf"
    ./build.sh
    popd

    _create_reg_file_symlink "$HOME/docs/cs/oss/gf/gf2" "$HOME/.local/bin/gf2"
    _create_reg_file_symlink "$DOTS_DIR/hyde/home/.local/share/applications/gf2.desktop" "$HOME/.local/share/applications/gf2.desktop"

    printf '[DONE] Finished installing gf2 from source.\n'
    return 0
}

######################################################################
## Launch
######################################################################

main "$@"
