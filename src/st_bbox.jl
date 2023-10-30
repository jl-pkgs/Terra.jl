"""
    bbox(xmin, ymin, xmax, ymax)
    bbox(;xmin, ymin, xmax, ymax)
    bbox2tuple(b::bbox)
    bbox2vec(b::bbox)
    bbox2affine(size::Tuple{Integer, Integer}, b::bbox)

Spatial bounding box
"""
Base.@kwdef struct bbox
  xmin::Float64
  ymin::Float64
  xmax::Float64
  ymax::Float64
end



function bbox2dims(b::bbox; cellsize=1 / 240, reverse_lat=true)
  length(cellsize) == 1 && (cellsize = [1, 1] .* cellsize)

  cellx, celly = abs.(cellsize)
  lon = b.xmin+cellx/2:cellx:b.xmax
  lat = b.ymin+celly/2:celly:b.ymax
  
  (cellsize[2] < 0 || reverse_lat) && (lat = reverse(lat))
  lon, lat
end


function bbox2ndim(b; cellsize=1 / 240)
  length(cellsize) == 1 && (cellsize = [1, 1] .* cellsize)
  x, y = bbox2dims(b; cellsize)
  length(x), length(y)
end


# size: array size
function bbox2cellsize(b::bbox, size)
  nlon, nlat = size[1:2]
  cellx = (b.xmax - b.xmin) / nlon
  celly = (b.ymax - b.ymin) / nlat
  cellx, celly
end


bbox2range(b::bbox) = [b.xmin, b.xmax, b.ymin, b.ymax]
bbox2tuple(b::bbox) = (xmin=b.xmin, ymin=b.ymin, xmax=b.xmax, ymax=b.ymax)
bbox2vec(b::bbox) = [b.xmin, b.ymin, b.xmax, b.ymax]



function st_bbox(lon, lat)
  cellx = abs(lon[2] - lon[1])
  celly = abs(lat[2] - lat[1])
  bbox(minimum(lon) - cellx / 2, minimum(lat) - celly / 2,
    maximum(lon) + cellx / 2, maximum(lat) + celly / 2)
end

st_bbox(f::String) = gdalinfo(f)["bbox"]

# get large bbox, also know as bbox_merge
function st_bbox(bs::Vector{bbox})
  bboxs = bbox2vec.(bs)
  bbox_mat = cat(bboxs..., dims=2)
  b = [minimum(bbox_mat[1:2, :], dims=2)..., maximum(bbox_mat[3:4, :], dims=2)...]
  bbox(b...)
end



function bbox_overlap(b::bbox, box::bbox; cellsize=1 / 240, reverse_lat=true)
  lon, lat = bbox2dims(b; cellsize, reverse_lat)
  Lon, Lat = bbox2dims(box; cellsize, reverse_lat)

  ilon = findall(b.xmin .< Lon .< b.xmax)
  ilat = findall(b.ymin .< Lat .< b.ymax)
  # 由于精度的原因，有一些会存在空值
  ## 必定是所有的数据都在box中，不然是程序的错误
  @assert length(lon) == length(ilon)
  @assert length(lat) == length(ilat)
  ilon, ilat
end



## add support for Rasters
using Rasters: Raster

function st_bbox(ra::Raster)
  dims = ra.dims

  lon = dims[1] |> collect
  lat = dims[2] |> collect
  st_bbox(lon, lat)
end

st_bbox(ras::Vector{<:Raster}) = st_bbox(st_bbox.(ras))


function st_cellsize(r::Raster)
  lon = r.dims[1] # X
  lat = r.dims[2] # Y

  lon[2] - lon[1], lat[2] - lat[1] # cellx, celly
end

function st_mosaic(ras::Vector{<:Raster}; missingval=NaN)
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
  Raster(A, box; missingval)
end


export bbox,
  bbox2cellsize,
  bbox2range, bbox2vec,
  bbox2dims, bbox2ndim,
  bbox_overlap
export st_bbox, st_mosaic, st_cellsize
