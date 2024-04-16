#!/bin/bash
SOURCE_DIR="shapefiles/codes"
TARGET_DIR="migrations"

# Extract renewed SQL files from shapefiles
today_datetime_str=$(date +"%Y%m%d%H%M%S")

# SRID
INPUT_SRID=5179
OUTPUT_SRID=4326
srid_arg=${INPUT_SRID}:${OUTPUT_SRID}

# for all dirs in "TARGET_DIR/codes"
idx=0
for code in $(ls "${SOURCE_DIR}");
do
  # Remove existing files
  rm -rf ${TARGET_DIR}/${code}

  # Create migrations directory if not exists
  mkdir -p ${TARGET_DIR}/${code}

  # CTPRVN (시도)
  if [ $idx -eq 0 ]; then
    FLAGS="-c -I"
  else
    FLAGS="-a"
  fi

  # CTPRVN (시도)
  shp2pgsql -s ${srid_arg} -W cp949 ${FLAGS} ${SOURCE_DIR}/${code}/TL_SCCO_CTPRVN.shp > ${TARGET_DIR}/${code}/TL_SCCO_CTPRVN_${today_datetime_str}.sql

  # SIG (시군구)
  shp2pgsql -s ${srid_arg} -W cp949 ${FLAGS} ${SOURCE_DIR}/${code}/TL_SCCO_SIG.shp > ${TARGET_DIR}/${code}/TL_SCCO_SIG_${today_datetime_str}.sql

  # EMD (읍면동)
  shp2pgsql -s ${srid_arg} -W cp949 ${FLAGS} ${SOURCE_DIR}/${code}/TL_SCCO_EMD.shp > ${TARGET_DIR}/${code}/TL_SCCO_EMD_${today_datetime_str}.sql

  echo "Successfully generated SQL files for ${code} at ${TARGET_DIR}/${code} at ${today_datetime_str}"

  idx=$((idx+1))
done
