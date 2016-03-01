#! /bin/sh

# define target
TARGET_NAME="FindDoctor"

# define directory
ROOT_BUILD_DIR="${SRCROOT}/build"
OTA_DIR="/Users/$(whoami)/Desktop/OTA"

# define distribution configuration name
DISTRIBUTION_CONF="Release"
# define debug configuration name
DEBUG_CONF="Debug"

# define build action(ipa, dsym.zip)
xcode_ota_build()
{
    BUILD_CONFIGURATION=$1

    BUILD_DIR="${ROOT_BUILD_DIR}/${BUILD_CONFIGURATION}-iphoneos"
    OTA_BUILD_DIR="${OTA_DIR}/${BUILD_CONFIGURATION}"

    IPA_NAME="${TARGET_NAME}.ipa"
    IPA_PATH="${OTA_BUILD_DIR}/${IPA_NAME}"

    APP_NAME="${TARGET_NAME}.app"
    APP_ZIP_NAME="${APP_NAME}.zip"

    DSYM_NAME="${TARGET_NAME}.app.dSYM"
    DSYM_ZIP_NAME="${DSYM_NAME}.zip"

    # xcodebuild must run on dir $SRCROOT
    cd ${SRCROOT}
    xcodebuild -target ${TARGET_NAME} -configuration ${BUILD_CONFIGURATION} -sdk iphoneos clean
    xcodebuild -target ${TARGET_NAME} -configuration ${BUILD_CONFIGURATION} -sdk iphoneos build

    # mkdir
    rm -rf ${OTA_BUILD_DIR}
    mkdir ${OTA_BUILD_DIR}

    cd ${BUILD_DIR}
    # zip dSYM
    zip -qr ${DSYM_ZIP_NAME} ${DSYM_NAME}
    # move dSYM
    mv ${DSYM_ZIP_NAME} ${OTA_BUILD_DIR}

    # zip app
    zip -qr ${APP_ZIP_NAME} ${APP_NAME}
    # copy app
    cp ${APP_ZIP_NAME} ${OTA_BUILD_DIR}

    # ipa (code sign? provision embed?)
    /usr/bin/xcrun -sdk iphoneos PackageApplication -v ${APP_NAME} -o ${IPA_PATH}
}

# make ota dir on desktop
rm -rf ${OTA_DIR}
mkdir ${OTA_DIR}

# remove build dir in project
rm -rf ${ROOT_BUILD_DIR}

xcode_ota_build ${DISTRIBUTION_CONF}

# 自动化测试需要
#xcode_ota_build ${DEBUG_CONF}

# remove build dir in project
rm -rf ${ROOT_BUILD_DIR}

