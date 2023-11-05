# 生成一些测试数据
# using NetCDFTools
using Terra
using Rasters
using Test

@testset "brick" begin
  b = bbox(70, 15, 140, 55)
  A = rand(10, 10, 5)

  ra1 = rast(A, b; name=:x)
  ra2 = rast(A, b; name=:y)

  @test_nowarn ras = brick(ra1, ra2)
end
# write("data/test1-01.nc", ras)
# write("data/test1-02.nc", ras)
# write("data/test1-03.nc", ras)
# write("data/test1-04.nc", ras)

dir_root = dirname(dirname(@__FILE__))
indir = "$dir_root/data"
fs = [
  "$indir/test1-01.nc",
  "$indir/test1-02.nc",
  "$indir/test1-03.nc",
  "$indir/test1-04.nc"
]
f = fs[1]

@testset "MFDataset" begin
  _chunkszie = (5, 5, typemax(Int)) 
  m = MFDataset(fs, _chunkszie)

  @test m.bbox == st_bbox(f)
  @test m.ntime == 20
  @test size(m.chunks) == (2, 2, 1)  
end
