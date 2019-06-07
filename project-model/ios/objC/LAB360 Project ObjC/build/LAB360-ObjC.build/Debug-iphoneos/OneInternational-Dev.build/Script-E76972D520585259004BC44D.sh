#!/bin/sh
echo "Running Crashlytics (${CONFIGURATION})"
"${PODS_ROOT}/Fabric/run" ${CRASHLYTICS_API_KEY} ${CRASHLYTICS_BUILD_SECRET}

