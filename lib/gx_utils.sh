#! "$__interpreter"

# This Source Code Form is subject to the terms of the Mozilla Public License,
# v2.0. If a copy of the MPL was not distributed with this file, You can obtain one
# at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2018-2019 Contributors as noted in the AUTHORS file.

source "$__install_dir"/lib/p_utils.sh


documentation=$(cat <<'EOF'

Description

    A set of useful commands to work with Guix.


Example

    # In a script, just source this file:
    source "$__install_dir"/lib/gx_utils.sh

    # It's now possible to call whatever utility
    # has been defined in gx_utils.sh. E.g:
    ut::gx::search "pkg"


Input


Output


Side effects




EOF
)


ut::gx::search() {
    local pkg_name="$1"
    ut::p::eval 'guix search "$pkg_name"' "line $LINENO"
}


ut::gx::definition() {
    local pkg_name="$1"
    ut::p::eval 'guix edit "$pkg_name"' "line $LINENO"
}


ut::gx::load_env() {
    local manifest="$1"
    ut::p::eval 'guix environment --pure -m "$manifest"' "line $LINENO"
}


ut::p::not_sourced_err
