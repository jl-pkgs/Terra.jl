@testset "rast_apply" begin
  using Dates
  using Statistics
  
  range = [70, 140, 15, 55]
  cellsize = 1.0

  lon = range[1]+cellsize/2:cellsize:range[2]
  lat = range[3]+cellsize/2:cellsize:range[4]
  dates = DateTime(2010):Day(1):DateTime(2013, 12, 31)

  # years = year.(dates)
  ntime = length(dates)

  data = rand(length(lon), length(lat), ntime)
  dims = X(lon), Y(lat), Ti(dates)

  ra = Raster(data, dims)

  probs = [0.05, 0.95]
  dims_new = Dim{:prob}(probs)

  r1 = rast_apply(ra, 3, probs; by=year.(dates), fun=quantile, combine=true,
    dims_new, name="quantile")
  @test size(r1) == (70, 40, 2, 4)
  
  
  r2 = rast_apply(ra, 3; by=year.(dates), fun=mean, combine=true,
    dims_new, name="mean")
  @test size(r2) == (70, 40, 4)


  r3 = rast_apply(ra, 3; fun=mean, combine=true,
    dims_new, name="mean")
  @test size(r3) == (70, 40)

  r4 = rast_apply(ra, 3, probs; fun=quantile, combine=true,
    dims_new, name="mean")
  @test size(r4) == (70, 40, 2)
end
