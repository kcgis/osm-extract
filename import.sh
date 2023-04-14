#!/bin/bash

# fill in the connstr as needed
osm2pgsql -d connstr --slim -O flex -S kendall.lua -j kendall.osm.pbf
