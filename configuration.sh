#!/usr/bin/env bash
# Use this file as reference on what you can configure. You can set each of these variables in the environment
# to override the default values.

# Set ${CI} to false on non CI builds, for github actions we need to provide a fallback. Github does not support the CI environment variable.
CI=${CI:-${GITHUB_ACTIONS:-false}}

# Generate more verbose output, defaults to false. Can also be set to true by providing the -v parameter to the invoking command.
DRUPAL_TRAVIS_VERBOSE=${DRUPAL_TRAVIS_VERBOSE:-false}

DRUPAL_TRAVIS_COMPOSER_PROJECT=${DRUPAL_TRAVIS_COMPOSER_PROJECT:-"drupal/recommended-project"}

# The directory, where the project is located. On travis this is set to TRAVIS_BUILD_DIR otherwise defaults to the current directory
DRUPAL_TRAVIS_PROJECT_BASEDIR=${DRUPAL_TRAVIS_PROJECT_BASEDIR:-${TRAVIS_BUILD_DIR:-$(pwd)}}

# The type of the project, could be "drupal-module" "drupal-theme" "drupal-profile" or "project".
DRUPAL_TRAVIS_PROJECT_TYPE=${DRUPAL_TRAVIS_PROJECT_TYPE:-$(jq -er '.type // "project"' ${DRUPAL_TRAVIS_PROJECT_BASEDIR}/composer.json)}

# Setting this to a filename, creates a dump from an installation, that can be used by all tests, instead of reinstalling
# for every test. This is currently supported only by the thunder distribution.
DRUPAL_TRAVIS_TEST_DUMP_FILE=${DRUPAL_TRAVIS_TEST_DUMP_FILE:-""}

# The drupal profile that is used in the tests.
DRUPAL_TRAVIS_TEST_PROFILE=${DRUPAL_TRAVIS_TEST_PROFILE:-minimal}

# If set to true, drush will install from exported config, otherwise the DRUPAL_TRAVIS_TESTING_PROFILE will be used on install.
DRUPAL_TRAVIS_INSTALL_FROM_CONFIG=${DRUPAL_TRAVIS_INSTALL_FROM_CONFIG:-false}

# The composer name of the current project, if not specified, it will be read from the composer.json.
DRUPAL_TRAVIS_COMPOSER_NAME=${DRUPAL_TRAVIS_COMPOSER_NAME:-$(jq -r .name ${DRUPAL_TRAVIS_PROJECT_BASEDIR}/composer.json)}

# The project name, if not provided, the "installer-name" property of the composer extra section is used.
# Fallback value is the second part of the composer name will be use. E.g. If the composer name is
# vendor/myproject the project name will be myproject.
DRUPAL_TRAVIS_PROJECT_NAME=${DRUPAL_TRAVIS_PROJECT_NAME-$(jq -r --arg FALLBACK "$(echo ${DRUPAL_TRAVIS_COMPOSER_NAME} | cut -d '/' -f 2)"  '.extra."installer-name" // $FALLBACK' ${DRUPAL_TRAVIS_PROJECT_BASEDIR}/composer.json)}

# The phpunit test group. To provide multiple groups, concatenate them with comma:
# E.g. DRUPAL_TRAVIS_TEST_GROUP="mygroup1,mygroup2"
DRUPAL_TRAVIS_TEST_GROUP=${DRUPAL_TRAVIS_TEST_GROUP:-""}

# Boolean value if coding styles should be tested with burdamagazinorg/thunder-dev-tools.
# By default coding styles are tested.
DRUPAL_TRAVIS_TEST_CODING_STYLES=${DRUPAL_TRAVIS_TEST_CODING_STYLES:-true}

# The phpunit test filter to restrict the tests.
DRUPAL_TRAVIS_TEST_FILTER=${DRUPAL_TRAVIS_TEST_FILTER:-""}

# Boolean value if javascript coding style should be tested.
# By default javascript coding styles are tested.
DRUPAL_TRAVIS_TEST_JAVASCRIPT=${DRUPAL_TRAVIS_TEST_JAVASCRIPT:-true}

# Boolean value if php coding style should be tested.
# By default php coding styles are tested.
DRUPAL_TRAVIS_TEST_PHP=${DRUPAL_TRAVIS_TEST_PHP:-true}

# Boolean value if deprecation testing should be done.
DRUPAL_TRAVIS_TEST_DEPRECATION=${DRUPAL_TRAVIS_TEST_DEPRECATION:-test -f phpstan.neon}

# The files pattern to ignore when testing php coding styles.
DRUPAL_TRAVIS_PHPCS_IGNORE_PATTERN=${DRUPAL_TRAVIS_PHPCS_IGNORE_PATTERN:-*/vendor/*,*/core/*,*/autoload.php,*.md}

# The drupal version to test against. This can be any valid composer version string, but only drupal versions greater 8.6
# are supported.
DRUPAL_TRAVIS_DRUPAL_VERSION=${DRUPAL_TRAVIS_DRUPAL_VERSION:-""}

# The base directory for all generated files. Into this diretory will be drupal installed and temp files stored.
# This directory gets removed after successful tests.
DRUPAL_TRAVIS_TEST_BASE_DIRECTORY=${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY:-/tmp/test/${DRUPAL_TRAVIS_PROJECT_NAME}}

# The directory, where drupal will be installed, defaults to ${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY}/install
# This directory gets removed after successful tests.
DRUPAL_TRAVIS_DRUPAL_INSTALLATION_DIRECTORY=${DRUPAL_TRAVIS_DRUPAL_INSTALLATION_DIRECTORY:-${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY}/install}

# The directory, where the tests are located relative to the docroot. This will default to the project directory.
DRUPAL_TRAVIS_TEST_LOCATION=${DRUPAL_TRAVIS_TEST_LOCATION:-""}

# The directory, where lock files for finished stages will be saved, defaults to ${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY}/finished-stages.
# This directory gets removed after successful tests.
DRUPAL_TRAVIS_LOCK_FILES_DIRECTORY=${DRUPAL_TRAVIS_LOCK_FILES_DIRECTORY:-${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY}/finished-stages}

# The web server host. Defaults to 127.0.0.1
DRUPAL_TRAVIS_HTTP_HOST=${DRUPAL_TRAVIS_HTTP_HOST:-127.0.0.1}

# The web server port. Defaults to 8888
DRUPAL_TRAVIS_HTTP_PORT=${DRUPAL_TRAVIS_HTTP_PORT:-8888}

# Use selenium to spawn chromedriver. On travis we want to do that, to be able to use the selenium docker.
# On local development calling chromedriver directly is more straight forward.
DRUPAL_TRAVIS_USE_SELENIUM=${DRUPAL_TRAVIS_USE_SELENIUM:-${CI}}

# The selenium chrome docker version to use. defaults to the latest version.
DRUPAL_TRAVIS_SELENIUM_CHROME_VERSION=${DRUPAL_TRAVIS_SELENIUM_CHROME_VERSION:-3.141.59-oxygen}

# The chromedriver version to use. Defaults to the latest version. This is only used, for direct chromedriver calls.
# When selenium is used, specify DRUPAL_TRAVIS_SELENIUM_CHROME_VERSION instead.
DRUPAL_TRAVIS_CHROMEDRIVER_VERSION=${DRUPAL_TRAVIS_CHROMEDRIVER_VERSION:-$(curl --silent https://chromedriver.storage.googleapis.com/LATEST_RELEASE_77)}

# The selenium host. Defaults to the web server host.
DRUPAL_TRAVIS_SELENIUM_HOST=${DRUPAL_TRAVIS_SELENIUM_HOST:-${DRUPAL_TRAVIS_HTTP_HOST}}

# The selenium port. Defaults to 4444.
DRUPAL_TRAVIS_SELENIUM_PORT=${DRUPAL_TRAVIS_SELENIUM_PORT:-4444}

# The name for the selenium docker container. Defaults to selenium-for-drupal-tests
DRUPAL_TRAVIS_SELENIUM_DOCKER_NAME=${DRUPAL_TRAVIS_SELENIUM_DOCKER_NAME:-selenium-for-drupal-tests}

# The database host. Defaults to the web server host.
DRUPAL_TRAVIS_DATABASE_HOST=${DRUPAL_TRAVIS_DATABASE_HOST:-${DRUPAL_TRAVIS_HTTP_HOST}}

# The database port. Defaults to 3306.
DRUPAL_TRAVIS_DATABASE_PORT=${DRUPAL_TRAVIS_DATABASE_PORT:-3306}

# The database user. Defaults to travis, which is the default travis database user.
DRUPAL_TRAVIS_DATABASE_USER=${DRUPAL_TRAVIS_DATABASE_USER:-travis}

# The database name. Defaults to drupaltesting
DRUPAL_TRAVIS_DATABASE_NAME=${DRUPAL_TRAVIS_DATABASE_NAME:-drupaltesting}

# The database password for ${DRUPAL_TRAVIS_DATABASE_USER}, empty by default for travis.
DRUPAL_TRAVIS_DATABASE_PASSWORD=${DRUPAL_TRAVIS_DATABASE_PASSWORD:-""}

# The database engine to use. For CI runs this defaults to mysql, local runs will default to sqlite.
if ${CI}; then
    DRUPAL_TRAVIS_DATABASE_ENGINE=${DRUPAL_TRAVIS_DATABASE_ENGINE:-"mysql"}
else
    DRUPAL_TRAVIS_DATABASE_ENGINE=${DRUPAL_TRAVIS_DATABASE_ENGINE:-"sqlite"}
fi

# By default all created files are deleted after successful test runs, you can disable this behaviour by setting
# this to true.
DRUPAL_TRAVIS_CLEANUP=${DRUPAL_TRAVIS_CLEANUP:-true}

# The directory where the configuration for the installation with existing config is located.
DRUPAL_TRAVIS_CONFIG_SYNC_DIRECTORY=${DRUPAL_TRAVIS_CONFIG_SYNC_DIRECTORY:-"../config/sync"}

# Additional form values for the installation profile. This is uses by drush site-install.
DRUPAL_TRAVIS_INSTALLATION_FORM_VALUES=${DRUPAL_TRAVIS_INSTALLATION_FORM_VALUES:-"install_configure_form.enable_update_status_module=NULL"}

# The symfony environment variable to ignore deprecations, for possible values see symfony documentation.
# The default value is "week" to ignore any deprecation notices.
export SYMFONY_DEPRECATIONS_HELPER=${SYMFONY_DEPRECATIONS_HELPER-weak}

# The url that simpletest will use.
export SIMPLETEST_BASE_URL=${SIMPLETEST_BASE_URL:-http://${DRUPAL_TRAVIS_HTTP_HOST}:${DRUPAL_TRAVIS_HTTP_PORT}}

# The driver args for webdriver.
export MINK_DRIVER_ARGS_WEBDRIVER=${MINK_DRIVER_ARGS_WEBDRIVER-"[\"chrome\", null, \"http://${DRUPAL_TRAVIS_SELENIUM_HOST}:${DRUPAL_TRAVIS_SELENIUM_PORT}/wd/hub\"]"}

# Increase composer memory limit.
export COMPOSER_MEMORY_LIMIT=${COMPOSER_MEMORY_LIMIT:-"-1"}

if [[ ${DRUPAL_TRAVIS_DATABASE_ENGINE} == 'sqlite' ]]; then
    export SIMPLETEST_DB=${SIMPLETEST_DB:-${DRUPAL_TRAVIS_DATABASE_ENGINE}://${DRUPAL_TRAVIS_DATABASE_HOST}/${DRUPAL_TRAVIS_TEST_BASE_DIRECTORY}/${DRUPAL_TRAVIS_DATABASE_NAME}.sqlite}
else
    export SIMPLETEST_DB=${SIMPLETEST_DB:-${DRUPAL_TRAVIS_DATABASE_ENGINE}://${DRUPAL_TRAVIS_DATABASE_USER}:${DRUPAL_TRAVIS_DATABASE_PASSWORD}@${DRUPAL_TRAVIS_DATABASE_HOST}:${DRUPAL_TRAVIS_DATABASE_PORT}/${DRUPAL_TRAVIS_DATABASE_NAME}}
fi
