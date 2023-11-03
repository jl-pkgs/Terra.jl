export TerraYAXArraysExt
module TerraYAXArraysExt

using Terra
using YAXArrays

Base.names(ds::YAXArrays.Dataset) = string.(collect(keys(ds.cubes))) |> sort
Base.getindex(ds::YAXArrays.Dataset, i) = ds[names(ds)[i]]

function get_zarr(ds::YAXArrays.Dataset)
  vars = names(ds)
  zs = map(var -> ds[var].data, vars)
  zs
end

function Terra.st_mosaic(ds::YAXArrays.Dataset)
  missingval=0.0f0
  crs=EPSG(4326)
  grids = names(ds)

  ras = []
  for grid in grids
    z = ds[grid].data
    b = st_bbox(z)
    ra = Raster(z, st_bbox(z); missingval, crs)
    push!(ras, ra)
  end
  ras
  st_mosaic(ras)
end

Terra.st_bbox(ds::YAXArrays.Dataset) = st_bbox.(get_zarr(ds)) # multiple

end
