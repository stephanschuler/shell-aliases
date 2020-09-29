#!/bin/zsh


function _dockerAttach() {
    # Starts a new bash process within an existing container
	docker-compose exec -u $(id -u):$(id -g) $1 bash
}
alias docker-attach=_dockerAttach


function _containerBash() {
    # Starts a new container and calls "bash" within
    docker exec -it $1 bash
}
alias container-bash=_containerBash


function _dockerHost() {
    # https://gist.github.com/BretFisher/5e1a0c7bcca4c735e716abf62afad389
    # docker run -it --rm --privileged --pid=host justincormack/nsenter1
    docker run -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i bash
}
alias docker-host=_dockerHost
