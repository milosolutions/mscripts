DIR=$(dirname $0)
SHA=$(git -C "$DIR" rev-parse @)
echo "Dir is: $DIR"
echo "SHA is: $SHA"
sed -i "s/GIT_COMMIT_ID =.*/GIT_COMMIT_ID = QByteArray(\"$SHA\");/" "$DIR/version.cpp"
