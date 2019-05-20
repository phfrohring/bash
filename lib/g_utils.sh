#! "$__interpreter"

# This Source Code Form is subject to the terms of the Mozilla Public License,
# v2.0. If a copy of the MPL was not distributed with this file, You can obtain one
# at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2018-2019 Contributors as noted in the AUTHORS file.

source "$__install_dir"/lib/p_utils.sh


documentation=$(cat <<'EOF'

Description

    A set of useful commands to work with GPG.


Example

    # In a script, just source this file:
    source "$__install_dir"/lib/g_utils.sh

    # It's now possible to call whatever utility
    # has been defined in g_utils.sh. E.g:
    ut::g::list_pub_keys


Input


Output


Side effects


EOF
             )


ut::g::list_pub_keys() {
    gpg2 --list-keys
}


ut::g::create_pub_priv_key() {
    gpg2 --full-generate-key
}


ut::g::list_priv_keys() {
    gpg2 --list-secret-keys --keyid-format LONG
}


ut::g::pub_key_to_ascii() {
    # key id can be found using `ut::g::list_pub_keys`
    local key_id="$1"
    gpg2 --armor --export "$key_id"
}


ut::g::create_revocation_certificate() {
    # key id can be found using `ut::g::list_priv_keys`
    local key_id="$1"
    gpg2 --output revoke.asc --gen-revoke "$key_id"
}


ut::g::import_keys() {

    local documentation=$(cat <<'EOF'
Description:

    Import some public keys into the local keyring.

    It's important to verify that the public keys actually match
    the one distributed by the owner of the key, maybe physically.

    Else, we are not sure that (entity, pub-key) association is correct.

    Assuming this association is correct then we need to sign this association
    so we do not have to do it again.

    It's done by issuing:
      gpg --edit-key $key_id
      > frp # manually check fingerprint
      > sign # sign association
      > quit


Example:

    ut::g::import_keys /some/keys.pgp


Input:



Output:



Side effects:



EOF
                 )


    local keys_file_path="$1"
    gpg2 --import "$keys_file_path"
}


ut::g::encrypt_doc() {
    local doc_path="$1"
    local pub_key_id="$2"

    gpg2 --output "$doc_path".gpg --encrypt --recipient "$pub_key_id" "$doc_path"
}


ut::g::decrypt_doc() {
    local doc_path="$1"
    local dir_path=$(dirname "$doc_path")
    local doc_name=$(ut::get_filename_without_extension "$doc_path")
    local clear_doc_path="$dir_path"/"$doc_name"
    gpg2 --output "$clear_doc_path" --decrypt "$doc_path"
}


ut::g::verify() {
    local doc_path="$1"
    local signature_path="$2"
    gpg2 --verify "$signature_path" "$doc_path"
}


ut::p::not_sourced_err
