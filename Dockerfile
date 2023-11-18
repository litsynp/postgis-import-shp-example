# syntax=docker/dockerfile:1
FROM postgis/postgis:15-3.3 as builder
RUN apt update
RUN apt install -y postgis
RUN which shp2pgsql

FROM postgis/postgis:15-3.3

COPY --from=builder /usr/bin/shp2pgsql /usr/bin/shp2pgsql

# Check if shp2pgsql is available
RUN which shp2pgsql
