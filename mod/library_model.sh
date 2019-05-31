#! "$__interpreter"

# This Source Code Form is subject to the terms of the Mozilla Public License,
# v2.0. If a copy of the MPL was not distributed with this file, You can obtain one
# at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2018-2019 Contributors as noted in the AUTHORS file.


source "$__install_dir"/lib/p_utils.sh
if [[ "$?" -ne 0 ]]; then
    echo "error::$BASH_SOURCE could not load p_utils.sh. Exit." >&2
    exit 1
fi


documentation=$(cat <<'EOF'

Description

    □


Example

    □


EOF
)


# $ ut::m::my_echo() "something"
# something
ut::m::my_echo() {
    local msg="$1"
    echo "$msg"
}


ut::p::not_sourced_err
