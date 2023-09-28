using Rasters: Raster


function st_bbox(lon, lat)
  cellx = abs(lon[2] - lon[1])
  celly = abs(lat[2] - lat[1])
  bbox(minimum(lon) - cellx / 2, minimum(lat) - celly / 2,
    maximum(lon) + cellx / 2, maximum(lat) + celly / 2)
end


function st_bbox(ra::Raster)
  dims = ra.dims;
  
  lon = dims[1] |> collect
  lat = dims[2] |> collect
  st_bbox(lon, lat)
end


export st_bbox
