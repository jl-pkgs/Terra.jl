using Test
using Terra
using NetCDFTools

# println(dirname(dirname(@__FILE__)))
# println(pwd())
# cd(dirname(@__FILE__)) do
include("test-MFDataset.jl")
include("test-mapslices.jl")
include("test-apply.jl")
include("test-Raster.jl")
include("test-gdal_polygonize.jl")
include("test-st_mosaic.jl")
