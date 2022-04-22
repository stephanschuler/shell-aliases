#!/bin/zsh

_SHELL_ALIAS_CACHE_DIRECTORY="$1/.caches"
autoload throw catch


function _evalCached() {

    local command="$@"
    local cacheDir="$_SHELL_ALIAS_CACHE_DIRECTORY"

    if [ ! -d "$cacheDir" ] || [ "$cacheDir" = "" ] ;
    then
        mkdir -p $cacheDir
    fi

    local cacheIdentifier=`echo $command | md5`
    local cacheFile="$cacheDir/$cacheIdentifier"

    find "$cacheDir" -maxdepth 1 -mtime +1 -delete

    local result
    if [ ! -f "$cacheFile" ] ;
    then
        result=`eval "$command"`
        [ "$cacheDir" != "" ] && echo -n $result > $cacheFile
    else
        result=`cat $cacheFile`
    fi

    echo $result
}
alias eval-cached=_evalCached