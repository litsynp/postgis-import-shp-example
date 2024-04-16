#!/bin/bash
TARGET_DIR="shapefiles"

# Setup
rm -rf "${TARGET_DIR}/codes"
mkdir -p "${TARGET_DIR}/codes"
mkdir "${TARGET_DIR}/codes/tmp"

# "${TARGET_DIR}/구역의 도형 [0-9]+월 전체.zip"을 압축해제.
unzip -o "${TARGET_DIR}/구역의 도형 [0-9]*월 전체.zip" -d "${TARGET_DIR}/codes/tmp"
rm -rf "${TARGET_DIR}/codes/tmp/__MACOSX"

# codes/구역의 도형 [0-9]+월 전체 폴더를 codes 폴더로 한 단계 올림
find "${TARGET_DIR}/codes/tmp" -mindepth 2 -type f -exec mv -i '{}' "${TARGET_DIR}/codes" \;
rm -rf "${TARGET_DIR}/codes/tmp"

# codes 폴더에 있는 모든 .zip 파일을 압축해제
unzip -o "${TARGET_DIR}/codes/*.zip" -d "${TARGET_DIR}/codes"

# .zip 파일 삭제
find "${TARGET_DIR}/codes" -name "*.zip" -exec rm -f {} \;
