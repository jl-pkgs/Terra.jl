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

function st_write(ra::AbstractRaster, f::AbstractString;
  options=Dict{String,String}(), NUM_THREADS=4, BIGTIFF=true,
  force=true, kw...)

  driver = find_shortname(f)
  # driver = AG.extensiondriver(f)

  if (driver in ["COG", "GTiff"])
    # options = [options..., "COMPRESS=DEFLATE", "TILED=YES", "NUM_THREADS=$NUM_THREADS"]
    # BIGTIFF && (options = [options..., "BIGTIFF=YES"])
    options = merge(OPTIONS_DEFAULT_TIFF, options)

    NUM_THREADS > 1 && (options["NUM_THREADS"] = "$NUM_THREADS")
    BIGTIFF && (options["BIGTIFF"] = "YES")
  end

  dtype = nonmissingtype(eltype(ra.data))
  try
    convert(ArchGDAL.GDALDataType, dtype)
    nothing
  catch
    ra = rebuild(ra, data=cast_to_gdal(ra.data))
  end
  write(f, ra; force, options, driver, kw...)
end



# https://gdal.org/tutorials/geotransforms_tut.html
function getgeotransform(ra::AbstractRaster)
  x, y = st_dims(ra)
  cellx, celly = st_cellsize(ra)
  y0 = y[1] - celly/2
  x0 = x[1] - cellx/2
  [x0, cellx, 0, y0, 0, celly]
end


## write tiff 
# no missing value is allowed
function write_tiff(ra::AbstractRaster, f::AbstractString;
  nodata=nothing, options=String[], NUM_THREADS=4, BIGTIFF=true)

  shortname = find_shortname(f)
  w, h, b = size(ra)
  dtype = eltype(ra)
  data = ra.data
  
  use_nodata = nodata !== nothing # 或者数据含有missing
  # Set compression options for GeoTIFFs
  if (shortname == "GTiff")
    options = [options..., "COMPRESS=DEFLATE", "TILED=YES", "NUM_THREADS=$NUM_THREADS"]
    BIGTIFF && (options = [options..., "BIGTIFF=YES"])
  end
  
  # Slice data and replace missing by nodata
  if isa(dtype, Union) && dtype.a == Missing
    dtype = dtype.b
    try
      convert(ArchGDAL.GDALDataType, dtype)
      nothing
    catch
      dtype, data = cast_to_gdal(data)
    end
    nodata === nothing && (nodata = typemax(dtype))
    m = ismissing.(data)
    data[m] .= nodata
    data = Array{dtype}(data)
    use_nodata = true
  end

  try
    convert(ArchGDAL.GDALDataType, dtype)
    nothing
  catch
    dtype, data = cast_to_gdal(data)
  end

  ArchGDAL.create(fn, driver=ArchGDAL.getdriver(shortname), width=w, height=h, nbands=b, dtype=dtype, options=options) do dataset
    for i = 1:b
      band = ArchGDAL.getband(dataset, i)
      ArchGDAL.write!(band, data[:, :, i])
      use_nodata && ArchGDAL.GDAL.gdalsetrasternodatavalue(band.ptr, nodata)
    end

    # Set geotransform and crs
    gt = getgeotransform(ra)
    
    # set 
    ArchGDAL.GDAL.gdalsetgeotransform(dataset.ptr, gt)
    ArchGDAL.GDAL.gdalsetprojection(dataset.ptr, GFT.val(ga.crs))
  end
  
  ## 默认采用wgs84
  if ga.names !== nothing
    set_bandnames(fn, ga.names) # GDAL
  end
  fn
end


export st_write
