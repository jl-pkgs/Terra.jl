
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


rast = Raster;
brick = RasterStack;


export rast, brick, 
  apply

end # module
