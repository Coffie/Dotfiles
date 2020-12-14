#! /usr/bin/env bash
# replace python functions with pyenv init checks
# don't make shell start pyenv unless python is being used'
__pyenv_init() {
    test $__puenv_started = 0 && {
        eval "$(command pyenv init -)"
    __pyenv_started=1
    }
}

pyenv() {
    __pyenv_init
    command pyenv "$@"
}

python() {
    __pyenv_init
    command python "$@"
}

pip() {
    __pyenv_init
    command pip "$@"
}
