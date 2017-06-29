 #!/bin/bash

COMMIT_INFO=`git log -1 --pretty=oneline`
FAILURE_MESSAGE="Build failed: $COMMIT_INFO"
SUCCESS_MESSAGE="Build finished: $COMMIT_INFO"

#run package builder
$PROJPATH/scripts/build_android_package.sh -p $PROJPATH -n $NAME -b $BUILD -t $TARGET
#TODO: add support for iOS

if [ $? -eq 0 ]; then
    curl -H "Content-Type: application/json" -X POST -d "{\"color\": \"green\", \"message_format\": \"text\", \"message\": \"$SUCCESS_MESSAGE\" }" https://api.hipchat.com/v2/room/$ROOM_ID/notification?auth_token=$AUTH_TOKEN
else
    curl -H "Content-Type: application/json" -X POST -d "{\"color\": \"red\", \"message_format\": \"text\", \"message\": \"$FAILURE_MESSAGE\" }" https://api.hipchat.com/v2/room/$ROOM_ID/notification?auth_token=$AUTH_TOKEN
    exit 1
fi
