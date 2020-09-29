#!/bin/zsh


function _vagrantRunning() (
    function _virtualboxRunning() {
        VBoxManage list runningvms \
            | awk -F\" {' print $2 '} \
            | sed -E -e 's/^(web|db|solr|proxy)-//g' \
            | sort \
            | uniq
    }

    PROJECTS=`ls -d /Volumes/Development/Netlogix/Projekte/*`
    VMS=`_virtualboxRunning`

    setopt shwordsplit
    for VM in $VMS
    do
        PROJECT_PATHS=()
        setopt shwordsplit
        for PROJECT in $PROJECTS
        do
            PROJECT_PATH=`grep $VM --color=never <<< $PROJECT`
            if [ "$PROJECT_PATH" != "" ];
            then
                PROJECT_PATHS+=($PROJECT_PATH)
            fi
        done

        unsetopt shwordsplit
        if [ "${#PROJECT_PATHS[@]}" = "0" ];
        then
            PROJECT_PATHS=("VIRTUAL MACHINE WITHOUT PROJECT CONNECTION")
        fi

        printf '%-20s %s\n' $VM $PROJECT_PATHS
    done
)
alias vagrant-running=_vagrantRunning

alias wwwdata="vagrant ssh -c wwwdata"
alias sudo-web="vagrant ssh web -c 'sudo su -'"
alias sudo-proxy="vagrant ssh proxy -c 'sudo su -'"
alias sudo-solr="vagrant ssh solr -c 'sudo su -'"
alias sudo-db="vagrant ssh db -c 'sudo su -'"
alias syslog-web="vagrant ssh web -c 'tail -f /var/log/syslog'"

function _vagrantFlow() {
    vagrant ssh web -c "cd /var/www/\$(hostname | tail -c +5)/releases/current ; sudo -u www-data -H ./flow $*" -- -q
}
alias flow="_vagrantFlow"
