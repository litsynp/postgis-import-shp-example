## How to

Access interactive shell of the PostgreSQL container.

This project is using shapefiles from https://business.juso.go.kr/ as an example.

For this example, we only run ctprvn, sig, and emd with the following command.

First, place "구형의 도역 XX월 전체.zip" in the shapefiles/ directory.

And then run the following command.

```shell
$ make create   # Create shapefiles under migrations/ and run the migrations
```

## Check the result

```shell
$ make shell
```

```shell
$ psql -U postgres
```

```sql
SELECT gid,
       emd_cd,
       emd_eng_nm,
       emd_kor_nm,
       ST_AsGeoJSON(geom) AS geom -- Exclude this colum if not needed
FROM tl_scco_emd;

SELECT gid,
       sig_cd,
       sig_eng_nm,
       sig_kor_nm,
       ST_AsGeoJSON(geom) AS geom -- Exclude this colum if not needed
FROM tl_scco_sig;

SELECT gid,
       ctprvn_cd,
       ctp_eng_nm,
       ctp_kor_nm,
       ST_AsGeoJSON(geom) AS geom -- Exclude this colum if not needed
FROM tl_scco_ctprvn;
```

![geojson](https://github.com/litsynp/postgis-spatial-index/assets/42485462/3ca7b00e-3eb1-43eb-8540-4b38a2d4ab5a)

Copy the geojson column value and paste it in https://geojson.io/, and you will see a geometry of
some place in Korea.

Or you can use the following query to see an intersection of two geometries.

```sql
select *
from tl_scco_sig
where ST_Intersects(geom, ST_GeomFromText('POINT(126.9858 37.5600)', 4326));
```

![intersection query result](https://github.com/litsynp/postgis-spatial-index/assets/42485462/e255447e-0f79-4c66-8b7b-2c7cc33ef7a2)

## Destroy the database

```shell
$ make destroy          # Cleans up shapefiles/ and drops the database
$ make migration:clean  # Cleans up migrations/. Don't run if you want to keep the migrations
```

## Tips

### Do not use Docker PostGIS alpine image

If you use the alpine image, you will get the following error.

```shell
$ shp2pgsql -s 5186 -W cp949 /shapefiles/11000/TL_SCCO_SIG.shp 
Error loading shared library libintl.so.8: No such file or directory (needed by /usr/local/bin/shp2pgsql)
Error relocating /usr/local/bin/shp2pgsql: libintl_bindtextdomain: symbol not found
Error relocating /usr/local/bin/shp2pgsql: libintl_textdomain: symbol not found
Error relocating /usr/local/bin/shp2pgsql: libintl_gettext: symbol not found
```

However, if you use postgis instead of postgis-alpine, you will get this error instead.

```shell
# shp2pgsql
bash: shp2pgsql: command not found
```

You can refer to
this [issue](https://gis.stackexchange.com/questions/384381/shp2pgsql-available-in-postgis13-3-1-alpine-but-no-in-postgis13-3-1-docker-ima).
It's already fixed in this repository; check out the Dockerfile.
