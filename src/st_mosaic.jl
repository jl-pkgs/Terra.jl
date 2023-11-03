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
  jcol = repeat([:], nd - 2)

  nd >= 3 && (_size=(_size..., size(r)[3:end]...))
  A = fill(missingval, _size)

  for i in eachindex(ras)
    r = ras[i]
    b = st_bbox(r)
    ilon, ilat = bbox_overlap(b, box; cellsize)
    A[ilon, ilat, jcol...] = r.data
  end
  Raster(A, box; missingval, crs, kw...)
end

export st_mosaic
