#! /bin/bash

set -e

source .github/workflows/common.sh

##########################################################################

# Output status information.
start_section Status
(
    set +e
    set -x
    git status
    git branch -v
    git log -n 5 --graph
    git log --format=oneline -n 20 --graph
)
end_section

##########################################################################

# Fixup environment
start_section Environment
(
    echo '=========================='
    echo 'Fixing environment'
    echo '=========================='
    sudo apt remove --purge gcc-11 libgcc-11*
)
end_section

##########################################################################

# Update submodules
start_section Submodules
(
    git submodule update --init --recursive
)
end_section

##########################################################################

#Install yosys
start_section Install-Yosys
(
    if [ ! -e ~/.local-bin/bin/yosys ]; then
        echo '=========================='
        echo 'Building yosys'
        echo '=========================='
        mkdir -p ~/.local-src
        mkdir -p ~/.local-bin
        cd ~/.local-src
        git clone https://github.com/SymbiFlow/yosys.git -b master+wip
        cd yosys
        gcc -v
        clang -v
        make config-clang
        PREFIX=$HOME/.local-bin make -j$(nproc)
        PREFIX=$HOME/.local-bin make install
        echo $(which yosys)
        echo $(which yosys-config)
        echo $(yosys-config --datdir)
    fi
)
end_section

##########################################################################

