using Rasters: Intervals, Center, ForwardOrdered, ReverseOrdered
using Rasters.DimensionalData

"""
    guess_dims(A::AbstractMatrix, b::bbox; 
        reverse_lat=true, sampling=Intervals(Center()), ignored...)
    guess_dims(A::AbstractArray{T,3}, b::bbox;
        reverse_lat=true, date=nothing, kw...) where {T}    
"""
function guess_dims(A::AbstractMatrix, b::bbox;
  reverse_lat=true, sampling=Intervals(Center()), ignored...)
  # range = bbox2range(b)
  cellsize = bbox2cellsize(b, size(A))
  lon, lat = bbox2dims(b; cellsize, reverse_lat)

  x = X(Projected(lon; crs=EPSG(4326), sampling))
  y = Y(Projected(lat; crs=EPSG(4326), sampling))
  x, y
end


function guess_dims(A::AbstractArray{T,3}, b::bbox;
  reverse_lat=true, date=nothing, kw...) where {T}

  x, y = guess_dims(@view(A[:, :, 1]), b; reverse_lat, kw...)
  ntime = size(A, 3)
  time = date === nothing ? Ti(1:ntime) : Ti(date)
  x, y, time
end


# only for 2d and 3d array
# 默认不要missingval
function Raster(A::AbstractArray, b::bbox;
  reverse_lat=true, date=nothing,
  missingval=nothing, kw...)

  dims = guess_dims(A, b; date, reverse_lat)
  Raster(A, dims; missingval, kw...)
end

function edge2center(ra)
  ds = map(dims(ra)) do d
    Rasters.maybeshiftlocus(Center(), d)
  end
  set(ra, ds)
end

function set_names(ra::AbstractRaster, names)
  rebuild(ra, name=names)
end

function Base.names(ra::AbstractRaster)
  ra.name
end

export set_names, names
export edge2center
