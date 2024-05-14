using Ipaper.sf
import Ipaper.sf: st_bbox
import Ipaper.sf: FileNetCDF, FileGDAL, st_dims, st_cellsize
using Zarr: ZArray


st_bbox(z::ZArray) = bbox(z.attrs["bbox"]...)
st_bbox(zs::Vector{<:ZArray}) = st_bbox(st_bbox.(zs))

function st_dims(x::FileGDAL)
  gdalinfo(x.file)["dims"]
end

# st_bbox(f::String) = gdalinfo(f)["bbox"]
export st_bbox
export st_dims, st_cellsize
