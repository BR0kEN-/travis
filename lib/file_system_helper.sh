#!/usr/bin/env bash

# This has currently no real meaning, but will be necessary, once we test with thunder_project.
# thunder_project builds into docroot instead of web.
get_distribution_docroot() {
    local docroot="web"

    if [[ ${DRUPAL_TRAVIS_DISTRIBUTION} = "thunder" ]]; then
        docroot="docroot"
    fi

    echo "${DRUPAL_TRAVIS_DRUPAL_INSTALLATION_DIRECTORY}/${docroot}"
}

get_composer_bin_directory() {
    if [[ ! -f ${DRUPAL_TRAVIS_DRUPAL_INSTALLATION_DIRECTORY}/composer.json ]]; then
        exit 1
    fi

    local composer_bin_dir=${DRUPAL_TRAVIS_COMPOSER_BIN_DIR:-$(jq -er '.config."bin-dir" // "vendor/bin"' ${DRUPAL_TRAVIS_DRUPAL_INSTALLATION_DIRECTORY}/composer.json)}

    echo "${composer_bin_dir}"
}

get_project_test_location() {
    local docroot=$(get_distribution_docroot)

    if [[ ${DRUPAL_TRAVIS_TEST_LOCATION} -ne "" ]]; then
        echo "${docroot}/${DRUPAL_TRAVIS_TEST_LOCATION}"
    else
        # Full projects will be tested in the docroot. Modules, themes and profiles in their sub folders.
        case ${DRUPAL_TRAVIS_PROJECT_TYPE} in
            drupal-module)
                project_type_test_location="${docroot}/modules/contrib/${DRUPAL_TRAVIS_PROJECT_NAME}"
                ;;
            drupal-profile)
                project_type_test_location="${docroot}/profiles/contrib/${DRUPAL_TRAVIS_PROJECT_NAME}"
                ;;
            drupal-theme)
                project_type_test_location="${docroot}/themes/contrib/${DRUPAL_TRAVIS_PROJECT_NAME}"
                ;;
             *)
                project_type_test_location="${docroot}"
        esac
        echo "${project_type_test_location}"
    fi
}