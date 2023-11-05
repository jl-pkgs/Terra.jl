using DimensionalData


function st_cellsize(ra::Raster)
  # x, y = st_dims(r)
  lon = ra.dims[1] # X
  lat = ra.dims[2] # Y
  lon[2] - lon[1], lat[2] - lat[1] # cellx, celly
  # x[2] - x[1], y[2] - y[1]
end

function st_dims(ra::Raster)
  ds = map(dims(ra)) do d
    DimensionalData.maybeshiftlocus(Center(), d)
  end
  x = ds[1].val.data
  y = ds[2].val.data
  x, y
end

export st_dims
