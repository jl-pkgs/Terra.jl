using Extents
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


# size: array size
function bbox2cellsize(b::bbox, size)
  nlon, nlat = size[1:2]
  cellx = (b.xmax - b.xmin) / nlon
  celly = (b.ymax - b.ymin) / nlat
  cellx, celly
end

# 两个至少提供一个
function bbox2dims(b::bbox; size=nothing, cellsize=nothing, reverse_lat=true)
  if size !== nothing && cellsize === nothing
    cellsize = bbox2cellsize(b, size)
  end
  
  length(cellsize) == 1 && (cellsize = [1, 1] .* cellsize)

  cellx, celly = abs.(cellsize)
  lon = b.xmin+cellx/2:cellx:b.xmax
  lat = b.ymin+celly/2:celly:b.ymax
  
  (cellsize[2] < 0 || reverse_lat) && (lat = reverse(lat))
  lon, lat
end


function bbox2ndim(b; size=nothing, cellsize=nothing, )
  x, y = bbox2dims(b; size, cellsize)
  length(x), length(y)
end

"""
    in_bbox(b::bbox, (lon, lat))  
    in_bbox(bs::Vector{bbox}, (lon, lat))
"""
in_bbox(b::bbox, (lon, lat)) = (b.xmin < lon < b.xmax) && (b.ymin < lat < b.ymax)

in_bbox(bs::Vector{bbox}, (lon, lat)) = [in_bbox(b, (lon, lat)) for b in bs]


bbox2range(b::bbox) = [b.xmin, b.xmax, b.ymin, b.ymax]
bbox2tuple(b::bbox) = (xmin=b.xmin, ymin=b.ymin, xmax=b.xmax, ymax=b.ymax)
bbox2vec(b::bbox) = [b.xmin, b.ymin, b.xmax, b.ymax]
bbox2lims(b::bbox) = ((b.xmin, b.xmax), (b.ymin, b.ymax))

function bbox_overlap(b::bbox, box::bbox; size=nothing, cellsize=nothing, reverse_lat=true)
  lon, lat = bbox2dims(b; size, cellsize, reverse_lat)
  Lon, Lat = bbox2dims(box; size, cellsize, reverse_lat)

  ilon = findall(b.xmin .< Lon .< b.xmax)
  ilat = findall(b.ymin .< Lat .< b.ymax)
  # 由于精度的原因，有一些会存在空值
  ## 必定是所有的数据都在box中，不然是程序的错误
  @assert length(lon) == length(ilon)
  @assert length(lat) == length(ilat)
  ilon, ilat
end


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

## add support for Rasters
function st_bbox(ra::Raster)
  # x, y = st_dims(ra)
  xlim, ylim = Extents.extent(ra)
  bbox(xlim[1], ylim[1], xlim[2], ylim[2])
end

st_bbox(ras::Vector{<:Raster}) = st_bbox(st_bbox.(ras))

st_bbox(z::ZArray) = Terra.bbox(z.attrs["bbox"]...)
st_bbox(zs::Vector{<:ZArray}) = st_bbox(st_bbox.(zs))


export bbox,
  in_bbox, bbox2lims, 
  bbox2cellsize,
  bbox2range, bbox2vec,
  bbox2dims, bbox2ndim,
  bbox_overlap
export st_bbox, st_cellsize
