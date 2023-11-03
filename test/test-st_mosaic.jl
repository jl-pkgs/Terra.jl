using Terra
using Test

@testset "st_mosaic" begin
  b = bbox(70, 15, 140, 55)
  ras = [Raster(rand(10, 10, 4), b) for i = 1:10]

  r = st_mosaic(ras)
  @test size(r) == (10, 10, 4)
end

@testset "st_resample" begin
  b = bbox(70, 15, 140, 55)
  ra = Raster(rand(100, 100, 4), b)
  r = st_resample(ra)
  @test size(r) == (10, 10, 4)
end
