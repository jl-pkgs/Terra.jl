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


const OPTIONS_DEFAULT_TIFF = Dict(
  # "BIGTIFF" => "YES"
  # "TILED" => "YES", # not work
  "COMPRESS" => "DEFLATE"
)

function st_write(ra::AbstractRaster, f::AbstractString;
  options=Dict{String,String}(), NUM_THREADS=4, BIGTIFF=true,
  force=true, kw...)

  driver = AG.extensiondriver(f)
  if (driver in ["COG", "GTiff"])
    # options = [options..., "COMPRESS=DEFLATE", "TILED=YES", "NUM_THREADS=$NUM_THREADS"]
    # BIGTIFF && (options = [options..., "BIGTIFF=YES"])
    options = merge(OPTIONS_DEFAULT_TIFF, options)
    options["NUM_THREADS"] = "$NUM_THREADS"
    BIGTIFF && (options["BIGTIFF"] = "YES")
  end

  dtype = nonmissingtype(eltype(ra.data))
  try
    convert(ArchGDAL.GDALDataType, dtype)
    nothing
  catch
    ra = rebuild(ra, data=cast_to_gdal(ra.data))
  end
  write(f, ra; force, options, kw...)
end


export st_write
