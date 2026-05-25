#!/bin/zsh

_local_aliasses=()

function _check_directory_for_local_aliases() {
    local searchPath="$1"

    if [ "$searchPath" = "/" ] || [ "$searchPath" = "" ];
    then
        return
    fi

    local aliasFile=".aliases"

    if [[ -f "$searchPath/$aliasFile" ]];
    then

        local aliasNane

        # Flush previous aliases
        for aliasName in $_local_aliasses ; do
          unalias $aliasName
        done
        _local_aliasses=()

        # Create new aliases
        cat "$searchPath/$aliasFile" | while IFS=: read -r aliasLine ;
        do
            if [ ! -z "$aliasLine" ] ;
            then
                alias $aliasLine
                local aliasName=`echo $aliasLine | awk -F= '{ print $1 }'`
                _local_aliasses+=($aliasName)
            fi
        done

        return
    fi

    _check_directory_for_local_aliases `dirname $searchPath`
}

function _check_current_directory_for_local_aliases() {
    _check_directory_for_local_aliases `pwd`
}

function() {
    add-zsh-hook chpwd _check_current_directory_for_local_aliases
    _check_current_directory_for_local_aliases
}
