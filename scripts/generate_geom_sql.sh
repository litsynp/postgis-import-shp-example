#!/bin/bash

# Extract renewed SQL files from shapefiles
today_datetime_str=$(date +"%Y%m%d%H%M%S")
code=11000

# SRID
input_srid=5179
output_srid=4326
srid_arg=${input_srid}:${output_srid}

# Remove existing files
rm -rf migrations/${code}

# Create migrations directory if not exists
mkdir -p migrations/${code}

# CTPRVN (시도)
shp2pgsql -s ${srid_arg} -W cp949 shapefiles/${code}/TL_SCCO_CTPRVN.shp > migrations/${code}/TL_SCCO_CTPRVN_${today_datetime_str}.sql

# SIG (시군구)
shp2pgsql -s ${srid_arg} -W cp949 shapefiles/${code}/TL_SCCO_SIG.shp > migrations/${code}/TL_SCCO_SIG_${today_datetime_str}.sql

# EMD (읍면동)
shp2pgsql -s ${srid_arg} -W cp949 shapefiles/${code}/TL_SCCO_EMD.shp > migrations/${code}/TL_SCCO_EMD_${today_datetime_str}.sql

echo "Successfully generated SQL files for ${code} at migrations/${code} at ${today_datetime_str}"
