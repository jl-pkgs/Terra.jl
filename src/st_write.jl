using ArchGDAL
const AG = ArchGDAL


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


function st_write(ra::AbstractRaster, f::AbstractString;
  force=true,
  options=String[], NUM_THREADS=4, BIGTIFF=true, kw...)

  driver = AG.extensiondriver(f)

  if (driver == "GTiff")
    options = [options..., "COMPRESS=DEFLATE", "TILED=YES", "NUM_THREADS=$NUM_THREADS"]
    BIGTIFF && (options = [options..., "BIGTIFF=YES"])
    # TODO: translate into dict
  end

  dtype = nonmissingtype(eltype(ra.data))

  try
    convert(ArchGDAL.GDALDataType, dtype)
    nothing
  catch
    ra = rebuild(ra, data=cast_to_gdal(ra.data))
  end

  write(f, ra; force, kw...)
end


export st_write
