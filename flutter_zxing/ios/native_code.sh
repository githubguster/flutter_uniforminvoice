#/bin/bash
IOS_DIR=$(dirname -- "${BASH_SOURCE[0]}")
IOS_NATIVE_CODE_DIR="${IOS_DIR}/native_code"
NATIVE_CODE_DIR="${IOS_DIR}/../native_code"
NATIVE_ZXING_CPP_DIR="$NATIVE_CODE_DIR/zxing-cpp/core/src"

rm -rf $IOS_NATIVE_CODE_DIR

mkdir -p $IOS_NATIVE_CODE_DIR

rsync -av --exclude "*.txt" --exclude "zxing-cpp/" "$NATIVE_CODE_DIR/" "$IOS_NATIVE_CODE_DIR"
rsync -av "$NATIVE_ZXING_CPP_DIR" "${IOS_NATIVE_CODE_DIR}/zxing-cpp"