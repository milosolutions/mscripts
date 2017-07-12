DIR=$(dirname $0)
SHA=$(git -C "$DIR" rev-parse @)
sed -i "s/GIT_COMMIT_ID =.*/GIT_COMMIT_ID = QStringLiteral(\"$SHA\");/" "$DIR/version.cpp"