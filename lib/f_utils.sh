#! "$__interpreter"

# This Source Code Form is subject to the terms of the Mozilla Public License,
# v2.0. If a copy of the MPL was not distributed with this file, You can obtain one
# at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2018-2019 Contributors as noted in the AUTHORS file.


source "$__install_dir"/lib/p_utils.sh


documentation=$(cat <<'EOF'

Description

    A set of useful commands to work with files.


Example

    # In a script, just source this file:
    source "$__install_dir"/lib/f_utils.sh

    # It's now possible to call whatever utility
    # has been defined in h_utils.sh. E.g:
    ut::f::filename "/ok/nice.tar.gz"


Input


Output


Side effects




EOF
)


# $ ut::f::filename "/ok/nice.tar.gz"
#   nice.tar.gz
ut::f::filename() {
    local file_path="$1"
    echo "${file_path##*/}"
}


# $ ut::f::extension "/ok/nice.tar.gz"
#   tar.gz
ut::f::extension() {
    local file_path="$1"
    local file_name="$(ut::f::filename $file_path)"
    echo "${file_name#*.}"
}


# $ ut::f::last_extension "/ok/nice.tar.gz"
#   gz
ut::f::last_extension() {
    local file_path="$1"
    local file_name="$(ut::f::filename $file_path)"
    echo "${file_name##*.}"
}


# $ ut::f::filename_no_extension "/ok/nice.tar.gz"
#   nice
ut::f::filename_no_extension() {
    local file_path="$1"
    local extension="$(ut::f::extension $file_path)"
    local file_name="$(ut::f::filename $file_path)"
    echo "${file_name%.$extension}"
}


# $ ut::f::filename_no_extension "/ok/nice.tar.gz"
#   nice.tar
ut::f::filename_no_last_extension() {
    local file_path="$1"
    local extension="$(ut::f::last_extension $file_path)"
    local file_name="$(ut::f::filename $file_path)"
    echo "${file_name%.$extension}"
}


# $ ut::f::add_version ./ok.txt
#   ./ok_v-a9b12345.txt
ut::f::add_version() {
    file_path="$1"
    ut::p::no_file_err "$file_path"
    ut::p::eval "version_nb=\$(sha256sum \"\$file_path\" | cut -d ' ' -f 1 | cut -c1-8)" "line $LINENO"
    ut::p::eval 'dir_path=$(dirname $file_path)' "line $LINENO"
    ut::p::eval 'file_name=$(ut::f::filename $file_path)' "line $LINENO"
    ut::p::eval 'extension=$(ut::f::extension $file_name)' "line $LINENO"
    ut::p::eval 'file_name_wo_extension=$(ut::f::filename_no_extension $file_name)' "line $LINENO"
    new_file_name="${file_name_wo_extension}_v-${version_nb}.${extension}"
    new_path="${dir_path}/${new_file_name}"
    ut::p::eval "cp \"$file_path\" \"$new_path\"" "line $LINENO"
    echo "$new_path"
}


# $ convert_file_to_utf8 ./some/file.txt
ut::f::convert_file_to_utf8 () {
    file_path="$1"
    iconv -f 'US-ASCII' -t UTF-8 "$file_path" | dos2unix > "${file_path}.unix.utf8"
}


ut::p::not_sourced_err
