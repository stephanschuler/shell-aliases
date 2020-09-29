#!/bin/zsh


function _beep() {
    local char
    while read -u0 char; do
        echo -n '\a'
        echo $char
    done
}
alias beep=_beep
