#!/bin/sh

# get latest geofabric extract of IL
wget -N https://download.geofabrik.de/north-america/us/illinois-latest.osm.pbf

# perform osmium extract
osmium extract -p kendall.geojson illinois-latest.osm.pbf -o kendall.osm.pbf -s smart
