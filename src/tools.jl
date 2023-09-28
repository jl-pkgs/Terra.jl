function set_names(ra::AbstractRaster, names)
  rebuild(ra, name = names)
end

function Base.names(ra::AbstractRaster)
  ra.name
end


function shp_files(f)
  [f,
    replace(f, ".shp" => ".shx"),
    replace(f, ".shp" => ".prj"),
    replace(f, ".shp" => ".dbf")]
end

function rm_shp(f)
  rm.(shp_files(f))
  nothing
end


export set_names, names, rm_shp
