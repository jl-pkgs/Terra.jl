using Ipaper.sf
import Ipaper.sf: st_bbox
using Zarr: ZArray

## add support for Rasters
function st_bbox(ra::AbstractRaster)
  # x, y = st_dims(ra)
  xlim, ylim = Rasters.Extents.extent(ra)
  bbox(xlim[1], ylim[1], xlim[2], ylim[2])
end

st_bbox(ras::Vector{<:Raster}) = st_bbox(st_bbox.(ras))
st_bbox(z::ZArray) = bbox(z.attrs["bbox"]...)
st_bbox(zs::Vector{<:ZArray}) = st_bbox(st_bbox.(zs))

# st_bbox(f::String) = gdalinfo(f)["bbox"]
export st_bbox
