module Terra
# using NCDatasets
# using DimensionalData
# const NCD = NCDatasets
# const DD = DimensionalData
using DocStringExtensions: TYPEDSIGNATURES, METHODLIST

using Zarr
using Reexport

using ArchGDAL
const AG = ArchGDAL

@reexport using Ipaper.sf
@reexport using Rasters
using Rasters: AbstractRaster
Raster = Raster
brick = RasterStack

include("GDAL/GDAL.jl")

include("st_dims.jl")
include("st_bbox.jl")
include("Raster.jl")

include("st_extract.jl")
include("st_mosaic.jl")
include("st_resample.jl")

include("st_write.jl")
include("IO.jl")

include("MFDataset/MFDataset.jl")

# include("Raster.jl")
include("apply.jl")
include("tools.jl")

include("tools_Ipaper.jl")
include("main_cdo.jl")

export Raster, brick, 
  rast_apply, 
  set_names

end # module
