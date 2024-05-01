import Ipaper: cdo_grid
import Ipaper: writelines, is_linux, is_windows, is_linux
export cdo_grid
export rm_shp

flipud(x::AbstractArray{T,2}) where {T<:Real} = x[end:-1:1, :]
flipud(x::AbstractArray{T,3}) where {T<:Real} = x[end:-1:1, :, :]

fliplr(x::AbstractArray{T,2}) where {T<:Real} = x[:, end:-1:1]
fliplr(x::AbstractArray{T,3}) where {T<:Real} = x[:, end:-1:1, :]

# add a resample function at here
function cdo_grid(ra::AbstractRaster; fout="grid.txt", kw...)
  x, y = st_dims(ra)
  cdo_grid(x, y; fout, kw...)
end

function shp_files(f)
  [f,
    replace(f, ".shp" => ".shx"),
    replace(f, ".shp" => ".prj"),
    replace(f, ".shp" => ".dbf")]
end

function rm_shp(f)
  rm.(shp_files(f))
  nothing
end
