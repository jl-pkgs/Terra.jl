using ProgressMeter
using NetCDFTools
using NetCDFTools.Ipaper

include("tools_Ipaper.jl")
# include("tools_NCDatasets.jl")
# include("main_MFDataset.Jl")

include("tools_Zarr.jl")
include("mapslices_3d_chunk.jl")
include("mapslices_3d_zarr.jl")
include("mapslices_3d.jl")
include("main_YAXArrays.jl")
