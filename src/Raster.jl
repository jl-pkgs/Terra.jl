function guess_dims(A::AbstractMatrix, b::bbox; reverse_lat=true, ignore...)
  range = bbox2range(b)

  nlon, nlat = size(A)[1:2]
  cellx = (range[2] - range[1]) / nlon
  celly = (range[4] - range[3]) / nlat
  lon = range[1]+cellx/2:cellx:range[2]
  lat = range[3]+celly/2:celly:range[4]

  reverse_lat && (lat = reverse(lat))
  X(lon), Y(lat)
end

function guess_dims(A::AbstractArray{T,3}, b::bbox;
  reverse_lat=true, date=nothing, ignore...) where {T}

  # ndim = ndim(A)
  x, y = guess_dims(@view(A[:, :, 1]), b; reverse_lat)
  ntime = size(A, 3)
  time = date === nothing ? Ti(1:ntime) : Ti(date)
  x, y, time
end



# only for 2d and 3d array
function Raster(A::AbstractArray, b::bbox; reverse_lat=true, date=nothing, kw...)
  dims = guess_dims(A, b; date, reverse_lat)
  Raster(A, dims; kw...)
end

