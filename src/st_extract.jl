function st_location((x, y)::Tuple{Real,Real};
  b::bbox, cellx::Real, celly::Real, nx::Int, ny::Int)

  i = (x - b.xmin) / cellx
  if celly > 0
    j = (y - b.ymin) / celly
  else
    j = (b.ymax - y) / abs(celly)
  end
  i = floor(Int, i)
  j = floor(Int, j)

  if (i < 1 || i > nx) || (j < 1 || j > ny)
    nothing
  else
    i, j
  end
end

export st_extract, st_location
