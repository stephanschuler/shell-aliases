#!/bin/zsh


function() {
    local shellAliasPath="$1"
    local shortcutsPath="$shellAliasPath/.folder-shortcuts"

    local shortcut
    local shortName
    local target

    for shortcut in $shortcutsPath/* ;
    do
        if [ -L $shortcut ] ;
        then
            shortName=`echo $shortcut | awk -F/ '{ print $NF}'`
            target=`ls -l $shortcut | awk '{print $NF}'`
            alias $shortName="cd $target"
        fi
    done;
} $1
