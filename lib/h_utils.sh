#! "$__interpreter"

# This Source Code Form is subject to the terms of the Mozilla Public License,
# v2.0. If a copy of the MPL was not distributed with this file, You can obtain one
# at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2018-2019 Contributors as noted in the AUTHORS file.


source "$__install_dir"/lib/p_utils.sh


documentation=$(cat <<'EOF'

Description

    A set of useful commands to work with hashes (sha256sum …)


Example

    # In a script, just source this file:
    source "$__install_dir"/lib/h_utils.sh

    # It's now possible to call whatever utility
    # has been defined in h_utils.sh. E.g:
    ut::h::sha256 /path/to/file


Input


Output


Side effects




EOF
)


# ut::h::sha256 /path/to/file
# 16qs321q53sd...
ut::h::sha256() {
    local file_path="$1"
    echo $(sha256sum "$file_path" | cut -d ' ' -f 1)
}


# ut::h::verify_sha256 "16qs321q53sd..." /path/to/file
# => false | true
ut::h::verify_sha256() {
    local expected_sha256="$1"


    local file_path="$2"
    ut::p::no_file_err "$file_path"


    local actual_sha256=$(ut::h::sha256 "$file_path")
    if [[ "$actual_sha256" == "$expected_sha256" ]]; then
        echo "true"
    else
        echo "false"
    fi
}


# ut::h::verify_sha256 "16qs321q53sd..." /path/to/file
# => false | true
ut::h::verify_sha256_or_exit_1() {
    local expected_sha256="$1"
    local file_path="$2"
    result=$(ut::h::verify_sha256 "$expected_sha256" "$file_path")
    if [[ "$result" != "true" ]]; then
        ut::p::err_exit "::line $LINENO sha256 did not match."
    fi
}


ut::p::not_sourced_err
