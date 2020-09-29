#!/bin/zsh


 _shellAliasesDirectroy=`dirname $0`


function() {
    local shellAlias
    for shellAlias in $_shellAliasesDirectroy/src/*.zsh; do
        source $shellAlias $_shellAliasesDirectroy
    done
}


alias shell-aliases="code -n $_shellAliasesDirectroy/include.zsh $_shellAliasesDirectroy/src/*.zsh"