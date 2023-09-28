
module Terra

# using NCDatasets
# using DimensionalData
# 
# const NCD = NCDatasets
# const DD = DimensionalData
using DocStringExtensions: TYPEDSIGNATURES, METHODLIST

using Reexport
@reexport using Rasters

rast = Raster
brick = RasterStack


include("DataType/bbox.jl")
include("Raster.jl")

include("GDAL/GDAL.jl")


# include("rast.jl")
include("apply.jl")
include("tools.jl")



export rast, brick, 
  rast_apply, 
  set_names

end # module
