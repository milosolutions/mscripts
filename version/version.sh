DIR=$(dirname $0)
echo "const char *GIT_COMMIT_ID = \"$(git -C "$DIR" rev-parse @)\";" > "$DIR/version.cpp"