using Test
using Terra

# println(dirname(@__FILE__))
# println(pwd())
# cd(dirname(@__FILE__)) do
include("test-apply.jl")
include("test-bbox.jl")

include("test-gdal_polygonize.jl")
