#! "$__interpreter"

# This Source Code Form is subject to the terms of the Mozilla Public License,
# v2.0. If a copy of the MPL was not distributed with this file, You can obtain one
# at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2018-2019 Contributors as noted in the AUTHORS file.

source "$__install_dir"/lib/p_utils.sh


documentation=$(cat <<'EOF'

Description

    A set of useful commands to work with encryption related things (ssh …).


Example

    # In a script, just source this file:
    source "$__install_dir"/lib/s_utils.sh

    # It's now possible to call whatever utility
    # has been defined in h_utils.sh. E.g:
    ut::s::load_ssh_key ~/.ssh/some_key


Input


Output


Side effects




EOF
)


#   $ load_ssh_key ~/.ssh/blog_454d_ed25519
ut::s::load_ssh_key () {
    secret_key_path="$1"
    ut::p::eval 'fingerprint=$(ssh-keygen -lf "$secret_key_path")' "line $LINENO"

    ssh-add -l | grep -q "$fingerprint" >/dev/null
    if [[ "$?" -eq 0 ]]; then
        echo "key is loaded: $secret_key_path"
    else
        ut::p::eval 'ssh-add "$secret_key_path"' "line $LINENO"
    fi
}


ut::s::generate_ssh_keys() {
    ut::p::eval 'ssh-keygen -o -a 100 -t ed25519' "line $LINENO"
}


ut::p::not_sourced_err
