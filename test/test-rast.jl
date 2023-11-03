using Test
using Terra


@testset "rast_apply" begin
  using Dates

  b = bbox(70, 15, 140, 55)

  # 2d array
  data = rand(70, 40)
  ra2 = rast(data, b)
  @test st_bbox(ra2) == b

  # 3d array
  data = rand(70, 40, 10)
  ra3 = rast(data, b)
  @test st_bbox(ra3) == b


  ## 3d array with date
  dates = DateTime(2010):Day(1):DateTime(2010, 12, 31)
  ntime = length(dates)

  b = bbox(70, 15, 140, 55)
  data = rand(70, 40, ntime)
  # obj_size(data)
  ra = rast(data, b; date=dates)
  @test collect(ra.dims[3]) == dates
end


@testset "extent" begin
  A = rand(360, 180)
  b = bbox(-180, -90, 180, 90)

  ra = rast(A, b)
  # write("a.tif", ra, force=true)
  # run(`gdalinfo a.tif`)
  ext = extent(ra)
  @test ext[1] == (-180, 180)
  @test ext[2] == (-90, 90)
end
