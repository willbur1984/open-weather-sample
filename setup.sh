#!/bin/sh

function check_binary() {
    local NAME=$1
    local REQUIRED=$2
    local MESSAGE=$3

    if [ -z $REQUIRED ]
    then
        REQUIRED=false
    fi

    if ! [ -x "$(command -v $NAME)" ]
    then
        if $REQUIRED
        then
            echo "Error: $NAME is not installed."
            
            if ! [ -z $MESSAGE ]
            then
                echo $MESSAGE
            fi
            exit 1
        else
            echo "Warning: $NAME is not installed."
            return 1
        fi
    else
        return 0
    fi
}

check_binary gem true "Refer to https://rubygems.org/ for install instructions"
check_binary bundle true "Refer to https://bundler.io/ for install instructions"
check_binary brew true "Refer to https://brew.sh/ for install instructions"

if ! check_binary asdf
then
    brew install asdf
fi

bundle install
bundle exec pod install
open "open-weather.xcworkspace"