#!/bin/sh
# Name of the resource we're selectively copying
ENTERPRISEGOOGLESERVICE_INFO_PLIST=EnterpriseGoogleService-Info.plist
APPSTOREGOOGLESERVICE_INFO_PLIST=AppStoreGoogleService-Info.plist

# Get references to dev and prod versions of the GoogleService-Info.plist
# NOTE: These should only live on the file system and should NOT be part of the target (since we'll be adding them to the target manually)
GOOGLESERVICE_INFO_DEV=${PROJECT_DIR}/${ENTERPRISEGOOGLESERVICE_INFO_PLIST}
GOOGLESERVICE_INFO_PROD=${PROJECT_DIR}/${APPSTOREGOOGLESERVICE_INFO_PLIST}

# Make sure the dev version of GoogleService-Info.plist exists
echo "Looking for ${ENTERPRISEGOOGLESERVICE_INFO_PLIST} in ${GOOGLESERVICE_INFO_DEV}"
if [ ! -f $GOOGLESERVICE_INFO_DEV ]
then
echo "No Development GoogleService-Info.plist found. Please ensure it's in the proper directory."
exit 1
fi

# Make sure the prod version of GoogleService-Info.plist exists
echo "Looking for ${APPSTOREGOOGLESERVICE_INFO_PLIST} in ${GOOGLESERVICE_INFO_PROD}"
if [ ! -f $GOOGLESERVICE_INFO_PROD ]
then
echo "No Production GoogleService-Info.plist found. Please ensure it's in the proper directory."
exit 1
fi

# Get a reference to the destination location for the GoogleService-Info.plist
PLIST_DESTINATION=${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app
echo "Will copy ${GOOGLESERVICE_INFO_PLIST} to final destination: ${PLIST_DESTINATION}"

# Copy over the prod GoogleService-Info.plist for Release builds
if [ "${CONFIGURATION}" == "Release" ]
then
echo "Using ${GOOGLESERVICE_INFO_PROD}"
#cp "${GOOGLESERVICE_INFO_PROD}" "${PLIST_DESTINATION}"
cp "${GOOGLESERVICE_INFO_PROD}" "${CONFIGURATION_BUILD_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
else
echo "Using ${GOOGLESERVICE_INFO_DEV}"
#cp "${GOOGLESERVICE_INFO_DEV}" "${PLIST_DESTINATION}"
cp "${GOOGLESERVICE_INFO_DEV}" "${CONFIGURATION_BUILD_DIR}/${PRODUCT_NAME}.app/GoogleService-Info.plist"
fi


