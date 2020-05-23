#!/bin/bash
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


CONTAINER_NAME="pbuilder-container"

CONTAINER_RUN_OPTIONS=" \
    --rm \
    --privileged \
    -v /proc:/proc \
    --mount type=bind,source="$(realpath .)",target=/home/root/host-pwd \
    $CONTAINER_NAME \
"

####################################################
# Supported Commands
typeset -A commandsMap # init array

commands=("build cmd shell")

commandsMap=(
    [build]="build_container"
    [cmd]="run_command"
    [shell]="run_interactive"

)

####################################################
# main helper
function print_help
{
    echo "Usage:"
    for i in ${commands[@]}
    do
        echo "$i : ${commandsMap["$i"]}"
    done
    echo "Options:"
    echo "-h --help     Show this screen"

}

function exec_cmd
{
    ARG=${*:1}
    CMD=$1
    CMD_JOB=${commandsMap["$CMD"]}
    if [ -z "$CMD_JOB" ]; then
        echo "Command not existent"
        print_help
        exit -1
    fi

    #Strip Command from argument
    ARG=${ARG#"$CMD"}

    ($CMD_JOB ${ARG#*' '})
    ret=$?
    if [ $ret -ne 0 ]; then
        echo "ERROR: failed to exec $CMD_JOB"
        exit $ret
    fi
}

####################################################
# main helper
function build_container
{
    docker build -t $CONTAINER_NAME \
                 $THIS_DIR
    ret=$?
}

function run_interactive
{
    docker run --tty \
               --interactive \
               $CONTAINER_RUN_OPTIONS
}

function run_command
{
    ARG=${*:1}
    echo $ARG
    if [ -z "$ARG" ]; then
        echo "No Command passed"
        exit -1
    fi

    docker run --workdir=/home/root/host-pwd \
               $CONTAINER_RUN_OPTIONS \
               /bin/bash -c "$ARG"
}

####################################################
# main
# parsing parameters

case "$@" in
    -h|--help)
        print_help
        ;;
    *)
        exec_cmd ${*:1}
        ;;
esac

