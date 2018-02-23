#!/bin/sh

### Kiss-GUI build script by Alex Fedorov AKA FedorComander

NWJS_VERSION="0.17.0"
GUI_LOCATION="../kissfc-chrome-gui/"
NWJS_OSX_URL="https://dl.nwjs.io/v${NWJS_VERSION}/nwjs-v${NWJS_VERSION}-osx-x64.zip"
NWJS_OSX_FILE="nwjs-v${NWJS_VERSION}-osx-x64"
NWJS_WIN64_URL="https://dl.nwjs.io/v${NWJS_VERSION}/nwjs-v${NWJS_VERSION}-win-x64.zip"
NWJS_WIN64_FILE="nwjs-v${NWJS_VERSION}-win-x64"
NWJS_WIN32_URL="https://dl.nwjs.io/v${NWJS_VERSION}/nwjs-v${NWJS_VERSION}-win-ia32.zip"
NWJS_WIN32_FILE="nwjs-v${NWJS_VERSION}-win-ia32"
NWJS_LINUX32_URL="https://dl.nwjs.io/v${NWJS_VERSION}/nwjs-v${NWJS_VERSION}-linux-ia32.tar.gz"
NWJS_LINUX32_FILE="nwjs-v${NWJS_VERSION}-linux-ia32"
NWJS_LINUX64_URL="https://dl.nwjs.io/v${NWJS_VERSION}/nwjs-v${NWJS_VERSION}-linux-x64.tar.gz"
NWJS_LINUX64_FILE="nwjs-v${NWJS_VERSION}-linux-x64"

EXECUTABLE_NAME="Kiss-GUI"
GUI_VERSION="2.0.2"

echo "Prepare sources"
if [ ! -d tmp ] ; then
    mkdir tmp
fi
if [ ! -d build ] ; then
    mkdir build
fi

OSX="true"
WIN32="true"
WIN64="true"
LINUX32="true"
LINUX64="true"

if [ "${OSX}" == "true" ] ; then
git clone https://github.com/andreyvit/yoursway-create-dmg.git ./tmp/dmg-tools

echo "Starting to build OSX binary"
if [ ! -f tmp/${NWJS_OSX_FILE}.zip ] ; then
    echo "Downloading OSX version ${NWJS_VERSION} of NWJS"
    curl ${NWJS_OSX_URL} -o tmp/${NWJS_OSX_FILE}.zip
fi
unzip ./tmp/${NWJS_OSX_FILE} -d tmp/
mv ./tmp/${NWJS_OSX_FILE}/nwjs.app tmp/${NWJS_OSX_FILE}/${EXECUTABLE_NAME}.app
mkdir ./tmp/${NWJS_OSX_FILE}/${EXECUTABLE_NAME}.app/Contents/Resources/app.nw
rsync -av --progress ${GUI_LOCATION}/ ./tmp/${NWJS_OSX_FILE}/${EXECUTABLE_NAME}.app/Contents/Resources/app.nw/ --exclude '.*'
cp ./res/osx/app.icns ./tmp/${NWJS_OSX_FILE}/${EXECUTABLE_NAME}.app/Contents/Resources/
cp ./res/osx/document.icns ./tmp/${NWJS_OSX_FILE}/${EXECUTABLE_NAME}.app/Contents/Resources/
#cd ./tmp/${NWJS_OSX_FILE}/

rm -f ./tmp/${NWJS_OSX_FILE}/credits.html
./tmp/dmg-tools/create-dmg --volname "KISS GUI" --volicon ./res/osx/app.icns \
    ./tmp/${EXECUTABLE_NAME}-${GUI_VERSION}.dmg ./tmp/${NWJS_OSX_FILE}/
 
#zip -r ../../build/${EXECUTABLE_NAME}-${GUI_VERSION}-osx-x64.zip ${EXECUTABLE_NAME}.app 
mv ./tmp/${EXECUTABLE_NAME}-${GUI_VERSION}.dmg ./build/
rm -rf ./tmp/${NWJS_OSX_FILE}

echo "Done building OSX binary"
fi

if [ "${WIN64}" == "true" ] ; then
echo "Starting to build WIN64 binary"
if [ ! -f tmp/${NWJS_WIN64_FILE}.zip ] ; then
    echo "Downloading WIN64 version ${NWJS_VERSION} of NWJS"
    curl ${NWJS_WIN64_URL} -o tmp/${NWJS_WIN64_FILE}.zip
fi
unzip tmp/${NWJS_WIN64_FILE} -d tmp/
mkdir tmp/${NWJS_WIN64_FILE}/package.nw
rsync -av --progress ${GUI_LOCATION}/ tmp/${NWJS_WIN64_FILE}/package.nw/ --exclude '.*'
cp res/win/x64/nw.exe tmp/${NWJS_WIN64_FILE}/
cd tmp/${NWJS_WIN64_FILE}/
mv nw.exe ${EXECUTABLE_NAME}.exe
zip -r ../../build/${EXECUTABLE_NAME}-${GUI_VERSION}-win-x64.zip *
cd ../..
rm -rf tmp/${NWJS_WIN64_FILE}
echo "Done building WIN64 binary"

fi

if [ "${WIN32}" == "true" ] ; then

echo "Starting to build WIN32 binary"
if [ ! -f tmp/${NWJS_WIN32_FILE}.zip ] ; then
    echo "Downloading WIN32 version ${NWJS_VERSION} of NWJS"
    curl ${NWJS_WIN32_URL} -o tmp/${NWJS_WIN32_FILE}.zip
fi
unzip tmp/${NWJS_WIN32_FILE} -d tmp/
mkdir tmp/${NWJS_WIN32_FILE}/package.nw
rsync -av --progress ${GUI_LOCATION}/ tmp/${NWJS_WIN32_FILE}/package.nw/ --exclude '.*'
cp res/win/ia32/nw.exe tmp/${NWJS_WIN32_FILE}/
cd tmp/${NWJS_WIN32_FILE}/
mv nw.exe ${EXECUTABLE_NAME}.exe
zip -r ../../build/${EXECUTABLE_NAME}-${GUI_VERSION}-win-ia32.zip *
cd ../..
rm -rf tmp/${NWJS_WIN32_FILE}
echo "Done building WIN32 binary"
fi

if [ "${LINUX32}" == "true" ] ; then
echo "Starting to build LINUX32 binary"
if [ ! -f tmp/${NWJS_LINUX32_FILE}.tar.gz ] ; then
    echo "Downloading LINUX32 version ${NWJS_VERSION} of NWJS"
    curl ${NWJS_LINUX32_URL} -o tmp/${NWJS_LINUX32_FILE}.tar.gz
fi
cd tmp
tar xvzf ./${NWJS_LINUX32_FILE}.tar.gz
cd ..
mkdir tmp/${NWJS_LINUX32_FILE}/package.nw
rsync -av --progress ${GUI_LOCATION}/ tmp/${NWJS_LINUX32_FILE}/package.nw/ --exclude '.*'
#cp res/linux/ia32/nw.exe tmp/${NWJS_LINUX32_FILE}/
cd tmp/${NWJS_LINUX32_FILE}/
mv nw ${EXECUTABLE_NAME}
tar cvzf ../../build/${EXECUTABLE_NAME}-${GUI_VERSION}-linux-ia32.tgz *
cd ../..
rm -rf tmp/${NWJS_LINUX32_FILE}
echo "Done building LINUX32 binary"
fi

if [ "${LINUX64}" == "true" ] ; then
echo "Starting to build LINUX64 binary"
if [ ! -f tmp/${NWJS_LINUX64_FILE}.tar.gz ] ; then
    echo "Downloading LINUX64 version ${NWJS_VERSION} of NWJS"
    curl ${NWJS_LINUX64_URL} -o tmp/${NWJS_LINUX64_FILE}.tar.gz
fi
cd tmp
tar xvzf ./${NWJS_LINUX64_FILE}.tar.gz
cd ..
mkdir tmp/${NWJS_LINUX64_FILE}/package.nw
rsync -av --progress ${GUI_LOCATION}/ tmp/${NWJS_LINUX64_FILE}/package.nw/ --exclude '.*'
#cp res/linux/ia64/nw.exe tmp/${NWJS_LINUX64_FILE}/
cd tmp/${NWJS_LINUX64_FILE}/
mv nw ${EXECUTABLE_NAME}
tar cvzf ../../build/${EXECUTABLE_NAME}-${GUI_VERSION}-linux-x64.tgz *
cd ../..
rm -rf tmp/${NWJS_LINUX64_FILE}
echo "Done building LINUX64 binary"
fi
