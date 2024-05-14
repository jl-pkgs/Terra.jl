# copied from `GeoArrays`
const gdt_conversion = Dict{DataType,DataType}(
  Bool => UInt8,
  Int8 => UInt8,
  UInt64 => UInt32,
  Int64 => Int32
)


"""Converts type of Array for one that exists in GDAL."""
function cast_to_gdal(A::AbstractArray{<:Real})
  type = eltype(A)
  if type in keys(gdt_conversion)
    newtype = gdt_conversion[type]
    @warn "Casting $type to $newtype to fit in GDAL."
    # return newtype, 
    return convert(Array{newtype}, A)
  else
    error("Can't cast $(eltype(A)) to GDAL.")
  end
end

const OPTIONS_DEFAULT_TIFF = Dict(
  # "BIGTIFF" => "YES"
  "TILED" => "YES", # not work
  "COMPRESS" => "DEFLATE"
)

# https://gdal.org/tutorials/geotransforms_tut.html
function getgeotransform(ra::AbstractRaster)
  x, y = st_dims(ra)
  cellx, celly = st_cellsize(ra)
  y0 = y[1] - celly/2
  x0 = x[1] - cellx/2
  [x0, cellx, 0, y0, 0, celly]
end
