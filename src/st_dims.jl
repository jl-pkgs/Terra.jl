function st_cellsize(r::Raster)
  lon = r.dims[1] # X
  lat = r.dims[2] # Y
  
  lon[2] - lon[1], lat[2] - lat[1] # cellx, celly
end

function st_dims(r::Raster)
  x = r.dims[1].val.data
  y = r.dims[2].val.data
  x, y
end

export st_dims
