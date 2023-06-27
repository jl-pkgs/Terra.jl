
module Terra


# using NCDatasets
# using DimensionalData
# 
# const NCD = NCDatasets
# const DD = DimensionalData
using DocStringExtensions: TYPEDSIGNATURES, METHODLIST

using Reexport
@reexport using Rasters

# include("rast.jl")
include("apply.jl")
include("tools.jl")


rast = Raster;
brick = RasterStack;


export rast, brick, 
  rast_apply, 
  set_names

end # module
