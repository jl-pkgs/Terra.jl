using Test
using Terra

# 这里需要想办法提高性能
@testset "mapslices_3d_chunk" begin
  x = rand(10, 10, 4)
  y = rand(10, 10, 4)
  z = rand(10, 10, 4)

  fun(x, y, z) = x + y + z

  r1 = mapslices_3d_chunk(fun, x, y, z; parallel=false, option=1)
  r2 = mapslices_3d_chunk(fun, x, y, z; parallel=false, option=2)

  @test r1 == x + y + z
  @test r1 == r2
end
