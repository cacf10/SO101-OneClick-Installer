#!/usr/bin/env bash

MINIFORGE_DIR="$HOME/miniforge3"


load_conda(){

    if [ -f "$MINIFORGE_DIR/etc/profile.d/conda.sh" ]; then
        source "$MINIFORGE_DIR/etc/profile.d/conda.sh"
    else
        echo "Conda not found"
        exit 1
    fi

}
