module Terra
# using NCDatasets
# const NCD = NCDatasets
using DocStringExtensions: TYPEDSIGNATURES, METHODLIST

using Zarr
using Reexport

using ArchGDAL
const AG = ArchGDAL

@reexport using Ipaper.sf

include("GDAL/GDAL.jl")

include("st_bbox.jl")
include("st_extract.jl")
include("st_resample.jl")

# include("st_write.jl")
include("IO.jl")

include("MFDataset/MFDataset.jl")

include("apply.jl")
include("tools_Ipaper.jl")

export rast_apply, set_names

end # module
