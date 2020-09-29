#!/bin/zsh


function _ncroutes() {
    local DEFAULT_GATEWAY=`route -n get default | grep gateway | awk '{ print $2 }'`
    local EDGE_IP
    foreach EDGE_IP in `cat /opt/sslvpn-plus/naclient/naclient.conf | awk '{ print $2 }' | awk -F: '{ print $1 }'`
        sudo route delete $EDGE_IP 2>/dev/null
        sudo route add $EDGE_IP $DEFAULT_GATEWAY
    end
}
alias ncroutes=_ncroutes
alias naroutes=_ncroutes
