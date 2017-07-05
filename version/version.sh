DIR=$(dirname $0)
echo "const char *GIT_COMMIT_ID = \"$(git -C "$DIR" rev-parse @)\";" > "$1"
echo "const char *GIT_APP_VERSION = \"$(git -C "$DIR" describe --long)\";" >> "$1"
echo "const char *GIT_APP_VERSION_SHORT = \"$(git -C "$DIR" describe --abbrev=0)\";" >> "$1"
