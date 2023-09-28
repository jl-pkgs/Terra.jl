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
  lon = b.xmin+cellsize/2:cellsize:b.xmax
  lat = b.ymin+cellsize/2:cellsize:b.ymax
  reverse_lat && (lat = reverse(lat))
  lon, lat
end


function bbox2ndim(b; cellsize=1 / 240)
  x, y = bbox2dims(b; cellsize)
  length(x), length(y)
end


bbox2range(b::bbox) = [b.xmin, b.xmax, b.ymin, b.ymax]

bbox2tuple(b::bbox) = (xmin=b.xmin, ymin=b.ymin, xmax=b.xmax, ymax=b.ymax)
bbox2vec(b::bbox) = [b.xmin, b.ymin, b.xmax, b.ymax]



function bbox_overlap(b::bbox, box::bbox; cellsize=1 / 240, reverse_lat=true)
  lon, lat = bbox2dims(b; cellsize, reverse_lat)
  Lon, Lat = bbox2dims(box; cellsize, reverse_lat)

  ilon = findall(b.xmin .< Lon .< b.xmax)
  ilat = findall(b.ymin .< Lat .< b.ymax)
  # 由于精度的原因，有一些会存在空值
  # ilon = indexin(lon, Lon)
  # ilat = indexin(lat, Lat)
  ## 必定是所有的数据都在box中，不然是程序的错误
  @assert length(lon) == length(ilon)
  @assert length(lat) == length(ilat)
  ilon, ilat
end


include("st_bbox.jl")


export bbox,
  bbox2range, bbox2vec,
  bbox2dims, bbox2ndim, 
  bbox_overlap
