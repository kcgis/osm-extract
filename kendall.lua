local nodes = osm2pgsql.define_table({
    name = 'osm2pgsql_nodes',
    ids = { type = 'any', id_column = 'osm_id' },
    columns = {
        { column = 'id', sql_type = 'serial', create_only = true },
        { column = 'tags', type = 'hstore' },
        { column = 'the_geom', type = 'point', not_null = true }
    }
})

local ways = osm2pgsql.define_table({
    name = 'osm2pgsql_ways',
    ids = { type = 'way', id_column = 'osm_id' },
    columns = {
        { column = 'id', sql_type = 'serial', create_only = true },
        { column = 'tags', type = 'hstore' },
        { column = 'the_geom', type = 'multilinestring', not_null = true}
    }
})

local areas = osm2pgsql.define_table({
    name = 'osm2pgsql_areas',
    ids = { type = 'any', id_column = 'osm_id' },
    columns = {
        { column = 'id', sql_type = 'serial', create_only = true },
        { column = 'tags', type = 'hstore' },
        { column = 'the_geom', type = 'multipolygon', not_null = true}
    }
})

function osm2pgsql.process_node(object)
    nodes:insert({
        tags = object.tags,
        the_geom = object:as_point()
    })
end

function osm2pgsql.process_way(object)
    if object.is_closed then
        areas:insert({
            tags = object.tags,
            the_geom = object:as_polygon()
        })
        
        -- get centroid of any closed way
        nodes:insert({
            tags = object.tags,
            the_geom = object:as_polygon():centroid()
        })
    end

    ways:insert({
        tags = object.tags,
        the_geom = object:as_linestring()
    })
end


function osm2pgsql.process_relation(object)
    ways:insert({
        tags = object.tags,
        the_geom = object:as_multilinestring():line_merge()
    })

    if object.tags.type == 'multipolygon' or object.tags.type == 'boundary' then
        areas:insert({
            tags = object.tags,
            the_geom = object:as_multipolygon()
        })
    end
end