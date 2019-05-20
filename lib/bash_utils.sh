#! "$__interpreter"

# This Source Code Form is subject to the terms of the Mozilla Public License,
# v2.0. If a copy of the MPL was not distributed with this file, You can obtain one
# at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2018-2019 Contributors as noted in the AUTHORS file.


source "$__install_dir"/lib/p_utils.sh
source "$__install_dir"/lib/h_utils.sh
source "$__install_dir"/lib/f_utils.sh
source "$__install_dir"/lib/g_utils.sh
source "$__install_dir"/lib/s_utils.sh
source "$__install_dir"/lib/gt_utils.sh
source "$__install_dir"/lib/gx_utils.sh


documentation=$(cat <<'EOF'

Description

    A set of useful commands to build bash scripts.


Example

    # In a script, just source this file:
    source "$__install_dir"/lib/bash_utils.sh

    # Then, call ut::p::setup
    ut::p::setup

    # It's now possible to call whatever utility
    # has been defined in bash_utils.sh. E.g:
    ut::p::err "A nice error message."


Input


Output


Side effects




EOF
)


ut::p::not_sourced_err
ut::p::list_functions "ut::"
