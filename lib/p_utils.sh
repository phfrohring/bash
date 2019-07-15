#! "$__interpreter"

# This Source Code Form is subject to the terms of the Mozilla Public License,
# v2.0. If a copy of the MPL was not distributed with this file, You can obtain one
# at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2018-2019 Contributors as noted in the AUTHORS file.


documentation=$(cat <<'EOF'

Description

    A set of useful commands to build bash scripts.


Example

    # In a script, just source this file:
    source /home/phf/bash/lib/p_utils.sh

    # Then, call ut::p::setup
    ut::p::setup

    # It's now possible to call whatever utility
    # has been defined in bash_utils.sh. E.g:
    ut::p::err "msg: A nice error message."


EOF
             )


ut::p::debug() {
    set -x
    export PS4='+$BASH_SOURCE:$LINENO:${FUNCNAME:-}: '
}


ut::p::steps() {

    : 'Show the line and ask user before executing anything starting from this call.'


    trap '(read -p "scrip_path: $BASH_SOURCE line: $LINENO cmd: $BASH_COMMAND ?")' DEBUG
}



ut::p::err() {

    : '

    $ ut::p::err "msg: message" "key: val"
      error
        date: 2019-05-31T17:21:52+0200
        script_path: /home/phf/bash/bin/test_script
        msg: message
        key: val
    '

    : 'For each level of sourcing, a new element is added to the beginning of the
    BASH_SOURCE array, so that ${BASH_SOURCE[0]} is always the current source file
    and ${BASH_SOURCE[1]} the one that it was sourced from (and ${BASH_SOURCE[2]} the
    one that it was sourced from, if it was sourced). To get at the main script, look
    at ${BASH_SOURCE[-1]}, the last element.

    ${a[${#a[@]}-1]} is equivalent to ${a[-1]} but works in bash.version < 4.0'

    local script_path="${BASH_SOURCE[${#BASH_SOURCE[@]}-1]}"
    err_msg="error\n  date: $(date +'%Y-%m-%dT%H:%M:%S%z')\n  script_path: $script_path\n  "
    for key_val in "$@"; do
        err_msg="${err_msg}${key_val}\n  "
    done

    echo -e "$err_msg"
}


ut::p::exit_1() {

    : 'Let exit the script even when called from sub shell i.e. (ut::p::exit_1)'


    eval "$__exit_1"
}


ut::p::on_error() {

    : 'Prints an error when an error is detected and exits the script.'

    read -r line file <<<"$(caller)"
    culprit=$(sed "${line}q;d" "$file")
    ut::p::err "line: $line" "command: $culprit"
    ut::p::exit_1
}


ut::p::on_exit() {

    : 'Replace this line by code to be executed after the script exited.'

}


ut::p::on_term() {

    exit 1

}


ut::p::setup() {
    set -ou >/dev/null


    : 'https://kuntalchandra.wordpress.com/2017/06/12/bash-trap-error-and-exit/'
    readonly __top_pid="$$"
    readonly __exit_1="kill -s TERM ${__top_pid}"


    trap 'ut::p::on_error' ERR
    trap 'ut::p::on_term' TERM


    : 'see: http://redsymbol.net/articles/bash-exit-traps/

       Allows to do cleanup operation after the script exited.
       you may redefine that in sourcing script.'
    trap 'ut::p::on_exit' EXIT
}


ut::p::err_exit() {
    ut::p::err "$@"
    ut::p::exit_1
}


ut::p::err_notify_exit() {
    notify-send "$@"
    ut::p::err_exit "$@"
}


# ut::p::no_file_err /path/to/file.txt
ut::p::no_file_err() {
    local file_path="$1"
    if [[ ! -f "$file_path" ]]; then
        ut::p::err_exit "msg: file_path should exit but does not." "file_path: $file_path"
    fi
}


ut::p::no_dir_err() {
    local dir_path="$1"
    if [[ ! -d "$dir_path" ]]; then
        ut::p::err_exit "msg: dir_path should exit but does not." "dir_path: $dir_path"
    fi
}


ut::p::no_exists_err() {
    local thing_path="$1"
    if [[ ! -e "$thing_path" ]]; then
        ut::p::err_exit "msg: thing_path should exit but does not." "thing_path: $thing_path"
    fi
}


ut::p::exists_err() {
    local thing_path="$1"
    if [[ -e "$thing_path" ]]; then
        ut::p::err_exit "msg: thing_path should not exit but does." "thing_path: $thing_path"
    fi
}


ut::p::dir_err() {
    local dir_path="$1"
    if [[ -d "$dir_path" ]]; then
        ut::p::err_exit "msg: dir_path should not exit but does." "dir_path: $dir_path"
    fi
}


# $ command_exists gpg
#   true | false
ut::p::command_exists() {
    local command="$1"
    local result="false"

    if hash "$command" >/dev/null 2>&1; then
        result="true"
    fi


    if type "$command" >/dev/null 2>&1; then
        result="true"
    fi


    echo "$result"
}


# $ ut::p::list_functions "ut::p::"
ut::p::list_functions() {
    if hash ag 2>/dev/null; then
        declare -F | ag "$1"
    else
        declare -F | grep "$1"
    fi
}


ut::p::not_sourced_err() {
    if [[ "$0" == "${BASH_SOURCE[0]}" ]]; then
        ut::p::setup
        local msg="This script should be sourced in an other script, not executed by itself. script: ${BASH_SOURCE[0]}"
        ut::p::err_exit "msg: $msg" "documentation: $documentation"
    fi
}


ut::p::box_comment() {
    local marker="*"
    local msg="$marker $1 $marker"
    local length="${#msg}"
    local line=$(head -c "$length" < /dev/zero | tr '\0' "$marker")

    echo "$line"
    echo "$msg"
    echo "$line"
}


ut::p::debug_box_comment() {
    local msg="$1"
    if [[ "$__debug" == "true" ]]; then
        ut::p::box_comment "$msg"
    fi
}


ut::p::debug_comment() {
    if [[ "$__debug" == "true" ]]; then
        local msg="$@"
        echo "$msg"
        echo ""
    fi
}


ut::p::debug_var() {
    if [[ "$__debug" == "true" ]]; then

        if [[ "$#" -ne 1 ]]; then
            ut::p::err_exit "expected: 1 arguments" \
                            "received: $# arguments" \
                            "function: ${FUNCNAME[0]}"
        fi

        local var="${1}"
        local value="$(eval echo \${${var}})"
        echo "${var}: ${value}"
        echo ""

    fi
}



ut::p::debug_step() {
    if [[ "$__debug" == "true" ]]; then
        echo ""
        local msg="$@"
        ut::p::debug_box_comment "$msg"
        echo ""
    fi
}


ut::p::list_system_config() {
    lsb_release -a
    uname -arv
    locale
}


# $ ask_permission
# => granted | denied | undefined
ut::p::ask_permission() {
    read -r -p "Continue (y/n)? "
    case "$REPLY" in
        y|Y ) echo "granted" ;;
        n|N ) echo "denied" ;;
        * )   echo "undefined" ;;
    esac
}


ut::p::not_sourced_err
