import Ipaper.sf: FileNetCDF, FileGDAL, st_dims, st_cellsize

function st_dims(x::FileGDAL)
  gdalinfo(x.file)["dims"]
end

function st_dims(ra::AbstractRaster)
  ds = map(dims(ra)) do d
    Rasters.DimensionalData.maybeshiftlocus(Center(), d)
  end
  x = ds[1].val.data
  y = ds[2].val.data
  x, y
end

function st_cellsize(ra::AbstractRaster)
  # x, y = st_dims(r)
  # x[2] - x[1], y[2] - y[1]
  lon = ra.dims[1] # X
  lat = ra.dims[2] # Y
  lon[2] - lon[1], lat[2] - lat[1] # cellx, celly
end

export st_dims, st_cellsize
