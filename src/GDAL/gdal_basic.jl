"""
Terra Object

- `class`      : 
- `dimensions` : 
- `resolution` : 
- `extent`     : 
- `coord.ref.` : 
- `source`     : 
- `names`      : `[bandnames]`
"""

# https://stackoverflow.com/questions/32609570/how-to-set-the-band-description-option-tag-of-a-geotiff-file-using-gdal-gdalw

gdal_close(ds::Ptr{Nothing}) = GDAL.gdalclose(ds)

# gdal_open(file::AbstractString) = ArchGDAL.read(file)
function gdal_open(f::AbstractString, mode=GDAL.GA_ReadOnly, args...)
  GDAL.gdalopen(f, mode, args...)
end

function gdal_open(func::Function, args...; kwargs...)
  ds = gdal_open(args...; kwargs...)
  try
    func(ds)
  finally
    gdal_close(ds)
  end
end


function gdal_band(f, iband=1)
  # ds = GDAL.gdalopen(raster_file, GDAL.GA_ReadOnly)
  gdal_open(f) do ds
    GDAL.gdalgetrasterband(ds, iband)
  end
end


function nband(f)
  gdal_open(f) do ds
    GDAL.gdalgetrastercount(ds)
  end
end

nraster = nband
nlyr = nband


# function nlayer(f)
#   AG.read(f) do ds
#     AG.nlayer(ds)
#   end
# end

# function nband(file::AbstractString)
#     # ArchGDAL.unsafe_read(file) do ds
#     ArchGDAL.read(file) do ds
#         ArchGDAL.nraster(ds)
#     end
# end

function bandnames(f)
  n = nband(f)
  gdal_open(f) do ds

    map(iband -> begin
        band = GDAL.gdalgetrasterband(ds, iband)
        GDAL.gdalgetdescription(band)
      end, 1:n)
  end
end

# works
function set_bandnames(f, bandnames)
  n = nband(f)
  gdal_open(f, GDAL.GA_Update) do ds
    map(iband -> begin
        band = GDAL.gdalgetrasterband(ds, iband)
        GDAL.gdalsetdescription(band, bandnames[iband])
      end, 1:n)
  end
  nothing
end


function gdal_info(f)
  run(`$(gdalinfo_path()) $f`)
  nothing
end

function ogr_info(f)
  run(`$(ogrinfo_path()) $f`)
  nothing
end


# function ogr_open(f::AbstractString, mode=GDAL.GA_ReadOnly, args...)
#   GDAL.ogr_dr_open(f, mode, args...)
# end

# function ogr_open(func::Function, args...; kwargs...)
#   ds = ogr_open(args...; kwargs...)
#   try
#     func(ds)
#   finally
#     gdal_close(ds)
#   end
# end

# export ogr_open
