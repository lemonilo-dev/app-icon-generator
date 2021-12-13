COMMAND=convert
FILE=icon.png

if test -f "${FILE}"; then
  DIMENSIONS=$(identify -format '%wx%h' ${FILE})

  if [ ${DIMENSIONS} != "1024x1024" ]; then
    echo "${FILE} dimensions must 1024x1024 " 1>&2 && exit 1
  fi

  if ! command -v ${COMMAND} &> /dev/null
  then
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      brew install imagemagick
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      apt-get install imagemagick
    fi
  fi

  node android-icon-generator.js

  STATUS_CODE=$?

  if [ ${STATUS_CODE} != 0 ]; then                   
    echo "Exited with code ${STATUS_CODE}" 1>&2 && exit 1
  else
    # Android
    yarn extract-zip download/ic_launcher.zip $(pwd)/icons/android/ic_launcher
    yarn extract-zip download/ic_launcher_circle.zip $(pwd)/icons/android/ic_launcher_circle

    # iOS
    convert icon.png -resize 40x icons/ios/Icon-40.png
    convert icon.png -resize 58x icons/ios/Icon-58.png
    convert icon.png -resize 60x icons/ios/Icon-60.png
    convert icon.png -resize 76x icons/ios/Icon-76.png
    convert icon.png -resize 80x icons/ios/Icon-80.png
    convert icon.png -resize 87x icons/ios/Icon-87.png
    convert icon.png -resize 120x icons/ios/Icon-120.png
    convert icon.png -resize 152x icons/ios/Icon-152.png
    convert icon.png -resize 167x icons/ios/Icon-167.png
    convert icon.png -resize 180x icons/ios/Icon-180.png
    convert icon.png -resize 512x icons/ios/Icon-512.png
    convert icon.png -resize 1024x icons/ios/Icon-1024.png

    echo "App Icons successfully generated"
  fi
else
  echo "${FILE} doesn't exist" 1>&2 && exit 1
fi
