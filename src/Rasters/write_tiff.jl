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
