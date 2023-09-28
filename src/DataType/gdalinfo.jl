using ArchGDAL


function gdalinfo(file::AbstractString)
  ds = ArchGDAL.read(file)
  gt = ArchGDAL.getgeotransform(ds)
  # band = ArchGDAL.getband(ds, 1)
  w, h = ArchGDAL.width(ds), ArchGDAL.height(ds)
  dx, dy = gt[2], -gt[end]
  x0 = gt[1] #+ dx/2
  x1 = x0 + w * dx
  y1 = gt[4] #- dy/2
  y0 = y1 - h * dy
  b = bbox(x0, y0, x1, y1)

  lon = x0+dx/2:dx:x1
  lat = reverse(y0+dy/2:dy:y1)
  nband = ArchGDAL.nraster(ds)

  Dict(
    # "file"     => basename(file),
    "bbox" => b,
    "cellsize" => [dx, dy],
    "coords" => [lon, lat],
    "dim" => (Int64.([w, h, nband])...,) # convert to tuple
  )
end
