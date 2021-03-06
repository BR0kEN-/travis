#!/usr/bin/env bash

run_stage() {
    local stage="${1}"

    if stage_is_finished ${stage}; then
        return
    fi

    local dependency=$(stage_dependency ${stage})

    if [[ ! -z ${dependency} ]]; then
        run_stage ${dependency}
    fi

    # source the stage
    source ${SCRIPT_DIR}/../lib/stages/${stage}.sh
    _stage_${stage}

    finish_stage ${stage}
}

stage_exists() {
    local stage="${1}"

    source ${SCRIPT_DIR}/../lib/stages/${stage}.sh
    declare -f -F _stage_${stage} > /dev/null

    return ${?}
}

stage_dependency() {
    local dep=""

    case ${1} in
        run_tests)
            dep="start_web_server"
            ;;
        start_web_server)
            dep="install"
            ;;
        install)
            dep="deprecation"
            ;;
        deprecation)
            dep="build"
            ;;
        build)
            dep="prepare_build"
            ;;
        prepare_build)
            dep="setup"
            ;;
        setup)
            dep="coding_style"
            ;;
    esac

    echo "${dep}"
}

stage_is_finished() {
    [[ -f "${DRUPAL_TRAVIS_LOCK_FILES_DIRECTORY}/${1}" ]]
}

finish_stage() {
    local stage="${1}"

    if [[ ! -d ${DRUPAL_TRAVIS_LOCK_FILES_DIRECTORY} ]]; then
        mkdir -p ${DRUPAL_TRAVIS_LOCK_FILES_DIRECTORY}
    fi

    touch ${DRUPAL_TRAVIS_LOCK_FILES_DIRECTORY}/${stage}
}

reset_stage() {
    local stage="${1}"
    local stage_locl_file="${DRUPAL_TRAVIS_LOCK_FILES_DIRECTORY}/${stage}"

    if [[ -f "${stage_locl_file}" ]]; then
        rm "${stage_locl_file}"
    fi
}
