#!/bin/bash +x

XDEBUG_SAMPLE_FILE="$PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample"
IONCUBE_SAMPLE_FILE="$PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample"

echo "" >> ${XDEBUG_SAMPLE_FILE}
echo "" >> ${XDEBUG_SAMPLE_FILE}
echo "" >> ${IONCUBE_SAMPLE_FILE}
echo "" >> ${IONCUBE_SAMPLE_FILE}

PHP_XDEBUG_LINE=$(awk -v phpvar="${php_version}" '$0 ~ phpvar {getline; print substr($0, 2)}' ${XDEBUG_SAMPLE_FILE})
PHP_IONCUBE_LINE=$(awk -v phpvar="${php_version}" '$0 ~ phpvar {getline; print}' ${IONCUBE_SAMPLE_FILE})

echo "## CONFIG XDEBUG FOR $php_version ##" >> ${XDEBUG_SAMPLE_FILE}
echo "## CONFIG IONCUBE FOR $php_version ##" >> ${IONCUBE_SAMPLE_FILE}

echo "${PHP_XDEBUG_LINE}" >> ${XDEBUG_SAMPLE_FILE}
echo "${PHP_IONCUBE_LINE}" >> ${IONCUBE_SAMPLE_FILE}

echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php/ext-xdebug.ini.sample
echo "## PHP ###" >> $PROJECTPATH/.warp/docker/config/php/ext-ioncube.ini.sample
