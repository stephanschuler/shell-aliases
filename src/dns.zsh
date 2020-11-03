#!/bin/zsh


alias dns-remove-servers="networksetup -setdnsservers Wi-Fi empty"
alias dns-kill-dns="sudo killall -HUP mDNSResponder"
alias dns-flush="dns-remove-servers && dns-kill-dns"
