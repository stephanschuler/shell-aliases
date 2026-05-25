#!/bin/zsh

# $0: Path to file
# $1: Path to shell aliases directory

autoload throw catch


function _switch_best_matching_php_version() {
    local versionNumber="$1"
    local filename="$2"
    local aliasname

    if [ "$versionNumber" = "" ] ;
    then
        return 1
    fi

    aliasname=`echo php$versionNumber | awk -F. '{ print $1$2}'`

    checkIfAliasExists=`which $aliasname`
    local errorcode=$?
    unset checkIfAliasExists
    if (( $errorcode )) ;
    then
        >&2 echo -en "\033[31m"
        >&2 echo "Requested PHP version $versionNumber in \"$filename\" is not installed."
        >&2 echo -en "\033[0m"
        if [ -z "$INTELLIJ_ENVIRONMENT_READER" ];
        then
            return 1
        else
            return 0
        fi
    fi

    local realAliasPath=`type -f $aliasname | awk '{ print $6 }'`
    if [ "$realAliasPath" = "" ];
    then
        >&2 echo -en "\033[31m"
        >&2 echo "Requested PHP version $versionNumber in \"$filename\" is not available as an alias."
        >&2 echo -en "\033[0m"
        if [ -z "$INTELLIJ_ENVIRONMENT_READER" ];
        then
            return 1
        else
            return 0
        fi
    fi

    local newPath
    echo $PATH | tr ':' "\n" | while IFS=: read -r pathOption ;
    do
        if [ ! `echo $pathOption | grep 'Cellar/php'` ];
        then
            newPath="$newPath:$pathOption"
        fi
    done

    PATH=`dirname $realAliasPath`$newPath

    return 0
}


function _check_directory_for_php_version() {
    local searchPath="$1"

    if [ "$searchPath" = "/" ] || [ "$searchPath" = "" ];
    then
        return
    fi

    local versionFile=".phprc"
    local vagrantFile="Vagrantfile"
    local composerFile="composer.json"

    if [[ -f "$searchPath/$versionFile" ]];
    then
        local phpVersion=`cat "$searchPath/$versionFile"`
        _switch_best_matching_php_version "$phpVersion" "$searchPath/$versionFile" && return

        local phpVersion=`jshon -Q -e config -e platform -e php -u < $searchPath/$comnposerFile | sed -E "s/^[~>^]?([0-9])\.([0-9]+)$/\\1.\\2/g"`
        _switch_best_matching_php_version "$phpVersion" "$searchPath/$comnposerFile" && return
    fi

    if [[ -f "$searchPath/$vagrantFile" ]];
    then
        local phpVersion=`grep -m 1 php $searchPath/$vagrantFile | sed -E "s/.*[\'\"](.*)[\'\"].*/\\1/g"`
        _switch_best_matching_php_version "$phpVersion" "$searchPath/$vagrantFile" && return
    fi

    if [[ -f "$searchPath/$composerFile" ]];
    then
        local phpVersion=`jshon -Q -e require -e php -u < $searchPath/$composerFile | sed -E "s/^[~>^]?([0-9])\.([0-9]+)$/\\1.\\2/g"`
        _switch_best_matching_php_version "$phpVersion" "$searchPath/$composerFile" && return
    fi

    _check_directory_for_php_version `dirname $searchPath`
}


function _check_current_directory_for_php_version() {
    _check_directory_for_php_version `pwd`
}

function() {
    local brewPrefix=`eval-cached "brew --prefix"`
    local versionNumbers=`eval-cached "brew list --version | grep -E ^php | awk '{ print \\$2 }' | awk -F. '{ print \\$1\".\"\\$2}' | sort"`
    local versionNumber

    echo $versionNumbers | while IFS= read -r versionNumber ;
    do
        function() {
            local executable=`eval-cached "brew info php@$versionNumber | grep -E -o '$brewPrefix/Cellar/[^[:space:]]+' | awk '{ print \\$0 \"/bin/php\" }'"`
            local aliasname=`echo php$versionNumber | awk -F. '{ print $1$2}'`
            if [[ -x "$executable" ]]
            then
                alias $aliasname=$executable
            fi
        }
    done

    add-zsh-hook chpwd _check_current_directory_for_php_version
    _check_current_directory_for_php_version
}
