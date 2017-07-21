DIR=$(dirname $0)
SHA=$(git -C "$DIR" rev-parse @)
echo "Dir is: $DIR"
echo "SHA is: $SHA"

if [ ! -f "$DIR/versiongit.cpp" ]; then
  cp "$DIR/versiongit.cpp.sample" "$DIR/versiongit.cpp"
fi

sed -i "s/GIT_COMMIT_ID =.*/GIT_COMMIT_ID = QByteArray(\"$SHA\");/" "$DIR/versiongit.cpp"
