export TerraShapefileExt
module TerraShapefileExt

using Terra
using Shapefile


Terra.st_dims(x::Union{Missing,Shapefile.Point}) = x.x, x.y

function Terra.st_dims(xs::Vector{T}) where {T<:Union{Missing,Shapefile.Point}}
  points = st_dims.(xs)
  x = [p[1] for p in points]
  y = [p[2] for p in points]
  x, y
end


end
