#! "$__interpreter"

# This Source Code Form is subject to the terms of the Mozilla Public License,
# v2.0. If a copy of the MPL was not distributed with this file, You can obtain one
# at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2018-2019 Contributors as noted in the AUTHORS file.

source "$__install_dir"/lib/p_utils.sh


documentation=$(cat <<'EOF'

Description

    A set of useful commands to work with Git.


Example

    # In a script, just source this file:
    source ./gt_utils.sh

    # It's now possible to call whatever utility
    # has been defined in h_utils.sh. E.g:
    ut::gt::show_graph_of_commits


Input


Output


Side effects




EOF
)


# $ ut::git_show_graph_of_commits
ut::gt::show_graph_of_commits() {
    ut::p::eval 'git log --graph --color --decorate --oneline --all' "line $LINENO"
}


ut::p::not_sourced_err
