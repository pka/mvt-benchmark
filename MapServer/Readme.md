mapcache seed command:

sudo mapcache_seed -c /home/user/mvt-benchmark-master/mapserver/mapcache_mvt.xml -t ms_mvt -z 1,6 -n 4

with region extent:

sudo mapcache_seed -c /home/user/mvt-benchmark-master/mapserver/mapcache_mvt.xml -t ms_mvt -z 1,6 -n 4 -e 325000,5599000,343000,5615000


From Docker:

docker-compose up -d mapserver
docker-compose run mapcache mapcache_seed -c /etc/mapcache/config.xml -t ms_mvt -z 1,6 -n 4 -e 325000,5599000,343000,5615000


Watch web server logs:

docker-compose logs -f


Tested version:

docker-compose exec mapserver mapserv -v

MapServer version 7.2.2 OUTPUT=PNG OUTPUT=JPEG OUTPUT=KML SUPPORTS=PROJ SUPPORTS=AGG SUPPORTS=FREETYPE SUPPORTS=CAIRO SUPPORTS=SVG_SYMBOLS SUPPORTS=RSVG SUPPORTS=ICONV SUPPORTS=FRIBIDI SUPPORTS=WMS_SERVER SUPPORTS=WMS_CLIENT SUPPORTS=WFS_SERVER SUPPORTS=WFS_CLIENT SUPPORTS=WCS_SERVER SUPPORTS=SOS_SERVER SUPPORTS=FASTCGI SUPPORTS=GEOS SUPPORTS=POINT_Z_M SUPPORTS=PBF INPUT=JPEG INPUT=POSTGIS INPUT=OGR INPUT=GDAL INPUT=SHAPEFILE
