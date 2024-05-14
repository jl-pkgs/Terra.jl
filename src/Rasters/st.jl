export st_mosaic


## add support for Rasters
function st_bbox(ra::AbstractRaster)
  # x, y = st_dims(ra)
  xlim, ylim = Rasters.Extents.extent(ra)
  bbox(xlim[1], ylim[1], xlim[2], ylim[2])
end

st_bbox(ras::Vector{<:Raster}) = st_bbox(st_bbox.(ras))



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


"""
    st_location(r::Raster, points::Vector{Tuple{T,T}})

return the overlaping indexes `inds`, and corresponding (i,j)

# Examples
```julia
inds, locs = st_location(r, points)
```
"""
function st_location(ra::AbstractRaster, points::Vector{Tuple{T,T}}) where {T<:Real}
  b = st_bbox(ra)
  nx, ny = size(ra)[1:2]
  cellx, celly = st_cellsize(ra)
  inds, locs = st_location.(points; b, cellx, celly, nx, ny) |> rm_empty
  inds, locs
end


function st_extract(ra::AbstractRaster, points::Vector{Tuple{T,T}}; combine=hcat) where {T<:Real}
  inds, locs = st_location(ra, points)
  cols = repeat([:], ndims(ra) - 2)
  lst = [ra.data[i, j, cols...] for (i, j) in locs]
  inds, combine(lst...) #cbind(lst...)
end


"""
    st_mosaic(ras::Vector{<:Raster}; missingval=NaN, crs=EPSG(4326), kw...)

# Arguments
- `kw`: others to `Raster`
"""
function st_mosaic(ras::Vector{<:Raster}; missingval=NaN, crs=EPSG(4326), kw...)
  r = ras[1]
  T = eltype(r)
  missingval = T(missingval)

  cellsize = st_cellsize(r)

  box = st_bbox(ras)
  lon2, lat2 = bbox2dims(box; cellsize)

  _size = length(lon2), length(lat2)
  nd = ndims(r)
  cols = repeat([:], nd - 2)

  nd >= 3 && (_size = (_size..., size(r)[3:end]...))
  A = fill(missingval, _size)

  # 这里不能使用并行
  # Threads.@threads 
  for i in eachindex(ras)
    r = ras[i]
    b = st_bbox(r)
    ilon, ilat = bbox_overlap(b, box; cellsize)
    A[ilon, ilat, cols...] .= r.data
  end
  Raster(A, box; missingval, crs, kw...)
end


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
