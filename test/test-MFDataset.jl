# 生成一些测试数据
# using NetCDFTools
using Terra
using Test

dir_root = dirname(dirname(@__FILE__))

@testset "brick" begin
  b = bbox(70, 15, 140, 55)
  A = rand(10, 10, 5)

  ra1 = Raster(A, b; name=:x)
  ra2 = Raster(A, b; name=:y)

  @test_nowarn ras = brick(ra1, ra2)
end
# write("data/test1-01.nc", ras)
# write("data/test1-02.nc", ras)
# write("data/test1-03.nc", ras)
# write("data/test1-04.nc", ras)

@testset "tiff file" begin
  # b = bbox(70, 15, 140, 55)
  # A = rand(10, 10)
  # ra = Raster(A, b)
  f = "$dir_root/data/test1.tif"
  # write(f, ra, force=true)

  ra = Raster(f)
  @test st_bbox(ra) == st_bbox(f)
end
## 数据保存没有问题，可能是读取的时候出现了bug
# ra = Raster(f) |> edge2center


indir = "$dir_root/data"
fs = [
  "$indir/test1-01.nc",
  "$indir/test1-02.nc",
  "$indir/test1-03.nc",
  "$indir/test1-04.nc"
]
f = fs[1]# coord存在明显的错误

@testset "MFDataset" begin
  _chunkszie = (5, 5, typemax(Int))
  m = MFDataset(fs, _chunkszie)

  @test m.bbox == st_bbox(f)
  @test m.ntime == 20
  @test size(m.chunks) == (2, 2, 1)
end
