function cdo_grid(ra::AbstractRaster; fout="grid.txt", kw...)
  x, y = st_dims(ra)
  cdo_grid(x, y; fout, kw...)
end

function cdo_grid(x::AbstractVector, y::AbstractVector; 
  fout="grid.txt", verbose=true)

  grid = """
  gridtype = lonlat
  xsize = $(length(x))
  ysize = $(length(y))
  xfirst = $(minimum(x))
  xinc = 1
  yfirst = $(minimum(y))
  yinc = 1"""

  verbose && println(grid)
  writelines([grid], fout)
  fout
end

function cdo_grid(range, cellsize, mid::Bool; fout="grid.txt", kw...)
  delta = mid ? cellsize / 2 : 0
  x = range[1]+delta:cellsize:range[2]
  y = range[3]+delta:cellsize:range[4]
  cdo_grid(x, y; fout, kw...)
end

function cdo_bilinear(fin, fout, fgrid;
  options=`-f nc4 -z zip_1`, cdo="/opt/miniconda3/bin/cdo", verbose=false)
  wsl = (is_wsl() || is_windows()) ? "wsl" : ""
  # run(`$wsl $cdo -v`)
  cmd = `$wsl $cdo $options remapbil,$fgrid $fin $fout`
  verbose && println(cmd)
  run(cmd)
  nothing
end


export cdo_grid, cdo_bilinear
