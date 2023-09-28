@testset "rast_apply" begin
  b = bbox(70, 15, 140, 55)

  data = rand(70, 40)
  ra2 = rast(data, b)
  @test st_bbox(ra2) == b
  
  data = rand(70, 40, 10)
  ra3 = rast(data, b)
  @test st_bbox(ra3) == b
end
